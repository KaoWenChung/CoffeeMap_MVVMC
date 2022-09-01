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
        // Do any additional setup after loading the view.
    }


}

