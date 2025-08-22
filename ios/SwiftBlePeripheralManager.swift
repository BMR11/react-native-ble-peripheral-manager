//
//  SwiftBlePeripheralManager.swift
//  react-native-ble-peripheral-manager
//
//  Created for bridging Swift to React Native
//

import CoreBluetooth
import Foundation

@objc public class SwiftBlePeripheralManager: NSObject, CBPeripheralManagerDelegate {

  private weak var blePeripheralManager: BlePeripheralManager?
  var advertising: Bool = false
  var hasListeners: Bool = false
  var name: String = "RN_BLE"
  var servicesMap = [String: CBMutableService]()
  private var manager: CBPeripheralManager!

  @objc public init(blePeripheralManager: BlePeripheralManager) {
    self.blePeripheralManager = blePeripheralManager
    super.init()

    manager = CBPeripheralManager(delegate: self, queue: DispatchQueue.main)
  }

  @objc public func multiply(_ a: Int, b: Int) -> NSNumber {

    self.blePeripheralManager?.emit(onDidUpdateState: ["state": "Multiply Done ❤️"])
    return NSNumber(value: a + b)
  }

  //// PUBLIC METHODS
  @objc public func setName(_ name: String) {
    self.name = name
    alertJS("name set to \(name)")
  }

  @objc public func isAdvertising(
    _ resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock
  ) {
    resolve(advertising)
  }

  @objc(addService:primary:)
  public func addService(_ uuid: String, primary: Bool) {
    let serviceUUID = CBUUID(string: uuid)
    let service = CBMutableService(type: serviceUUID, primary: primary)
    if servicesMap.keys.contains(uuid) != true {
      servicesMap[uuid] = service
      manager.add(service)
      alertJS("added service \(uuid)")
    } else {
      alertJS("service \(uuid) already there")
    }
  }

  @objc(addCharacteristicToService:uuid:permissions:properties:data:)
  public func addCharacteristicToService(
    _ serviceUUID: String, uuid: String, permissions: UInt, properties: UInt, data: String
  ) {
    let characteristicUUID = CBUUID(string: uuid)
    //    let propertyValue = [.notify]//CBCharacteristicProperties(rawValue: properties)
    //    let permissionValue = [.readable]//CBAttributePermissions(rawValue: permissions)
    let byteData: Data = data.data(using: .utf8)!
    let characteristic = CBMutableCharacteristic(
      type: characteristicUUID, properties: [.notify], value: byteData,
      permissions: [.readable])
    servicesMap[serviceUUID]?.characteristics?.append(characteristic)
    alertJS("added characteristic \(uuid) to service \(characteristicUUID)")
  }

  @objc public func start(
    _ resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock
  ) {

    //           if (manager.state != .poweredOn) {
    //
    //             alertJS("Bluetooth turned off: state \(manager.state)")
    //               return;
    //           }

    let advertisementData =
      [
        CBAdvertisementDataLocalNameKey: name,
        CBAdvertisementDataServiceUUIDsKey: getServiceUUIDArray(),
      ] as [String: Any]
    //         let advertisementData: [String: Any] = [
    //             CBAdvertisementDataServiceUUIDsKey: [Gatt.Service.heartRate]
    //         ]
    manager.startAdvertising(advertisementData)
  }

  @objc public func stop() {
    manager.stopAdvertising()
    advertising = false
    alertJS("called stop")
  }

  @objc(sendNotificationToDevices:characteristicUUID:)
  public func sendNotificationToDevices(
    _ serviceUUID: String, characteristicUUID: String
  ) {
    let data = String(11).data(using: .utf8)

    if servicesMap.keys.contains(serviceUUID) == true {
      let service = servicesMap[serviceUUID]!
      let characteristic = getCharacteristicForService(service, characteristicUUID)
      if characteristic == nil {
        alertJS("service \(serviceUUID) does NOT have characteristic \(characteristicUUID)")
      }

      let char = characteristic as! CBMutableCharacteristic
      char.value = data
      let success = manager.updateValue(data!, for: char, onSubscribedCentrals: nil)
      if success {
        alertJS("changed data for characteristic \(characteristicUUID)")
      } else {
        alertJS("failed to send changed data for characteristic \(characteristicUUID)")
      }

    } else {
      alertJS("service \(serviceUUID) does not exist")
    }
  }

  //// EVENTS

  // Respond to Read request
  func peripheralManager(
    peripheral: CBPeripheralManager, didReceiveReadRequest request: CBATTRequest
  ) {
    let characteristic = getCharacteristic(request.characteristic.uuid)
    if characteristic != nil {
      request.value = characteristic?.value
      manager.respond(to: request, withResult: .success)
    } else {
      alertJS("cannot read, characteristic not found")
    }
  }

  // Respond to Write request
  func peripheralManager(
    peripheral: CBPeripheralManager, didReceiveWriteRequests requests: [CBATTRequest]
  ) {
    for request in requests {
      let characteristic = getCharacteristic(request.characteristic.uuid)
      if characteristic == nil { alertJS("characteristic for writing not found") }
      if request.characteristic.uuid.isEqual(characteristic?.uuid) {
        let char = characteristic as! CBMutableCharacteristic
        char.value = request.value
      } else {
        alertJS("characteristic you are trying to access doesn't match")
      }
    }
    manager.respond(to: requests[0], withResult: .success)
  }

  // Respond to Subscription to Notification events
  public func peripheralManager(
    _ peripheral: CBPeripheralManager, central: CBCentral,
    didSubscribeTo characteristic: CBCharacteristic
  ) {
    let char = characteristic as! CBMutableCharacteristic
    alertJS("subscribed centrals: \(String(describing: char.subscribedCentrals))")
  }

  // Respond to Unsubscribe events
  public func peripheralManager(
    _ peripheral: CBPeripheralManager, central: CBCentral,
    didUnsubscribeFrom characteristic: CBCharacteristic
  ) {
    let char = characteristic as! CBMutableCharacteristic
    alertJS("unsubscribed centrals: \(String(describing: char.subscribedCentrals))")
  }

  // Service added
  public func peripheralManager(
    _ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?
  ) {
    if let error = error {
      alertJS("error: \(error)")
      return
    }
    alertJS("service: \(service)")
  }

  // Bluetooth status changed
  public func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
    var state: Any
    if #available(iOS 10.0, *) {
      state = peripheral.state.description
    } else {
      state = peripheral.state
    }
    alertJS("BT state change: \(state)")
  }
  
  func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
      alertJS("⚠️ Services modified on peripheral: \(peripheral), invalidated: \(invalidatedServices)")
  }
  // Advertising started
  public func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?)
  {
    if let error = error {
      alertJS("advertising failed. error: \(error)")
      advertising = false
      //               startPromiseReject!("AD_ERR", "advertising failed", error)
      return
    }
    advertising = true
    //           startPromiseResolve!(advertising)
    alertJS("advertising succeeded!")
  }

  //// HELPERS

  func getCharacteristic(_ characteristicUUID: CBUUID) -> CBCharacteristic? {
    for (uuid, service) in servicesMap {
      for characteristic in service.characteristics ?? [] {
        if characteristic.uuid.isEqual(characteristicUUID) {
          alertJS("service \(uuid) does have characteristic \(characteristicUUID)")
          if characteristic is CBMutableCharacteristic {
            return characteristic
          }
          alertJS("but it is not mutable")
        } else {
          alertJS("characteristic you are trying to access doesn't match")
        }
      }
    }
    return nil
  }

  func getCharacteristicForService(_ service: CBMutableService, _ characteristicUUID: String)
    -> CBCharacteristic?
  {
    for characteristic in service.characteristics ?? [] {
      if characteristic.uuid.isEqual(characteristicUUID) {
        alertJS("service \(service.uuid) does have characteristic \(characteristicUUID)")
        if characteristic is CBMutableCharacteristic {
          return characteristic
        }
        alertJS("but it is not mutable")
      } else {
        alertJS("characteristic you are trying to access doesn't match")
      }
    }
    return nil
  }

  func getServiceUUIDArray() -> [CBUUID] {
    var serviceArray = [CBUUID]()
    for (_, service) in servicesMap {
      serviceArray.append(service.uuid)
    }
    return serviceArray
  }

  func alertJS(_ message: Any) {

    //    if hasListeners {
    self.blePeripheralManager?.emit(onDidUpdateState: ["state": "[native🟣]: \(message)"])
    //    }
  }

}

@available(iOS 10.0, *)
extension CBManagerState: CustomStringConvertible {
  public var description: String {
    switch self {
    case .poweredOff: return ".poweredOff"
    case .poweredOn: return ".poweredOn"
    case .resetting: return ".resetting"
    case .unauthorized: return ".unauthorized"
    case .unknown: return ".unknown"
    case .unsupported: return ".unsupported"
    @unknown default:
      return ".unknown"
    }
  }
}

// NEW CODE

public enum Gatt {

  public enum Service {
    public static let heartRate = CBUUID(string: "180D")
  }

  public enum Characteristic {
    public static let heartRateMeasurement = CBUUID(string: "2A37")
  }
}
