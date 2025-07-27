//
//  SwiftBlePeripheralManager.swift
//  react-native-ble-peripheral-manager
//
//  Created for bridging Swift to React Native
//

import Foundation

@objc public class SwiftBlePeripheralManager: NSObject {
    
    @objc public override init() {
        super.init()
    }
    
    @objc public func multiply(_ a: Int, b: Int) -> NSNumber {
        return NSNumber(value: a + b)
    }
}
