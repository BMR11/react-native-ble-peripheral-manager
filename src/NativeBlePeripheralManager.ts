import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';
import type { EventEmitter } from 'react-native/Libraries/Types/CodegenTypes';

export interface Spec extends TurboModule {
  multiply(a: number, b: number): number;

  readonly onDidUpdateState: EventEmitter<EventDidUpdateState>;
}

export type EventDidUpdateState = {
  state: string;
};

export default TurboModuleRegistry.getEnforcing<Spec>('BlePeripheralManager');
