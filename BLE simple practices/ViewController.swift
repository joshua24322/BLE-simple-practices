//
//  ViewController.swift
//  BLE simple practices
//
//  Created by Joshua Chang on 2019/3/20.
//  Copyright © 2019 Joshua Chang. All rights reserved.
//

import UIKit
import Dialog
import BluetoothEncapsulated

class ViewController: UIViewController, UITextFieldDelegate {
    
    /// declare the BluetoothEncapsulated singleton
    weak var bluetoothManager = BluetoothManager.shared
    let ssidArray = getSSID()
    
    @IBOutlet weak var ssidTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func sendBtn(_ sender: UIButton) {
        checkEnterData { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.bluetoothManager?.sendData(weakSelf.ssidTextField.text, weakSelf.passwordTextField.text, success: {
                weakSelf.callbackAlert(title: "Success")
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ssidTextField.text = ssidArray[0]
        print("WIFI SSID: \(ssidArray[0])")
    }
    
    func checkEnterData(completion: @escaping () -> ()) {
        guard ssidTextField.text?.count != 0 else {
            callbackAlert(title: "Please enter your password.")
            return
        }
        guard passwordTextField.text?.count != 0 else {
            callbackAlert(title: "Please enter your password.")
            return
        }
        guard (ssidTextField.text?.isValidSSID())! else {
            callbackAlert(title: "Please enter a valid SSID name that 1 - 32 alphabet or numeric characters.")
            return
        }
        guard (passwordTextField.text?.isValidPassword())! else {
            callbackAlert(title: "Please enter a valid password that 4 - 32 alphabet or numeric characters.")
            return
        }
        completion()
    }
    
    // drop out the virtual keyboard when user tab screen anywhere (view of viewController)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // UITextFieldDelegate optional method for textField retrun operating
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

