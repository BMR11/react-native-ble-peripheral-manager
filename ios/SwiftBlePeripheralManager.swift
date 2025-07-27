//
//  SwiftBlePeripheralManager.swift
//  react-native-ble-peripheral-manager
//
//  Created for bridging Swift to React Native
//

import Foundation

@objc public class SwiftBlePeripheralManager: NSObject {

    private weak var blePeripheralManager: BlePeripheralManager?
    
    @objc public init(blePeripheralManager: BlePeripheralManager) {
        self.blePeripheralManager = blePeripheralManager;
        super.init()
    }
    
    @objc public func multiply(_ a: Int, b: Int) -> NSNumber {
        self.blePeripheralManager?.emit(onDidUpdateState: ["state": "Multiply Done ❤️"])
        return NSNumber(value: a + b)
    }
}
