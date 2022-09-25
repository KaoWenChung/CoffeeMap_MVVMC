//
//  PlaceDetailViewController.swift
//  CoffeeMap
//
//  Created by wyn on 2022/9/25.
//

import UIKit
import MapKit

class PlaceDetailViewController: UIViewController {

    @IBOutlet weak private var mapView: MKMapView!
    private let viewModel: PlaceDetailViewModel

    init(_ viewModel: PlaceDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
