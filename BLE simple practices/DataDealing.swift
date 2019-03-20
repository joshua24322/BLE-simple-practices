//
//  DataDealing.swift
//  BLE simple practices
//
//  Created by Joshua Chang on 2019/3/15.
//  Copyright © 2019 Joshua Chang. All rights reserved.
//

import Foundation

extension Data {
    
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    
    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
    
    func hexadecimal() -> String {
        return map({ String(format: "%02x", $0)}).joined(separator: "")
    }
}

func uint8ToHexArray(uint8Array: [UInt8]) -> [UInt8] {
    
    var hexArray = [UInt8]()
    if (uint8Array.count != 0) {
        var hexData: UInt8 = 0
        var cnt = 0
        for data in uint8Array {
            if cnt % 2 == 0 {
                hexData = data*16
                if cnt == uint8Array.count - 1 {
                    hexArray += [data]
                    print("this length is odd number, final value is \(hexData)")
                }
            }else {
                hexData += data
                hexArray += [hexData]
            }
            cnt += 1
        }
    }
    return hexArray
}
