//
//  ResultsViewController.swift
//  181545-proj
//
//  Created by SOCD on 1/18/23.
//  Copyright © 2023 BD. All rights reserved.
//

import UIKit
import CoreLocation

protocol ResultsViewControllerDelegate: AnyObject{
    func didTapPlace(with coordinates: CLLocationCoordinate2D)
    func didTapPlace(for place: Place)
}

class ResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = places[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.isHidden = true
        
        let place = places[indexPath.row]
        GooglePlacesManager.shared.resolveLocation(for: place){ result in
            switch result{
            case .success(let coordinate):
                DispatchQueue.main.async {
                    self.delegate?.didTapPlace(with: coordinate)
                    self.delegate?.didTapPlace(for: place)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    weak var delegate: ResultsViewControllerDelegate?
    private var places: [Place] = []
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .clear
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
    
    public func update(with places: [Place]){
        self.tableView.isHidden = false
        self.places = places
        tableView.reloadData()
    }

}
