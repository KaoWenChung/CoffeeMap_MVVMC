//
//  ImageViewerViewController.swift
//  CoffeeMap
//
//  Created by wyn on 2023/1/17.
//

import UIKit

protocol ImageViewerViewControllerDelegate: AnyObject {
    func didDissmissedView(stopAtIndex index: Int)
}

final class ImageViewerViewController: UIViewController {
    enum Content {
        static let previousPageButtonTag = 0
        static let previousPage = -1
        static let nextPage = 1
        static let scrollBufferSpace: CGFloat = 50
        static let fadeoutRange: ClosedRange<CGFloat> = 30...80
        static let turnOffRange: PartialRangeFrom<CGFloat> = 80...
        static let alphaToMinus = 1.6
    }

    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var closeButton: UIButton!
    @IBOutlet weak private var pageLabel: UILabel!
    @IBOutlet weak private var leftButton: UIButton!
    @IBOutlet weak private var rightButton: UIButton!
    @IBOutlet weak private var bottomView: UIView!
    private let viewModel: ImageViewerViewModelType

    private var imageRepository: ImageRepositoryType?
    private var collectionViewAdapter: CollectionViewAdapter?

    weak var delegate: ImageViewerViewControllerDelegate?

    init(viewModel: ImageViewerViewModelType, imageRepository: ImageRepositoryType) {
        self.viewModel = viewModel
        self.imageRepository = imageRepository
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initAdapter()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if viewModel.page < collectionView.numberOfItems(inSection: 0) {
            scrollTo(viewModel.page, animated: false)
            updateBottomView()
        }
    }

    // MARK: IBAction functions
    @IBAction private func tapRecognizer(_ sender: Any) {
        viewModel.toggleShowButtons()
        UIView.animate(withDuration: 0.2) {
            self.closeButton.alpha = self.viewModel.isShowButtons ? 1 : 0
            self.bottomView.alpha = self.viewModel.isShowButtons ? 1 : 0
        }
    }

    @IBAction private func clickCloseHandler() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            let cell = self.collectionView.cellForItem(at: IndexPath(row: self.viewModel.page - 1,
                                                                     section: 0)) as? ImageViewerCollectionViewCell
            cell?.zoomOut()
            self.setView2Past()
            self.view.backgroundColor = .clear
        }
        delayClose()
    }

    @IBAction private func onChangedPageButton(_ sender: UIButton) {
        let offset = sender.tag == Content.previousPageButtonTag ? Content.previousPage : Content.nextPage
        let row2Scroll: Int = (viewModel.page - 1) + offset
        guard row2Scroll >= 0, row2Scroll < viewModel.imageUrlList.count else { return }
        scrollTo(row2Scroll)
        viewModel.setPage(viewModel.page + offset)
    }
    // MARK: Private functions
    private func initAdapter() {
        collectionViewAdapter = .init(collectionView)
        collectionViewAdapter?.register(ImageViewerCollectionViewCell.self)
        collectionViewAdapter?.delegate = self
        collectionViewAdapter?.didEndDeceleratingDelegate = self
        collectionViewAdapter?.didEndScrollingAnimationDelegate = self
        collectionViewAdapter?.updateData(viewModel.imageUrlList)
    }

    private func setView2Past() {
        guard let frame = viewModel.pastImageRect else { return }
        let viewHeight: CGFloat = collectionView.frame.size.height
        let safeAreaSpacing: CGFloat = collectionView.safeAreaInsets.top
        let imageMidAnchor: CGFloat = frame.midY
        collectionView.transform = CGAffineTransform(translationX: 0,
                                                     y: -(((viewHeight + safeAreaSpacing) / 2) - imageMidAnchor))
    }

    private func updateBottomView() {
        let newPage = Int(collectionView.contentOffset.x / collectionView.frame.size.width) + 1
        viewModel.setPage(newPage)
        leftButton.isHidden = viewModel.page == 1
        rightButton.isHidden = viewModel.page == viewModel.imageUrlList.count
        pageLabel.text = viewModel.page.description + "/ " + viewModel.imageUrlList.count.description
    }

    private func scrollTo(_ row: Int, animated: Bool = true) {
        let indexPath = IndexPath(row: row, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
    }

    private func runExitAnimation(isUp: Bool, _ alpha: CGFloat = 1) {
        view.backgroundColor = .black.withAlphaComponent(alpha)
        let transformY: CGFloat = isUp ? view.frame.height : -view.frame.height
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            self.collectionView.transform.ty = transformY
            self.view.backgroundColor = .clear
        }
        delayClose()
    }

    private func delayClose() {
        delegate?.didDissmissedView(stopAtIndex: viewModel.page)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.dismiss(animated: false)
        }
    }
}

extension ImageViewerViewController: CollectionAdapterDecelerateDelegate {
    func didEndDecelerating(_ scrollView: UIScrollView) {
        updateBottomView()
    }
}

extension ImageViewerViewController: CollectionAdapterScrollDelegate {
    func didEndScrollingAnimation(_ scrollView: UIScrollView) {
        updateBottomView()
    }
}

extension ImageViewerViewController: ImageViewerCollectionViewCellDelegate {
    func imageViewerCollectionViewCell(contentOffset: CGFloat) {
        guard !viewModel.isDismiss else { return }
        var alpha: CGFloat = 0
        let asbOffset: CGFloat = abs(contentOffset)
        let valueToMinus = asbOffset / Content.scrollBufferSpace
        switch asbOffset {
        // Fade out
        case Content.fadeoutRange:
            alpha = Content.alphaToMinus - valueToMinus
        // turn off
        case Content.turnOffRange:
            viewModel.toggleDismiss()
            runExitAnimation(isUp: contentOffset < 0, alpha)
            return
        default:
            alpha = 1
        }
        view.backgroundColor = .black.withAlphaComponent(alpha)
    }
}

extension ImageViewerViewController: TableCollectionViewAdapterDelegate {
    func configure(model: AdapterItemModel, view: UIView, indexPath: IndexPath) {
        switch (model, view) {
        case (let model as ImageViewerCollectionCellViewModel, let view as ImageViewerCollectionViewCell):
            guard let imageRepository else { return }
            view.setupView(model, imageRepository: imageRepository)
            view.delegate = self
        default:
            break
        }
    }

    func select(model: AdapterItemModel) {}

    func size(model: AdapterItemModel, containerSize: CGSize) -> CGSize {
        let width: CGFloat = collectionView.frame.size.width
        let height: CGFloat = collectionView.frame.size.height
        return CGSize(width: width, height: height)
    }
}
