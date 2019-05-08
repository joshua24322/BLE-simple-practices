//
//  AlertMessage.swift
//  Dialog
//
//  Created by Joshua Chang on 2019/5/7.
//  Copyright © 2019 Joshua Chang. All rights reserved.
//

import Foundation
import UIKit

/**
 This is flexible to deal the completion handler.
 
 * gist: https://gist.github.com/joshua24322/2b48a026452e1184fce85ef68f18014e
*/

extension UIViewController {
    
    /**
     
     * may you wanna pure message alert:
     
     ### Usage Example: ###
     ````
     callbackAlert(title: "message")
     callbackAlert(title: "message", message: "message")
     ````
     
     * or you wanna the alert message do something in completion handler:
       (the second parameter which message could be nil)
     
     ### Usage Example: ###
     ````
     callbackAlert(title: "message", message: nil, okCompletion: {
        // code here
     }) {
        // code here
     }
     ````
     
    */
    public func callbackAlert(title: String, message: String? = nil, okCompletion: @escaping (() -> ()) = {}, presentCompletion: @escaping (() -> ()) = {}) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
            okCompletion()
        }
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true) {
                presentCompletion()
            }
        }
    }
    
    /**
     
     * may you wanna pure message dialog:
     
     ### Usage Example: ###
     ````
     callbackDialog(title: "message")
     callbackDialog(title: "message", message: "message")
     ````
     
     * you can ignore any one completion handler by @escaping (() -> ()) = {}
     (ignore the okCompletion and the presentCompletion)
     
     ### Usage Example: ###
     ````
     callbackDialog(title: "message", message: "message", cancelCompletion: {
        // code here
     })
     ````
    */
    public func callbackDialog(title: String, message: String? = nil, okCompletion: @escaping (() -> ()) = {}, cancelCompletion: @escaping (() -> ()) = {}, presentCompletion: @escaping (() -> ()) = {}) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
            okCompletion()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancel: UIAlertAction) in
            cancelCompletion()
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true) {
                presentCompletion()
            }
        }
    }
}
