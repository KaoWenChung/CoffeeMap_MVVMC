//
//  CafeDetailViewController.swift
//  CoffeeMap
//
//  Created by wyn on 2023/1/10.
//

import UIKit

final class CafeDetailViewController: UIViewController {

    @IBOutlet weak private var imageRotatorView: ImageRotatorView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var addressLabel: UILabel!

    private let viewModel: CafeDetailViewModel

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = viewModel.title
        addressLabel.text = viewModel.address
    }
    
    init(_ viewModel: CafeDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
