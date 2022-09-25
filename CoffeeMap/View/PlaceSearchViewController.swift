//
//  ViewController.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import UIKit
import CoreLocation

final class PlaceSearchViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultLabel: UILabel!
    private var tableViewAdapter: TableViewAdapter?
    private(set) var locationManager: LocationManager?
    private let viewModel: PlaceSearchViewModel
    private let refreshControl = UIRefreshControl()

    init(_ viewModel: PlaceSearchViewModel = PlaceSearchViewModel(FoursquareRepository()), locationManager: LocationManager = CLLocationManager()) {
        self.viewModel = viewModel
        self.locationManager = locationManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = PlaceSearchViewModel(FoursquareRepository())
        locationManager = CLLocationManager()
        super.init(coder: coder)
    }

    // MARK: Pull down to update the view
    private func initRefreshControl() {
        refreshControl.addTarget(self, action: #selector(onPullReloadDataHandler), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc private func onPullReloadDataHandler() {
        if refreshControl.isRefreshing {
            fetchData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nearby Cafe List"
        tableViewAdapter = .init(tableView, cell: PlaceSearchTableViewCell())
        initLocationManager()
        initBarButton()
        initRefreshControl()
        fetchData()
    }

    private func initLocationManager() {
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestLocation()
    }

    private func initBarButton() {
        let reloadButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(reloadData(_:)))
        navigationItem.rightBarButtonItem = reloadButton
    }

    private func updateNoResultView() {
        noResultLabel.isHidden = !viewModel.placeList.isEmpty
        tableView.isHidden = viewModel.placeList.isEmpty
    }

    @objc private func reloadData(_ sender: Any) {
        Spinner.shared.showOn(view)
        locationManager?.requestLocation()
    }

    func fetchData() {
        refreshControl.endRefreshing()
        guard let location = locationManager?.location else {
            Alert.show(vc: self, title: "Error", message: "Unable to get user's location")
            return
        }
        Spinner.shared.showOn(view)
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let ll: String = String(latitude) + "," + String(longitude)
        viewModel.fetchData(coordinate: ll) { result in
            DispatchQueue.main.async {
                Spinner.shared.hide()
                switch result {
                case .success(let value):
                    self.updateNoResultView()
                    let sortedValue = self.viewModel.getSortedGetPlaceResult(value)
                    self.viewModel.getPlaceListBy(sortedValue, cellAction: { cellModel in
                        self.setCellAction(cellModel)
                    })
                    self.tableViewAdapter?.updateData( self.viewModel.placeList )
                case .failure(let error):
                    Alert.show(vc: self, title: "Error", message: error.message)
                }
            }
        }
    }

    private func setCellAction(_ rowModel: BaseCellRowModel) {
        guard let rowModel = rowModel as? PlaceSearchTableViewCellRowModel else { return }
        let nextPage = PlaceDetailViewController(PlaceDetailViewModel(rowModel))
        self.open(nextPage, animated: true)
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
