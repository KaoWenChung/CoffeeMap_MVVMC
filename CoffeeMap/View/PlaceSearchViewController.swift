//
//  ViewController.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import UIKit

class PlaceSearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var tableViewAdapter: TableViewAdapter?
    private let viewModel: PlaceSearchViewModel

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
        fetchData(ll: "51.50998,-0.1337")
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

