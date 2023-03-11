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
        case sortTitle
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
            viewModel.refreshQuery()
            fetchDataTask()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = CafeListViewControllerString.title.text
        tableViewAdapter = .init(tableView)
        tableViewAdapter?.register(CafeTableViewCell.self)
        tableViewAdapter?.delegate = self
        bind(to: viewModel)
        initLocationManager()
        initBarButton()
        initRefreshControl()
        fetchDataTask()
    }

    func fetchDataByLocation() async {
        refreshControl.endRefreshing()
        guard let location = locationManager?.location else {
            showAlert(style: .alert, title: viewModel.errorTitle, message: ErrorString.failGetLocation.text, cancel: CommonString.ok.text)
            return
        }
        Spinner.shared.showOn(view)
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let latitudeLongitude: String = String(latitude) + "," + String(longitude)
        await viewModel.fetchDataBy(latitudeLongitude: latitudeLongitude)
        Spinner.shared.hide()
        updateNoResultView()
    }
    // MARK: - Private functions
    private func bind(to viewModel: CafeListViewModelType) {
        viewModel.placeList.observe(on: self) {[weak self] _ in self?.updateTableView()}
        viewModel.error.observe(on: self) {[weak self] in self?.showError($0)}
    }

    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(style: .alert, title: viewModel.errorTitle, message: error, cancel: CommonString.ok.text)
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
        let reloadButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: ImageContents.arrowClockwise), style: .plain, target: self, action: #selector(refreashAll))
        let sortButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: ImageContents.sort), style: .plain, target: self, action: #selector(sortList))
        navigationItem.rightBarButtonItems = [reloadButton, sortButton]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    private func updateNoResultView() {
        noResultLabel.isHidden = !viewModel.placeList.value.isEmpty
        tableView.isHidden = viewModel.placeList.value.isEmpty
    }

    @objc private func refreashAll() {
        Spinner.shared.showOn(view)
        viewModel.refreshQuery()
        locationManager?.requestLocation()
    }

    @objc private func sortList() {
        let buttons: [AlertAction.Button] = [
            AlertAction.Button.default(CafeListViewModel.SortType.distance.rawValue),
            AlertAction.Button.default(CafeListViewModel.SortType.popularity.rawValue)]
        showAlert(style: .actionSheet, title: CafeListViewControllerString.sortTitle.text,cancel: CommonString.cancel.text, others: buttons) { action in
            if let value = CafeListViewModel.SortType.init(rawValue: action.title) {
                self.didSortList(value)
            }
        }
    }
    
    private func didSortList(_ sort: CafeListViewModel.SortType) {
        Spinner.shared.showOn(view)
        Task.init {
            await viewModel.didSortList(sort)
            Spinner.shared.hide()
        }
    }

    private func fetchDataTask() {
        Task.init {
            await fetchDataByLocation()
        }
    }

    private func loadNextPage() {
        Task.init {
            Spinner.shared.showOn(self.view)
            await viewModel.didLoadNextPage()
            Spinner.shared.hide()
        }
    }
}

extension CafeListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Spinner.shared.hide()
        fetchDataTask()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Spinner.shared.hide()
        showAlert(style: .alert, title: viewModel.errorTitle, message: ErrorString.failGetLocation.text, cancel: CommonString.ok.text)
    }
}

extension CafeListViewController: TableCollectionViewAdapterDelegate {
    func configure(model: AdapterItemModel, view: UIView, indexPath: IndexPath) {
        switch (model, view) {
        case (let model as CafeTableViewCellModel, let view as CafeTableViewCell):
            view.setupView(model, imageRepository: imageRepository)
        default:
            break
        }
        // Pagination
        if indexPath.row == viewModel.placeList.value.count - 1 {
            loadNextPage()
        }
    }
    
    func select(model: AdapterItemModel) {
        if let model = model as? CafeTableViewCellModel {
            viewModel.didSelectItem(model)
        }
    }
    
    func size(model: AdapterItemModel, containerSize: CGSize) -> CGSize {
        return CGSize(width: Contents.tableViewWidthHeight, height: Contents.tableViewWidthHeight)
    }
}
