import BlePeripheralManager from './NativeBlePeripheralManager';

export function multiply(a: number, b: number): number {
  return BlePeripheralManager.multiply(a, b);
}

export const onDidUpdateState = BlePeripheralManager.onDidUpdateState;
