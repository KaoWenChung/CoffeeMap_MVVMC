//
//  PlaceSearchTableViewCell.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import UIKit

final class PlaceSearchTableViewCell: UITableViewCell, BaseCellView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    func setupCellView(rowModel: BaseCellRowModel) {

        guard let rowModel = rowModel as? PlaceSearchTableViewCellRowModel else { return }
        nameLabel.text = rowModel.name
        addressLabel.text = rowModel.address
        distanceLabel.text = rowModel.distance

    }
}
