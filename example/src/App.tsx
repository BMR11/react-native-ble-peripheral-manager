import { useEffect, useState, useCallback } from 'react';
import { Text, View, StyleSheet, Button } from 'react-native';
import {
  multiply,
  onDidUpdateState,
} from 'react-native-ble-peripheral-manager';

// const result = multiply(3, 7);

export default function App() {
  const [currentState, setCurrentState] = useState('None');
  const [result, setResult] = useState(0);

  const handleUpdateState = useCallback((state: any) => {
    console.debug('[app] onDidUpdateState:', state);
    setCurrentState(state.state);
  }, []);

  // Set up listeners and permissions when the component mounts
  useEffect(() => {
    const listeners: any[] = [onDidUpdateState(handleUpdateState)];

    return () => {
      console.debug('[app] main component unmounting. Removing listeners...');
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
        title="Multiply"
        onPress={() => {
          const newResult = multiply(5, 10);
          setResult(newResult);
          console.debug('[app] New multiplication result:', newResult);
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
