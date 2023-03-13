//
//  CafeDetailViewModel.swift
//  CoffeeMap
//
//  Created by wyn on 2023/1/10.
//

struct CafeDetailViewModelActions {
    let showCafeRoute: (CafeTableViewCellModel) -> Void
    let didSelectImage: (ImageRotatorViewModel) -> Void
}

protocol CafeDetailViewModelInput {
    func didSelectShowRouterBtn()
    func didSelectImage(_ viewModel: ImageRotatorViewModel)
}

protocol CafeDetailViewModelOutput {
    var title: String { get }
    var address: String { get }
    var description: String? { get }
    var imageCellViewModels: [ImageRotatorCollectionCellViewModel] { get }
}

protocol CafeDetailViewModelType: CafeDetailViewModelInput, CafeDetailViewModelOutput {}

struct CafeDetailViewModel {
    let title: String
    let address: String
    let description: String?
    let imageCellViewModels: [ImageRotatorCollectionCellViewModel]
    let photos: [CafePhotoModel]
    private let cellModel: CafeTableViewCellModel
    private let actions: CafeDetailViewModelActions

    init(_ cellModel: CafeTableViewCellModel, actions: CafeDetailViewModelActions) {
        title = cellModel.name
        address = cellModel.address
        photos = cellModel.photos
        imageCellViewModels = cellModel.photos.toImageRotatorColls()
        self.actions = actions
        self.cellModel = cellModel
        description = cellModel.description
    }
}

extension CafeDetailViewModel: CafeDetailViewModelType {
    func didSelectShowRouterBtn() {
        actions.showCafeRoute(cellModel)
    }

    func didSelectImage(_ viewModel: ImageRotatorViewModel) {
        actions.didSelectImage(viewModel)
    }
}

extension CafePhotoModel {
    func toImageRotatorColl() -> ImageRotatorCollectionCellViewModel {
        ImageRotatorCollectionCellViewModel(self)
    }
}

extension Array where Element == CafePhotoModel {
    func toImageRotatorColls() -> [ImageRotatorCollectionCellViewModel] {
        map { $0.toImageRotatorColl() }
    }
}
