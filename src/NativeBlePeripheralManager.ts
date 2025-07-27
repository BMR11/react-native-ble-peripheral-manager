import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';
import type { EventEmitter } from 'react-native/Libraries/Types/CodegenTypes';

export interface Spec extends TurboModule {
  multiply(a: number, b: number): number;

  isAdvertising(): Promise<boolean>;
  setName(name: string): void;
  addService(uuid: string, primary: boolean): void;
  addCharacteristicToService(
    uuid: string,
    permissions: number,
    properties: number,
    data: string
  ): void;
  start(): Promise<void>;
  stop(): void;
  sendNotificationToDevices(characteristicUUID: string, data: string): void;

  readonly onDidUpdateState: EventEmitter<EventDidUpdateState>;
}

export type EventDidUpdateState = {
  state: string;
};

export default TurboModuleRegistry.getEnforcing<Spec>('BlePeripheralManager');
