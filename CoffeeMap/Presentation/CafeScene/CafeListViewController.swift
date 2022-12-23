//
//  CafeListViewController.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import UIKit
import CoreLocation

final class CafeListViewController: UIViewController, Alertable {

    enum CafeListViewControllerString: LocallizedStringType {
        case title
    }

    enum Contents {
        static let tableViewWidthHeight: CGFloat = 120
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultLabel: UILabel!
    private(set) var locationManager: LocationManager?
    private var tableViewAdapter: TableViewAdapter?
    private let viewModel: CafeListViewModelType
    private let imageRepository: ImageRepositoryType
    private let refreshControl = UIRefreshControl()

    init(_ viewModel: CafeListViewModelType, locationManager: LocationManager = CLLocationManager(),
         imageRepository: ImageRepositoryType) {
        self.viewModel = viewModel
        self.locationManager = locationManager
        self.imageRepository = imageRepository
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
            fetchDataTask()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = CafeListViewControllerString.title.text
        tableViewAdapter = .init(tableView)
        tableViewAdapter?.register(CafeListTableViewCell.self)
        tableViewAdapter?.delegate = self
        bind(to: viewModel)
        initLocationManager()
        initBarButton()
        initRefreshControl()
        fetchDataTask()
    }

    private func bind(to viewModel: CafeListViewModelType) {
        viewModel.placeList.observe(on: self) {[weak self] _ in self?.updateTableView()}
        viewModel.error.observe(on: self) {[weak self] in self?.showError($0)}
    }

    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: viewModel.errorTitle, message: error)
    }

    private func updateTableView() {
        tableViewAdapter?.updateData(viewModel.placeList.value)
        updateNoResultView()
    }

    private func initLocationManager() {
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestLocation()
    }

    private func initBarButton() {
        let reloadButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: ImageContents.arrowClockwise), style: .plain, target: self, action: #selector(reloadData(_:)))
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
    
    func fetchDataTask() {
        Task.init {
            await fetchData()
        }
    }

    func fetchData() async {
        refreshControl.endRefreshing()
        guard let location = locationManager?.location else {
            showAlert(title: viewModel.errorTitle, message: ErrorString.failGetLocation.text)
            return
        }
        // Testing latitude and longitude -> "51.50998,-0.1337"
        Spinner.shared.showOn(view)
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let ll: String = String(latitude) + "," + String(longitude)
        await viewModel.fetchData(ll: ll)
        Spinner.shared.hide()
        updateNoResultView()
    }
}

extension CafeListViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Spinner.shared.hide()
        fetchDataTask()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Spinner.shared.hide()
        showAlert(title: viewModel.errorTitle, message: ErrorString.failGetLocation.text)
    }

}

extension CafeListViewController: TableViewAdapterDelegate {

    func configure(model: AdapterItemModel, view: UIView, indexPath: IndexPath) {
        switch (model, view) {
        case (let model as CafeListTableViewCellModel, let view as CafeListTableViewCell):
            view.setupView(model, imageRepository: imageRepository)
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
        return CGSize(width: Contents.tableViewWidthHeight, height: Contents.tableViewWidthHeight)
    }
    
    
}
