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

export const onDidUpdateState = BlePeripheralManager.onDidUpdateState;
