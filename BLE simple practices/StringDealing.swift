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
    
    // splite string by length
    func splitedBy(length: Int) -> [String] {
        var result = [String]()
        for i in stride(from: 0, to: self.count, by: length) {
            let startIndex = self.index(self.startIndex, offsetBy: i)
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            result.append(String(self[startIndex..<endIndex]))
        }
        return result
    }
    
    func dataFromHexadecimalString() -> NSData? {
        let data = NSMutableData(capacity: count / 2)
        
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, options: [], range: NSMakeRange(0, count)) { (match, flags, stop) in
            let byteString = (self as NSString).substring(with: match?.range ?? NSRange())
            var num = UInt8(byteString, radix: 16)
            data?.append(&num, length: 1)
        }
        return data
    }
    
    init?(hexadecimalString: String) {
        guard let data = hexadecimalString.dataFromHexadecimalString() else { return nil }
        self.init(data: data as Data, encoding: String.Encoding.utf8)
    }

    // string to hexadecimal string
    func hexadecimalString(encoding: String.Encoding = .utf8) -> String? {
        return data(using: encoding)?.hexadecimal()
    }
    
    func stringToByteArray() -> [UInt8] {
        var byteArray: [UInt8] = []
        for char in self.utf8 {
            switch char {
            case char where char > 0x2F && char < 0x3A:
                byteArray += [char-0x30]
            case char where char > 0x60 && char < 0x67:
                byteArray += [(char-0x60)+9]
            case char where char > 0x40 && char < 0x47:
                byteArray += [(char-0x40)+9]
            default:
                print("输入错误")
                break
            }
        }
        return byteArray
    }
}


