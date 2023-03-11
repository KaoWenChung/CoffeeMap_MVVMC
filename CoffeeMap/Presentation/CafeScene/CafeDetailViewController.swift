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

    private let viewModel: CafeDetailViewModelType
    private let imageRepository: ImageRepositoryType

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = viewModel.title
        addressLabel.text = viewModel.address
        imageRotatorView.setup(viewModel.imageCellViewModels, imageRepository: imageRepository)
        imageRotatorView.delegate = self
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .clear
    }
    
    init(_ viewModel: CafeDetailViewModel, imageRepository: ImageRepositoryType) {
        self.viewModel = viewModel
        self.imageRepository = imageRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction private func didSelectShowRouterBtn() {
        viewModel.didSelectShowRouterBtn()
    }
}

extension CafeDetailViewController: ImageRotatorViewDelegate {
    func didSelectImage(_ viewModel: ImageRotatorViewModel) {
        self.viewModel.didSelectImage(viewModel)
    }
}
