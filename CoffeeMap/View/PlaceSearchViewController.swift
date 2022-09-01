//
//  ViewController.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import UIKit
import CoreLocation

class PlaceSearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var tableViewAdapter: TableViewAdapter?
    private let viewModel: PlaceSearchViewModel
    let locationManager = CLLocationManager()

    init(_ viewModel: PlaceSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = PlaceSearchViewModel(FoursquareRepository())
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewAdapter = .init(tableView, cell: PlaceSearchTableViewCell())
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    @IBAction func reloadData(_ sender: Any) {
        locationManager.requestLocation()
    }

    private func fetchData(ll: String) {
        viewModel.fetchData(ll: ll) { result in
            switch result {
            case .success:
                self.tableViewAdapter?.updateData( self.viewModel.placeList)
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension PlaceSearchViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let ll: String = String(latitude) + "," + String(longitude)
            fetchData(ll: ll)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        // Handle failure to get a user’s location
    }
}
