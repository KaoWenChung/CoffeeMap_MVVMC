//
//  Alertable.swift
//  CoffeeMap
//
//  Created by owenkao on 2022/09/01.
//

import UIKit

public protocol Alertable {}

public extension Alertable where Self: UIViewController {
    func showAlert(style: UIAlertController.Style,
                    title: String? = nil,
                    message: String? = nil,
                    cancel: String? = nil,
                    others: [AlertAction.Button]? = nil,
                    handler: ((AlertAction) -> Void)? = nil) {

        let alertController: UIAlertController = UIAlertController(title: title,
                                                                    message: message,
                                                                    preferredStyle: style)
        if let cancel = cancel {
            let cancelAction: UIAlertAction = UIAlertAction(index: 0, title: cancel, style: .cancel, handler: handler)
            alertController.addAction(cancelAction)
        }

        if let others = others {
            for (index, alertStyle) in others.enumerated() {
                let otherAction: UIAlertAction = UIAlertAction(index: index + 1, title: alertStyle.title, style: alertStyle.style, handler: handler)
                alertController.addAction(otherAction)
            }
        }
        present(alertController, animated: true, completion: nil)
    }
}

public class AlertAction {

    enum Style: Int {

        case `default`
        case cancel
        case destructive

        var describe: UIAlertAction.Style {
            switch self {
            case .default:
                return .default
            case .cancel:
                return .cancel
            case .destructive:
                return .destructive
            }
        }

    }

    public enum Button {

        case `default`(_ title: String)
        case destructive(_ title: String)

        var title: String {
            return describe.title
        }

        var style: Style {
            return describe.style
        }

        var describe: (title: String, style: Style) {
            switch self {
            case .default(let title):
                return (title, .default)
            case .destructive(let title):
                return (title, .destructive)
            }
        }
    }

    var index: Int = Int()
    var title: String = String()
    var style: Style = .default
    init(index: Int, title: String, style: Style) {
        self.index = index
        self.title = title
        self.style = style
    }

}

extension UIAlertAction {

    convenience init(index: Int,
                     title: String?,
                     style: AlertAction.Style,
                     handler: ((AlertAction) -> Void)?) {
        self.init(title: title, style: style.describe) { (aAlertAction: UIAlertAction) in
            let alertAction = AlertAction(index: index, title: title ?? "", style: style)
            handler?(alertAction)
        }
    }

}
