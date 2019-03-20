//
//  WiFi_ap_info.swift
//  BLE simple practices
//
//  Created by Joshua Chang on 2019/3/16.
//  Copyright © 2019 Joshua Chang. All rights reserved.
//

import Foundation
import SystemConfiguration.CaptiveNetwork

func getSSID() -> [String] {
    guard let interfacesName = CNCopySupportedInterfaces() as? [String] else { return [String()] }
    
    return interfacesName.compactMap({ (name) in
        guard let info = CNCopyCurrentNetworkInfo(name as CFString) as? [String: AnyObject] else { return String() }
        guard let ssid = info[kCNNetworkInfoKeySSID as String] as? String else { return String() }
        return ssid
    })
}
