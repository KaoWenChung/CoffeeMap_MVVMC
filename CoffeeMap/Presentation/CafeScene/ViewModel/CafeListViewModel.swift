//
//  CafeListViewModel.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

struct CafeListViewModelActions {
    let showCafeRoute: (CafeListTableViewCellModel) -> Void
}

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
        do {
            cafesLoadTask = try await searchCafeUseCase?.execute(request: cafeQuery) { result in
                switch result {
                case .success(let value):
                    self.placeList = [AdapterSectionModel(items: value)]
                case .failure(let error):
                    print(error)
                }
            }
        } catch {
            
        }
        
    }

}
