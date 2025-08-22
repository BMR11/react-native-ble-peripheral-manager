import { useEffect, useState, useCallback } from 'react';
import { Text, View, StyleSheet, Button } from 'react-native';
import {
  multiply,
  onDidUpdateState,
  isAdvertising,
  setName,
  start,
} from 'react-native-ble-peripheral-manager';

const MyDebugLog = (...args: any[]) => {
  console.debug('[app]', ...args);
};

// const result = multiply(3, 7);

export default function App() {
  const [currentState, setCurrentState] = useState('None');
  const [result, setResult] = useState(0);

  const handleUpdateState = useCallback((state: any) => {
    MyDebugLog('onDidUpdateState:', state);
    setCurrentState(state.state);
  }, []);

  // Set up listeners and permissions when the component mounts
  useEffect(() => {
    MyDebugLog('main component mounting. Setting up listeners...');
    setCurrentState('Initializing...');
    const listeners: any[] = [onDidUpdateState(handleUpdateState)];

    return () => {
      MyDebugLog('main component unmounting. Removing listeners...');
      for (const listener of listeners) {
        listener.remove();
      }
    };
  }, [handleUpdateState]);

  return (
    <View style={styles.container}>
      <Text>Result: {result}</Text>
      <Text>Current State: {currentState}</Text>
      <Button
        title="Test Multiply"
        onPress={() => {
          const newResult = multiply(5, 10);
          setResult(newResult);
          console.debug('[app] New multiplication result:', newResult);
        }}
      />
      <Button
        title="Start Advertising"
        onPress={async () => {
          try {
            await start();
            console.debug('[app] Peripheral started successfully');
          } catch (error) {
            console.error('[app] Error starting peripheral:', error);
          }
        }}
      />
      <Button
        title="Check Advertising"
        onPress={async () => {
          const advertising = await isAdvertising();
          setCurrentState(advertising ? 'Advertising' : 'Not Advertising');
          console.debug('[app] Is advertising:', advertising);
        }}
      />
      <Button
        title="Set Name"
        onPress={() => {
          setName('MyPeripheral');
          console.debug('[app] Peripheral name set to "MyPeripheral"');
        }}
      />
      <Text>Check console for updates.</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
