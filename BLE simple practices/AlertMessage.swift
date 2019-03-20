//
//  AlertMessage.swift
//  BLE simple practices
//
//  Created by Joshua Chang on 2019/2/26.
//  Copyright © 2019 Joshua Chang. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    // https://gist.github.com/joshua24322/2b48a026452e1184fce85ef68f18014e
    
    func callbackAlert(title: String, message: String? = nil, okCompletion: @escaping (() -> ()) = {}, presentCompletion: @escaping (() -> ()) = {}) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
            okCompletion()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true) {
            presentCompletion()
        }
    }
    
    func callbackDialog(title: String, message: String? = nil, okCompletion: @escaping (() -> ()) = {}, cancelCompletion: @escaping (() -> ()) = {}, presentCompletion: @escaping (() -> ()) = {}) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
            okCompletion()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancel: UIAlertAction) in
            cancelCompletion()
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true) {
            presentCompletion()
        }
    }
}
