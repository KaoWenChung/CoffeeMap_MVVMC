//
//  PlaceSearchTableViewCell.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import UIKit

final class PlaceSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    func setupView(_ rowModel: PlaceSearchTableViewCellRowModel) {
        nameLabel.text = rowModel.name
        addressLabel.text = rowModel.address
        distanceLabel.text = rowModel.distance
    }
}
