//
//  CafeListViewModel.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

struct CafeListViewModelActions {
    let showCafeRoute: (CafeListTableViewCellModel) -> Void
}

protocol CafeListViewModelInput {
    func viewDidLoad()
    func didLoadNextPage()
    func didSelectItem(at index: Int)
}

protocol CafeListViewModelOutput {
}

protocol CafeListViewModelType: CafeListViewModelInput, CafeListViewModelOutput {}

final class CafeListViewModel {

    private let searchCafeUseCase: SearchCafeUseCaseType?
    private let actions: CafeListViewModelActions?
    
    private(set) var placeList: [AdapterSectionModel] = []

    private var cafesLoadTask: CancellableType? { willSet { cafesLoadTask?.cancel() } }
    
    init(searchCafeUseCase: SearchCafeUseCaseType? = nil,
         actions: CafeListViewModelActions? = nil) {
        self.searchCafeUseCase = searchCafeUseCase
        self.actions = actions
    }

    func loadData(cafeQuery: CofeRequestDTO) async {
    }

}
