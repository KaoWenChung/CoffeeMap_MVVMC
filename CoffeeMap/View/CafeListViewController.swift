//
//  CafeListViewController.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import UIKit
import CoreLocation

final class CafeListViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultLabel: UILabel!
    private(set) var locationManager: LocationManager?
    private var tableViewAdapter: TableViewAdapter?
    private let viewModel: CafeListViewModel
    private let refreshControl = UIRefreshControl()

    init(_ viewModel: CafeListViewModel, locationManager: LocationManager = CLLocationManager()) {
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

    func fetchData(completion: BaseViewModel.Completion? = nil) {
        refreshControl.endRefreshing()
//        guard let location = locationManager?.location else {
//            Alert.show(vc: self, title: "Error", message: "Unable to get user's location")
//            completion?(.failure(CustomError("Unable to get user's location")))
//            return
//        }
        Spinner.shared.showOn(view)
//        let latitude = location.coordinate.latitude
//        let longitude = location.coordinate.longitude
//        let ll: String = String(latitude) + "," + String(longitude)
        viewModel.loadData(cafeQuery: CofeRequestDTO(ll: "51.50998,-0.1337", sort: "DISTANCE"))
//        Task.init() {
//            do {
//                try await viewModel.fetchData(coordinate: ll)
//                Spinner.shared.hide()
//                updateNoResultView()
//                self.tableViewAdapter?.register(self.viewModel.placeList)
//                self.tableViewAdapter?.updateData(self.viewModel.placeList)
//                completion?(.success)
//            } catch let _ {
////                Alert.show(vc: self, title: "Error", message: error.message)
////                completion?(.failure(error))
//            }
//        }
        
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
            break
        default:
            break
        }
    }
    
    func select(model: AdapterItemModel) {
        if let model = model as? CafeListTableViewCellModel {
            let viewModel = CafeDetailViewModel(model)
            open(CafeDetailViewController(viewModel), animated: true)
        }
        
    }
    
    func size(model: AdapterItemModel, containerSize: CGSize) -> CGSize {
        return CGSize(width: 120, height: 120)
    }
    
    
}
