import BlePeripheralManager from './NativeBlePeripheralManager';

export function multiply(a: number, b: number): number {
  return BlePeripheralManager.multiply(a, b);
}

export function isAdvertising(): Promise<boolean> {
  return BlePeripheralManager.isAdvertising();
}

export function setName(name: string): void {
  BlePeripheralManager.setName(name);
}

export function addService(uuid: string, primary: boolean): void {
  BlePeripheralManager.addService(uuid, primary);
}

export function addCharacteristicToService(
  serviceUUID: string,
  uuid: string,
  permissions: number,
  properties: number,
  data: string
): void {
  BlePeripheralManager.addCharacteristicToService(
    serviceUUID,
    uuid,
    permissions,
    properties,
    data
  );
}

export function start(): Promise<void> {
  return BlePeripheralManager.start();
}

export function stop(): void {
  BlePeripheralManager.stop();
}

export function sendNotificationToDevices(
  serviceUUID: string,
  characteristicUUID: string,
  data: string
): void {
  BlePeripheralManager.sendNotificationToDevices(
    serviceUUID,
    characteristicUUID,
    data
  );
}

export const onDidUpdateState = BlePeripheralManager.onDidUpdateState;
