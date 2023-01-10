//
//  BaseXibView.swift
//  CoffeeMap
//
//  Created by wyn on 2023/1/10.
//

import UIKit

class BaseXibView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }

    func xibSetup() {
        let boundle = Bundle(for: classForCoder)
        let nib = UINib(nibName: "\(classForCoder)", bundle: boundle)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(view)
        }
    }
}
