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
    var error: Observable<String> { get }
    var errorTitle: String { get }
}

protocol CafeListViewModelType: CafeListViewModelInput, CafeListViewModelOutput {}

final class CafeListViewModel: CafeListViewModelType {

    private let searchCafeUseCase: SearchCafeUseCaseType
    private let actions: CafeListViewModelActions?
    
    let placeList: Observable<[AdapterSectionModel]> = Observable([])
    let error: Observable<String> = Observable("")
    let errorTitle: String = CommonString.error.text

    private var cafesLoadTask: CancellableType? { willSet { cafesLoadTask?.cancel() } }
    
    init(searchCafeUseCase: SearchCafeUseCaseType,
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
        do {
            let (value, task) = try await searchCafeUseCase.execute(request: CafePlaceRequestDTO(ll: ll, sort: "DISTANCE"))
            placeList.value = [AdapterSectionModel(items: value)]
            cafesLoadTask = task
        } catch {
            handle(error: error)
        }
    }

    func didSelectItem(_ viewModel: CafeListTableViewCellModel) {
        actions?.showCafeRoute(viewModel)
    }
}
