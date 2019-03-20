//
//  BluetoothAccess.swift
//  BLE simple practices
//
//  Created by Joshua Chang on 2019/3/19.
//  Copyright © 2019 Joshua Chang. All rights reserved.
//

import Foundation
import CoreBluetooth

struct PeripheralService {
    static let UUID: CBUUID = CBUUID(string: "Particular_Service_UUID")
}

struct PeripheralCharacteristic {
    static let UUID: CBUUID = CBUUID(string: "Particular_Characteristic_UUID")
}

class BluetoothManager: NSObject {
    
    static let shared = BluetoothManager() // handles CoreBluetooth with a single manager
    
    var centralManager: CBCentralManager?
    var connectingPeripheral: CBPeripheral?
    var savedCharacteristic : CBCharacteristic?
    let userDefaults = UserDefaults.standard
    
    private override init() {
        super.init()
        // Initialize CBCentralManager
        centralManager = CBCentralManager.init(delegate: self, queue: DispatchQueue.main)
    }
    
    private func isPaired() -> Bool {
        guard let uuidString = userDefaults.string(forKey: "Key_Peripheral_UUID") else { return false }
        let uuid = UUID(uuidString: uuidString)
        let list = centralManager?.retrievePeripherals(withIdentifiers: [uuid ?? UUID()])
        guard list?.count ?? Int() > 0 else { return false }
        connectingPeripheral = list?.first
        connectingPeripheral?.delegate = self
        return true
    }
    
    func getBluetoothState() -> Int {
        return centralManager?.state.rawValue ?? Int()
    }
    
    private func startScan() {
        print("🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍 No 2. Start scanning")
        centralManager?.scanForPeripherals(withServices: [PeripheralService.UUID] /* Peripheral Serveice finger out only */, options: nil)
    }
    
    private func startConnect(_ peripheral: CBPeripheral) {
        print("🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍 No 5. Start connecting")
        centralManager?.connect(peripheral, options: nil)
    }
    
    // manual disconnect
    func manualDisconnectPeripheral(central: CBCentralManager, stopConnectWithPeripheral peripheral: CBPeripheral) {
        central.stopScan()
        central.cancelPeripheralConnection(peripheral)
    }
    
    func startWritingValue(_ data: Data) {
        print("🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍 No 13. Start writing the value of a characteristic")
        guard let characteristic = savedCharacteristic else { return }
        connectingPeripheral?.writeValue(data, for: characteristic, type: .withResponse)
    }
    
    func sendData(_ ssid: String?, _ password: String?) {
        
        let timestamp = "000001341470" // unified plain text for example
        var ssidChip1: String?
        var ssidChip2: String?
        var ssidChip3: String?
        
        var ssidArr = ssid?.splitedBy(length: 12)
        guard let ssidTextCount = ssid?.count else { return }
        switch ssidTextCount {
        case ssidTextCount where ssidTextCount > 0 && ssidTextCount < 13:
            ssidChip1 = "3551\(ssidArr?[0].hexadecimalString()?.padding(toLength: 24, withPad: "0", startingAt: 0) ?? String())\(timestamp)"
        case ssidTextCount where ssidTextCount > 12 && ssidTextCount < 25:
            ssidChip1 = "3551\(ssidArr?[0].hexadecimalString()?.padding(toLength: 24, withPad: "0", startingAt: 0) ?? String())\(timestamp)"
            ssidChip2 = "3559\(ssidArr?[1].hexadecimalString()?.padding(toLength: 24, withPad: "0", startingAt: 0) ?? String())\(timestamp)"
        case ssidTextCount where ssidTextCount > 24 && ssidTextCount < 33:
            ssidChip1 = "3551\(ssidArr?[0].hexadecimalString()?.padding(toLength: 24, withPad: "0", startingAt: 0) ?? String())\(timestamp)"
            ssidChip2 = "3550\(ssidArr?[1].hexadecimalString()?.padding(toLength: 24, withPad: "0", startingAt: 0) ?? String())\(timestamp)"
            ssidChip3 = "3559\(ssidArr?[2].hexadecimalString()?.padding(toLength: 24, withPad: "0", startingAt: 0) ?? String())\(timestamp)"
        default:
            break
        }
        
        print("🔍🔍🔍🔍🔍🔍\nssidChip1: \(ssidChip1 ?? String()),\nssidChip2: \(ssidChip2 ?? String()),\nssidChip3: \(ssidChip3 ?? String())")
        let emtSsidData1 = uint8ToHexArray(uint8Array: ssidChip1?.stringToByteArray() ?? [UInt8]())
        let emtSsidData2 = uint8ToHexArray(uint8Array: ssidChip2?.stringToByteArray() ?? [UInt8]())
        let emtSsidData3 = uint8ToHexArray(uint8Array: ssidChip3?.stringToByteArray() ?? [UInt8]())
        
        print("🔍🔍🔍🔍🔍🔍\nemtSsidData1: \(emtSsidData1),\nemtSsidData2: \(emtSsidData2),\nemtSsidData3: \(emtSsidData3)")
        
        guard let passwordText = password else { return }
        
        var passwordChip1: String?
        var passwordChip2: String?
        var passwordChip3: String?
        
        var passwordArr = passwordText.splitedBy(length: 12)
        let passwordTextCount = passwordText.count
        switch passwordTextCount {
        case passwordTextCount where passwordTextCount > 0 && passwordTextCount < 13:
            passwordChip1 = "5031\(passwordArr[0].hexadecimalString()?.padding(toLength: 24, withPad: "0", startingAt: 0) ?? String())\(timestamp)"
        case passwordTextCount where passwordTextCount > 12 && passwordTextCount < 25:
            passwordChip1 = "5031\(passwordArr[0].hexadecimalString()?.padding(toLength: 24, withPad: "0", startingAt: 0) ?? String())\(timestamp)"
            passwordChip2 = "5039\(passwordArr[1].hexadecimalString()?.padding(toLength: 24, withPad: "0", startingAt: 0) ?? String())\(timestamp)"
        case passwordTextCount where passwordTextCount > 24 && passwordTextCount < 33:
            passwordChip1 = "5031\(passwordArr[0].hexadecimalString()?.padding(toLength: 24, withPad: "0", startingAt: 0) ?? String())\(timestamp)"
            passwordChip2 = "5030\(passwordArr[1].hexadecimalString()?.padding(toLength: 24, withPad: "0", startingAt: 0) ?? String())\(timestamp)"
            passwordChip3 = "5039\(passwordArr[2].hexadecimalString()?.padding(toLength: 24, withPad: "0", startingAt: 0) ?? String())\(timestamp)"
        default:
            break
        }
        
        print("🔍🔍🔍🔍🔍🔍\npasswordChip1: \(passwordChip1 ?? String()),\npasswordChip2: \(passwordChip2 ?? String()),\npasswordChip3: \(passwordChip3 ?? String())")
        
        let emtPasswordData1 = uint8ToHexArray(uint8Array: passwordChip1?.stringToByteArray() ?? [UInt8]())
        let emtPasswordData2 = uint8ToHexArray(uint8Array: passwordChip2?.stringToByteArray() ?? [UInt8]())
        let emtPasswordData3 = uint8ToHexArray(uint8Array: passwordChip3?.stringToByteArray() ?? [UInt8]())
        
        print("🔍🔍🔍🔍🔍🔍\nemtPasswordData1: \(emtPasswordData1),\nemtPasswordData2: \(emtPasswordData2),\nemtPasswordData3: \(emtPasswordData3)")
        
        /// Due to need to co-work with BLE devices firmware
        ///
        /// Currently, the issue of missing data is not considered.
        ///
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            var data = Data()
            data.append(emtSsidData1, count: emtSsidData1.count)
            print("🔍🔍🔍🔍🔍🔍\ndataToTrans: \(data)")
            self.startWritingValue(data)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            var data = Data()
            data.append(emtSsidData2, count: emtSsidData2.count)
            print("🔍🔍🔍🔍🔍🔍\ndataToTrans: \(data)")
            self.startWritingValue(data)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            var data = Data()
            data.append(emtSsidData3, count: emtSsidData3.count)
            print("🔍🔍🔍🔍🔍🔍\ndataToTrans: \(data)")
            self.startWritingValue(data)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            var data = Data()
            data.append(emtPasswordData1, count: emtPasswordData1.count)
            print("🔍🔍🔍🔍🔍🔍\ndataToTrans: \(data)")
            self.startWritingValue(data)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            var data = Data()
            data.append(emtPasswordData2, count: emtPasswordData2.count)
            print("🔍🔍🔍🔍🔍🔍\ndataToTrans: \(data)")
            self.startWritingValue(data)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            var data = Data()
            data.append(emtPasswordData3, count: emtPasswordData3.count)
            print("🔍🔍🔍🔍🔍🔍\ndataToTrans: \(data)")
            self.startWritingValue(data)
        }
    }
}

extension BluetoothManager: CBCentralManagerDelegate  {
    
    // Receive the update of central manager’s state
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍 No 1. DidUpdateState, Receive the update of central manager’s state")
        switch central.state {
        case .poweredOn:
            print("📶📶📶📶 BT State: ON 📶📶📶📶")
            if isPaired() {
                guard let peripheral = connectingPeripheral else { return }
                startConnect(peripheral)
            } else {
                startScan()
            }
        case .poweredOff:
            print("📶📶📶📶 BT State: OFF 📶📶📶📶")
        case .resetting:
            print("📶📶📶📶 BT State: Resetting 📶📶📶📶")
        case .unknown:
            print("📶📶📶📶 BT State: Unknown 📶📶📶📶")
        case .unauthorized:
            print("📶📶📶📶 BT State: Unauthorized 📶📶📶📶")
        case .unsupported:
            print("📶📶📶📶 BT State: Unsupported 📶📶📶📶")
        default:
            break
        }
    }
    
    // Receive the result of discovering services
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        print("🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍 No 8. didDiscoverServices, Receive the result of discovering services,\n Found \(services.count), Services: \(services)")
        services.forEach({ (service) in
            if service.uuid == PeripheralService.UUID {
                print("🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍 No 9. Start discovering characteristics")
                peripheral.discoverCharacteristics([PeripheralCharacteristic.UUID], for: service)
            } else { print("🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍 Services uuid: \(service.uuid)") }
        })
    }
    
    // Receive the result of discovering characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        print("🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍 No 10. didDiscoverCharacteristicsForService, Receive the result of discovering characteristics,\n Found \(characteristics.count), Characteristics: \(characteristics)")
        characteristics.forEach({ (characteristic) in
            switch characteristic.uuid {
            case PeripheralCharacteristic.UUID:
                
                savedCharacteristic = characteristic
                
                print("🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍 No 11-1. Start reading the value of a characteristic")
                peripheral.readValue(for: characteristic)
                
                print("🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍 No 11-2. Start receiving notifications for changes of a characteristic’s value")
                peripheral.setNotifyValue(true, for: characteristic)
            default:
                break
            }
        })
    }
    
    // Receive the result of reading, meanwhile Receive notifications for changes of a characteristic’s value
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍 No 12. didUpdateValueForCharacteristic,\nReceive the result of reading, meanwhile Receive notifications for changes of a characteristic’s value,\nCheck uuidString of characteristic: \(characteristic.uuid.uuidString),Check characteristic value: \(characteristic.value ?? Data()),\nCheck characteristic \(characteristic)")
        switch characteristic.uuid {
        case PeripheralCharacteristic.UUID:
            guard let value = characteristic.value else { break }
            print("🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍 check characteristic value \(value)")
        default:
            break
        }
    }
    
    // Receive the result of writing
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print("🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍 No 14. didWriteValueFor, 😎😎😎～Successful receive the result of writing～😎😎😎,\nPeripheral: \(peripheral)， characteristic: \(characteristic)")
    }
    
    // Receive the result of starting/stopping to receive notification
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍 No 15. didUpdateNotificationStateFor, Receive the result of starting/stopping to receive notification,\n isNotifying: \(characteristic.isNotifying)")
    }
}

extension BluetoothManager: CBPeripheralDelegate {
    
    // Receive the results of scan
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍 No 3. didDiscover peripheral, Receive the results of scan\nFound BLE devices, Name: \(peripheral.name ?? "unknow"), advertisement data: \(advertisementData), RSSI: \(RSSI)")
        
        print("🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍 No 4. Stop scanning, after find out the peripheral")
        centralManager?.stopScan()
        
        userDefaults.set(peripheral.identifier.uuidString, forKey: "Key_Peripheral_UUID")
        
        connectingPeripheral = peripheral
        
        startConnect(peripheral)
    }
    
    // Receive the result of connecting
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍 No 6. didConnect, Receive the result of connecting")
        
        print("🔍🔍🔍🔍🔍🔍🔍🔍🔍🔍 No 7. Start discovering services")
        connectingPeripheral?.delegate = self // for adopt CBPeripheralDelegate protocol
        peripheral.discoverServices([PeripheralService.UUID])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("❌❌❌❌❌ Oops....Connection drop....")
        connectingPeripheral?.delegate = nil
        connectingPeripheral = nil
        startScan()
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("❌❌❌❌❌ Oops....Fail to connect....")
        connectingPeripheral?.delegate = nil
        connectingPeripheral = nil
        startScan()
    }
}
