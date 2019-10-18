//
//  UIAlertController+Additions.swift
//  reddit-client
//
//  Created by Pablo Epíscopo on 10/18/19.
//  Copyright © 2019 Pablo Epíscopo. All rights reserved.
//

import UIKit

public typealias AlertActionBlock = (UIAlertAction) -> Void

extension UIAlertController {

    class func blockedFeatureAlert(_ blockedFeature: String) -> UIAlertController {
        let title = NSLocalizedString("Reddit Client does not have access to your \(blockedFeature).", comment: "")
        let message = NSLocalizedString("Would you like to enable access now?", comment: "")
        return alert(title, message, NSLocalizedString("OK", comment: ""), { (UIAlertAction) in
            let url = URL(string: UIApplication.openSettingsURLString)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }, NSLocalizedString("Not Now", comment: ""), nil)
    }

    class func alert(_ title: String?, _ message: String?, _ callTitle: String?, _ callHandler: AlertActionBlock?) -> UIAlertController {
        let alertController = UIAlertController(title: title ?? "Reddit Client", message: message ?? "", preferredStyle: .alert)
        let callAction = UIAlertAction(title: callTitle == nil ? NSLocalizedString("OK", comment: "") : callTitle, style: .default, handler: callHandler)
        alertController.addAction(callAction)
        return alertController
    }

    class func alert(_ title: String?, _ message: String?, _ callTitle: String, _ callHandler: AlertActionBlock?, _ cancelTitle: String, _ cancelHandler: AlertActionBlock?) -> UIAlertController {
        return alert(title, message, callTitle, callHandler, cancelTitle, cancelHandler, preferredStyle: .alert, callStyle: .default)
    }

    // MARK: Private Methods

    private class func alert(_ title: String?, _ message: String?, _ callTitle: String, _ callHandler: AlertActionBlock?, _ cancelTitle: String, _ cancelHandler: AlertActionBlock?, preferredStyle: UIAlertController.Style, callStyle: UIAlertAction.Style) -> UIAlertController {
            let alertController = UIAlertController(title: title ?? "Reddit Client", message: message, preferredStyle: preferredStyle)
            let callAction = UIAlertAction(title: callTitle, style: callStyle, handler: callHandler)
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler)
            alertController.addAction(callAction)
            alertController.addAction(cancelAction)
            return alertController
    }

}
