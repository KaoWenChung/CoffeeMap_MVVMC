//
//  CafeListViewModel.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

struct CafeListViewModelActions {
    let showCafeRoute: (CafeTableViewCellModel) -> Void
}
protocol CafeListViewModelInput {
    func fetchData(ll: String) async
    func didSelectItem(_ viewModel: CafeTableViewCellModel)
}

protocol CafeListViewModelOutput {
    var placeList: Observable<[AdapterSectionModel]> { get }
    var error: Observable<String> { get }
    var errorTitle: String { get }
}

protocol CafeListViewModelType: CafeListViewModelInput, CafeListViewModelOutput {}

final class CafeListViewModel: CafeListViewModelType {

    private let searchCafeUseCase: SearchCafeListUseCaseType
    private let actions: CafeListViewModelActions?
    
    let placeList: Observable<[AdapterSectionModel]> = Observable([])
    let error: Observable<String> = Observable("")
    let errorTitle: String = CommonString.error.text

    private var cafesLoadTask: CancellableType? { willSet { cafesLoadTask?.cancel() } }
    
    init(searchCafeUseCase: SearchCafeListUseCaseType,
         actions: CafeListViewModelActions?) {
        self.searchCafeUseCase = searchCafeUseCase
        self.actions = actions
    }

    private func handle(error: Error) {
        self.error.value = error.isInternetConnectionError ? ErrorString.noInternet.text : ErrorString.failLoadingCafe.text
    }

}
extension CafeListViewModel {
    func fetchData(ll: String) async {
        let task = Task {
            do {
                let value = try await searchCafeUseCase.execute(request: CafePlaceRequestDTO(ll: ll, sort: "DISTANCE"))
                placeList.value = [AdapterSectionModel(items: value)]
            } catch {
                handle(error: error)
            }
        }
        cafesLoadTask = task
        await task.value
    }

    func didSelectItem(_ viewModel: CafeTableViewCellModel) {
        actions?.showCafeRoute(viewModel)
    }
}
