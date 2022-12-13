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
    func fetchData(ll: String) async
    func didSelectItem(_ viewModel: CafeListTableViewCellModel)
}

protocol CafeListViewModelOutput {
    var placeList: Observable<[AdapterSectionModel]> { get }
}

protocol CafeListViewModelType: CafeListViewModelInput, CafeListViewModelOutput {}

final class CafeListViewModel: CafeListViewModelType {

    private let searchCafeUseCase: SearchCafeUseCaseType
    private let actions: CafeListViewModelActions?
    
    private(set) var placeList: Observable<[AdapterSectionModel]> = Observable([])

    private var cafesLoadTask: CancellableType? { willSet { cafesLoadTask?.cancel() } }
    
    init(searchCafeUseCase: SearchCafeUseCaseType,
         actions: CafeListViewModelActions?) {
        self.searchCafeUseCase = searchCafeUseCase
        self.actions = actions
    }

}
extension CafeListViewModel {
    func fetchData(ll: String) async {
        do {
            let (value, task) = try await searchCafeUseCase.execute(request: CofeRequestDTO(ll: ll, sort: "DISTANCE"))
            placeList.value = [AdapterSectionModel(items: value)]
            cafesLoadTask = task
        } catch {
            
        }
    }

    func didSelectItem(_ viewModel: CafeListTableViewCellModel) {
        actions?.showCafeRoute(viewModel)
    }
}
