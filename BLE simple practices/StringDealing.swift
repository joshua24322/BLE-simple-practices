//
//  StringDealing.swift
//  BLE simple practices
//
//  Created by Joshua Chang on 2019/3/15.
//  Copyright © 2019 Joshua Chang. All rights reserved.
//

import Foundation

extension String {
    
    enum RegularExpressions: String {
        case ssid = "^.{1,33}$"
        case password = "^[A-Za-z0-9 !\"#$%&'()*+,-./:;<=>?@\\[\\\\\\]^_`{|}~].{3,33}$"
    }
    
    func isValidSSID() -> Bool {
        let regex = try! NSRegularExpression(pattern: RegularExpressions.ssid.rawValue, options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func isValidPassword() -> Bool {
        let regex = try! NSRegularExpression(pattern: RegularExpressions.password.rawValue, options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
}


