//
//  PlaceSearchCellModel.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

struct PlaceSearchCellViewModel: BaseCellRowModel {
    var cellID: String { return "PlaceSearchCellView" }
    
    var cellAction: ((BaseCellRowModel) -> ())?
    
    let title: String
    
    init(_ dataModel: GetPlaceResultModel) {
        title = dataModel.name ?? ""
    }
}
