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
    @IBOutlet weak var noResultLabel: UILabel!
    private var tableViewAdapter: TableViewAdapter?
    private let viewModel: PlaceSearchViewModel
    var locationManager: LocationManager?

    init(_ viewModel: PlaceSearchViewModel, locationManager: LocationManager) {
        self.viewModel = viewModel
        self.locationManager = locationManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = PlaceSearchViewModel(FoursquareRepository())
        locationManager = CLLocationManager()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewAdapter = .init(tableView, cell: PlaceSearchTableViewCell())
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestLocation()
    }

    private func updateNoResultView() {
        noResultLabel.isHidden = !viewModel.placeList.isEmpty
        tableView.isHidden = viewModel.placeList.isEmpty
    }

    @IBAction func reloadData(_ sender: Any) {
        Spinner.shared.showOn(view)
        locationManager?.requestLocation()
    }

    private func fetchData() {
        guard let location = locationManager?.location else {
            Alert.show(vc: self, title: "Error", message: "Unable to get user's location")
            return
        }
        Spinner.shared.showOn(view)
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let ll: String = String(latitude) + "," + String(longitude)
        viewModel.fetchData(ll: ll) { result in
            Spinner.shared.hide()
            switch result {
            case .success:
                self.tableViewAdapter?.updateData( self.viewModel.placeList)
                self.updateNoResultView()
            case .failure(let error):
                Alert.show(vc: self, title: "Error", message: error.message)
            }
        }
    }
}

extension PlaceSearchViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Spinner.shared.hide()
        fetchData()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Spinner.shared.hide()
        Alert.show(vc: self, title: "Error", message: "Unable to get user's location, please try again")
    }
}
