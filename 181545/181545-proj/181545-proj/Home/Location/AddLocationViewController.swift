//
//  AddLocationViewController.swift
//  181545-proj
//
//  Created by SOCD on 12/18/22.
//  Copyright © 2022 BD. All rights reserved.
//
import Foundation
import UIKit
import MapKit
class AddLocationViewController: UIViewController, UISearchResultsUpdating{
    
    @IBOutlet weak var mapView: MKMapView!
    var user: User!
    let searchVC = UISearchController(searchResultsController: ResultsViewController())
    var lastSelected: Place!
    var locationTableView: UITableView!
    
    @IBOutlet weak var SubmitButton: UIButton!
    override func viewDidLoad() {
        setupUI()
        setupNav()
        //view.addSubview(mapView)-
        searchVC.searchResultsUpdater = self
    }
    
    override func viewDidLayoutSubviews() {
        //mapView.frame = view.bounds
    }
    
    func setupUI(){
        
    }
    func setupNav(){
        self.navigationItem.title = "Add Location"
        let leftButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(self.dismissAddLocation))
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.searchController = searchVC
    }
    
    func updateSearchResults(for searchController: UISearchController){
        guard let query = searchController.searchBar.text,
            !query.trimmingCharacters(in: .whitespaces).isEmpty,
            let resultVC = searchController.searchResultsController as? ResultsViewController else{
            return
        }
        
        resultVC.delegate = self
        
        GooglePlacesManager.shared.findPlaces(query: query){ result in
            switch result {
            case .success(let places):
                DispatchQueue.main.async {
                    resultVC.update(with: places)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    @IBAction func submitLocation(_ sender: Any) {

        GooglePlacesManager.shared.resolveLocation(for: lastSelected){result in
            switch result{
            case .success(let coordinates):
                let coords = Coords(lat: coordinates.latitude, lon: coordinates.longitude)
                let loc = Location(name: self.lastSelected.name, coordinates: coords, image_url: "?")
                let search = self.user.email + "Locations"
                let decoder = PropertyListDecoder()
                let data = UserDefaults.standard.data(forKey: search)
                var list: LocationList
                if data != nil{
                    list = try! decoder.decode(LocationList.self, from: data!)
                    list.locations.append(loc)
                }else{
                    list = LocationList(locations: [loc])
                }
                let encoder = PropertyListEncoder()
                if let encoded = try? encoder.encode(list){
                    UserDefaults.standard.set(encoded, forKey: search)
                }
                NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadData"), object: nil)
                self.dismissAddLocation()
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    @objc func dismissAddLocation(){
        dismiss(animated: true, completion: nil)
    }
}

extension AddLocationViewController: ResultsViewControllerDelegate{
    func didTapPlace(for place: Place) {
        lastSelected = place
    }
    
    func didTapPlace(with coordinates: CLLocationCoordinate2D) {
        SubmitButton.isHidden = false
        print(SubmitButton.isHidden)
        print(SubmitButton.isEnabled)
        searchVC.searchBar.resignFirstResponder()
        searchVC.dismiss(animated: true, completion: nil)
        // Remove prior pins
        
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        
        // Add a map pin
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        mapView.addAnnotation(pin)
        mapView.setRegion(MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)), animated: true)
    }
}
