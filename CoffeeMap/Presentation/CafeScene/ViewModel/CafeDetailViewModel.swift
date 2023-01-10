//
//  CafeDetailViewModel.swift
//  CoffeeMap
//
//  Created by wyn on 2023/1/10.
//

struct CafeDetailViewModelActions {
    let showCafeRoute: (CafeTableViewCellModel) -> Void
}

protocol CafeDetailViewModelInput {
}

protocol CafeDetailViewModelOutput {
}

protocol CafeDetailViewModelType: CafeDetailViewModelInput, CafeDetailViewModelOutput {}

struct CafeDetailViewModel {
    let title: String
    let address: String
    let photos: [CafePhotoModel]
    private let actions: CafeDetailViewModelActions

    init(_ cellModel: CafeTableViewCellModel, actions: CafeDetailViewModelActions) {
        self.title = cellModel.name
        self.address = cellModel.address
        self.photos = cellModel.photos
        self.actions = actions
    }
}

extension CafeDetailViewModel: CafeDetailViewModelType {
    
}
