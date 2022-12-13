//
//  CafeListViewController.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import UIKit
import CoreLocation

final class CafeListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultLabel: UILabel!
    private(set) var locationManager: LocationManager?
    private var tableViewAdapter: TableViewAdapter?
    private let viewModel: CafeListViewModelType
    private let refreshControl = UIRefreshControl()

    init(_ viewModel: CafeListViewModelType, locationManager: LocationManager = CLLocationManager()) {
        self.viewModel = viewModel
        self.locationManager = locationManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        tableViewAdapter = .init(tableView)
        tableViewAdapter?.delegate = self
        bind(to: viewModel)
        initLocationManager()
        initBarButton()
        initRefreshControl()
        fetchData()
    }

    private func bind(to viewModel: CafeListViewModelType) {
        viewModel.placeList.observe(on: self) {[weak self] _ in self?.updateTableView()}
    }

    private func updateTableView() {
        tableViewAdapter?.register(viewModel.placeList.value)
        tableViewAdapter?.updateData(viewModel.placeList.value)
        updateNoResultView()
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
        noResultLabel.isHidden = !viewModel.placeList.value.isEmpty
        tableView.isHidden = viewModel.placeList.value.isEmpty
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
        // Testing latitude and longitude -> "51.50998,-0.1337"
        Spinner.shared.showOn(view)
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let ll: String = String(latitude) + "," + String(longitude)
        Task.init() {
            await viewModel.fetchData(ll: ll)
            Spinner.shared.hide()
            updateNoResultView()
        }
    }
}

extension CafeListViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Spinner.shared.hide()
        fetchData()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Spinner.shared.hide()
        Alert.show(vc: self, title: "Error", message: "Unable to get user's location, please try again")
    }

}

extension CafeListViewController: TableViewAdapterDelegate {

    func configure(model: AdapterItemModel, view: UIView, indexPath: IndexPath) {
        switch (model, view) {
        case (let model as CafeListTableViewCellModel, let view as CafeListTableViewCell):
            view.setupView(model)
        default:
            break
        }
    }
    
    func select(model: AdapterItemModel) {
        if let model = model as? CafeListTableViewCellModel {
            viewModel.didSelectItem(model)
        }
        
    }
    
    func size(model: AdapterItemModel, containerSize: CGSize) -> CGSize {
        return CGSize(width: 120, height: 120)
    }
    
    
}
