//
//  ViewLocationViewController.swift
//  181545-proj
//
//  Created by SOCD on 1/21/23.
//  Copyright © 2023 BD. All rights reserved.
//
import Foundation
import UIKit
import MapKit
public class ViewLocationViewController: UIViewController {
    
    var location: Location!
    var mapView = MKMapView()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        view.addSubview(mapView)
    }
    
    func setupNav(){
        self.navigationItem.title = "View Location"
        let leftButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(self.dismissViewLocation))
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func dismissViewLocation(){
        dismiss(animated: true, completion: nil)
    }
    
    override public func viewDidLayoutSubviews() {
        mapView.frame = view.bounds
        // Remove prior pins
        
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        
        // Add a map pin
        
        let pin = MKPointAnnotation()
        let coordinates = CLLocationCoordinate2D(latitude: location.coordinates.lat, longitude: location.coordinates.lon)
        pin.coordinate = coordinates
        mapView.addAnnotation(pin)
        mapView.setRegion(MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)), animated: true)
    }
}
