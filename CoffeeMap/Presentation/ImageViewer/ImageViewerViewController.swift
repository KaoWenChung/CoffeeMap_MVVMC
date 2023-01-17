//
//  ImageViewerViewController.swift
//  CoffeeMap
//
//  Created by wyn on 2023/1/17.
//

import UIKit

class ImageViewerViewController: UIViewController {

    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var closeButton: UIButton!
    @IBOutlet weak private var pageLabel: UILabel!
    @IBOutlet weak private var leftButton: UIButton!
    @IBOutlet weak private var rightButton: UIButton!
    @IBOutlet weak private var bottomView: UIView!
    private let viewModel: LTImageViwerViewModel
    
    private var imageRepository: ImageRepositoryType?
    private var collectionViewAdapter: CollectionViewAdapter?
    
    var completion: ((_ aIndex: Int) -> Void)? = nil
    
    init(viewModel: LTImageViwerViewModel, imageRepository: ImageRepositoryType) {
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

    /// 移動畫面到前一個畫面的位置(只移動y座標)
    private func setView2Past() {
        // collectionView cell 置中，因此可當作中心點位置的座標y為畫面的一半高度，先扣除畫面的一半高度後使中心點座標y歸0，再移動到指定畫面的中心點位置使之重疊
        if let frame = viewModel.pastImageRect {
            // 整個畫面的高度
            let viewHeight: CGFloat = collectionView.frame.size.height
            // safe area 高度(status Bar etc.)
            let safeAreaSpacing: CGFloat = collectionView.safeAreaInsets.top
            // 前一圖的中心點(高度的一半)
            let imageMidAnchor: CGFloat = frame.midY
            collectionView.transform = CGAffineTransform(translationX: 0, y: -(((viewHeight + safeAreaSpacing) / 2) - imageMidAnchor))
        }
    }
    /// 點擊畫面時消失/ 隱藏UI 左、右、離開按鈕、頁數
    @IBAction private func tapRecognizer(_ sender: Any) {
        viewModel.isShowButtons.toggle()
        UIView.animate(withDuration: 0.2) {
            self.closeButton.alpha = self.viewModel.isShowButtons ? 1 : 0
            self.bottomView.alpha = self.viewModel.isShowButtons ? 1 : 0
        }
    }
    /// 更新底部視圖(頁數、判斷是否為第一頁或最後一頁來隱藏左右按鈕)
    private func updateBottomView() {
        viewModel.page = Int(collectionView.contentOffset.x / collectionView.frame.size.width) + 1
        // 位於第一頁時隱藏左邊按鈕
        leftButton.isHidden = viewModel.page == 1
        // 位於最後一頁時隱藏右邊按鈕
        rightButton.isHidden = viewModel.page == viewModel.imageUrlList.count
        pageLabel.text = viewModel.page.description + "/ " + viewModel.imageUrlList.count.description
    }
    /// 點擊close按鈕關閉畫面
    @IBAction private func clickCloseHandler() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            let cell: ImageViewerCollectionViewCell? = self.collectionView.cellForItem(at: IndexPath(row: self.viewModel.page - 1, section: 0)) as? ImageViewerCollectionViewCell
            cell?.zoomOut()
            self.setView2Past()
            self.view.backgroundColor = .clear
        }
        delayClose()
    }
    /// 點擊翻頁按鈕
    @IBAction private func tapArrowBtnsHandler(_ sender: UIButton) {
        let row2Scroll: Int = (viewModel.page - 1) + (sender.tag == 0 ? -1 : 1)
        // 0頁點擊左邊、最後一頁點擊右邊時中斷
        guard row2Scroll >= 0, row2Scroll < viewModel.imageUrlList.count else { return }
        scrollTo(row2Scroll)
    }
    /// 滑動至指定頁數
    private func scrollTo(_ aRow: Int, animated aAnimated: Bool = true) {
        let indexPath = IndexPath(row: aRow, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: aAnimated)
    }
    /// 執行關閉動畫
    private func runExitAnimation(isUp: Bool, _ aBgAlpha: CGFloat = 1) {
        view.backgroundColor = .black.withAlphaComponent(aBgAlpha)
        let transformY: CGFloat = isUp ? view.frame.height : -view.frame.height
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) { // completion => 沒有用, 改用asyncAfter延遲關閉
            self.collectionView.transform.ty = transformY
            self.view.backgroundColor = .clear
        }
        delayClose()
    }
    /// 延遲0.2秒關閉畫面
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
            viewModel.isDismiss.toggle()
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
        // TODO: Image Viewer
    }
    
    func size(model: AdapterItemModel, containerSize: CGSize) -> CGSize {
        let _width : CGFloat = collectionView.frame.size.width
        let _height: CGFloat = collectionView.frame.size.height
        return CGSize(width: _width, height: _height)
    }
}
