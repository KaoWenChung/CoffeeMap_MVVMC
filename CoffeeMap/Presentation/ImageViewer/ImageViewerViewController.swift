//
//  ImageViewerViewController.swift
//  CoffeeMap
//
//  Created by wyn on 2023/1/17.
//

import UIKit

final class ImageViewerViewController: UIViewController {
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var closeButton: UIButton!
    @IBOutlet weak private var pageLabel: UILabel!
    @IBOutlet weak private var leftButton: UIButton!
    @IBOutlet weak private var rightButton: UIButton!
    @IBOutlet weak private var bottomView: UIView!
    private let viewModel: ImageViwerViewModelType
    
    private var imageRepository: ImageRepositoryType?
    private var collectionViewAdapter: CollectionViewAdapter?
    
    var completion: ((_ aIndex: Int) -> Void)? = nil
    
    init(viewModel: ImageViwerViewModelType, imageRepository: ImageRepositoryType) {
        self.viewModel = viewModel
        self.imageRepository = imageRepository
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAdapter()
    }
    private func initAdapter() {
        collectionViewAdapter = .init(collectionView)
        collectionViewAdapter?.register(ImageRotatorCollectionViewCell.self)
        collectionViewAdapter?.delegate = self
    }

    private func setView2Past() {
        if let frame = viewModel.pastImageRect {
            let viewHeight: CGFloat = collectionView.frame.size.height
            let safeAreaSpacing: CGFloat = collectionView.safeAreaInsets.top
            let imageMidAnchor: CGFloat = frame.midY
            collectionView.transform = CGAffineTransform(translationX: 0, y: -(((viewHeight + safeAreaSpacing) / 2) - imageMidAnchor))
        }
    }
    @IBAction private func tapRecognizer(_ sender: Any) {
        viewModel.toggleShowButtons()
        UIView.animate(withDuration: 0.2) {
            self.closeButton.alpha = self.viewModel.isShowButtons ? 1 : 0
            self.bottomView.alpha = self.viewModel.isShowButtons ? 1 : 0
        }
    }
    private func updateBottomView() {
        let newPage = Int(collectionView.contentOffset.x / collectionView.frame.size.width) + 1
        viewModel.setPage(newPage)
        leftButton.isHidden = viewModel.page == 1
        rightButton.isHidden = viewModel.page == viewModel.imageUrlList.count
        pageLabel.text = viewModel.page.description + "/ " + viewModel.imageUrlList.count.description
    }
    @IBAction private func clickCloseHandler() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            let cell: ImageViewerCollectionViewCell? = self.collectionView.cellForItem(at: IndexPath(row: self.viewModel.page - 1, section: 0)) as? ImageViewerCollectionViewCell
            cell?.zoomOut()
            self.setView2Past()
            self.view.backgroundColor = .clear
        }
        delayClose()
    }
    @IBAction private func tapArrowBtnsHandler(_ sender: UIButton) {
        let row2Scroll: Int = (viewModel.page - 1) + (sender.tag == 0 ? -1 : 1)
        guard row2Scroll >= 0, row2Scroll < viewModel.imageUrlList.count else { return }
        scrollTo(row2Scroll)
    }
    private func scrollTo(_ aRow: Int, animated aAnimated: Bool = true) {
        let indexPath = IndexPath(row: aRow, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: aAnimated)
    }
    private func runExitAnimation(isUp: Bool, _ aBgAlpha: CGFloat = 1) {
        view.backgroundColor = .black.withAlphaComponent(aBgAlpha)
        let transformY: CGFloat = isUp ? view.frame.height : -view.frame.height
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            self.collectionView.transform.ty = transformY
            self.view.backgroundColor = .clear
        }
        delayClose()
    }
    private func delayClose() {
        completion?(viewModel.page)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.dismiss(animated: false)
        }
    }
}

extension ImageViewerViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updateBottomView()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateBottomView()
    }
}

extension ImageViewerViewController: ImageViewerCollectionViewCellDelegate {
    func imageViewerCollectionViewCell(contentOffset aOffset: CGFloat) {
        guard !viewModel.isDismiss else { return }
        var alpha: CGFloat = 0
        let asbOffset: CGFloat = abs(aOffset)
        let valueToMinus = asbOffset / 50
        switch asbOffset {
        case 30...80: // Fade out
            alpha = 1.6 - valueToMinus
        case 80...: // turn off
            viewModel.toggleDismiss()
            runExitAnimation(isUp: aOffset < 0, alpha)
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
        case (let model as ImageRotatorCollectionCellViewModel, let view as ImageViewerCollectionViewCell):
            guard let imageRepository else { return }
            view.setImage(viewModel.imageUrlList[indexPath.row])
            view.delegate = self
        default:
            break
        }
    }
    
    func select(model: AdapterItemModel) {
        print("doing nothing")
    }
    
    func size(model: AdapterItemModel, containerSize: CGSize) -> CGSize {
        let _width : CGFloat = collectionView.frame.size.width
        let _height: CGFloat = collectionView.frame.size.height
        return CGSize(width: _width, height: _height)
    }
}
