import { useEffect, useState, useCallback } from 'react';
import {
  Text,
  View,
  StyleSheet,
  Button,
  SafeAreaView,
  ScrollView,
  FlatList,
} from 'react-native';
import {
  onDidUpdateState,
  isAdvertising,
  setName,
  start,
  stop,
  addService,
  addCharacteristicToService,
  sendNotificationToDevices,
} from 'react-native-ble-peripheral-manager';

const serviceUUID = '180D'; // heart rate service UUID
const characteristicUUID = '2A37'; // heart rate measurement characteristic UUID

export default function App() {
  const [debugLogs, setDebugLogs] = useState<string[]>([]);

  const MyDebugLog = (...args: any[]) => {
    setDebugLogs((prevLogs) => [args.join(), ...prevLogs]);
  };

  const handleUpdateState = useCallback((state: any) => {
    const logMsg = `onDidUpdateState: ${JSON.stringify(state)}`;
    // MyDebugLog(logMsg);
    setDebugLogs((prevLogs) => [logMsg, ...prevLogs]);
  }, []);

  const createService = useCallback(() => {
    const permissions = 0x0001; // Example permission
    const properties = 0x0002; // Example property
    const data = 'Hello World';
    addService(serviceUUID, true);
    addCharacteristicToService(
      serviceUUID,
      characteristicUUID,
      permissions,
      properties,
      data
    );
    MyDebugLog('Service and characteristic added:', {
      serviceUUID,
      characteristicUUID,
      permissions,
      properties,
      data,
    });
  }, []);

  // Set up listeners and permissions when the component mounts
  useEffect(() => {
    MyDebugLog('main component mounting. Setting up listeners...');
    const listeners: any[] = [onDidUpdateState(handleUpdateState)];

    // createService();

    return () => {
      MyDebugLog('main component unmounting. Removing listeners...');
      for (const listener of listeners) {
        listener.remove();
      }
    };
  }, [handleUpdateState, createService]);

  return (
    <SafeAreaView style={styles.container}>
      <Button
        title="Set Name"
        onPress={() => {
          setName('MyPeripheral');
          MyDebugLog('[app] Peripheral name set to "MyPeripheral"');
        }}
      />
      <Button
        title="createService"
        onPress={() => {
          createService();
        }}
      />
      <Button
        title="Start Advertising"
        onPress={async () => {
          try {
            await start();
            MyDebugLog('[app] Peripheral started successfully');
          } catch (error) {
            MyDebugLog('[app] Error starting peripheral:', error);
          }
        }}
      />
      <Button
        title="Check Advertising"
        onPress={async () => {
          const advertising = await isAdvertising();
          MyDebugLog('[app] Is advertising:', advertising);
        }}
      />
      <Button
        title="Stop Advertising"
        onPress={async () => {
          try {
            await stop();
            MyDebugLog('[app] Peripheral stopped successfully');
          } catch (error) {
            MyDebugLog('[app] Error stopping peripheral:', error);
          }
        }}
      />

      <Button
        title="Send Notification"
        onPress={async () => {
          try {
            await sendNotificationToDevices(
              serviceUUID,
              characteristicUUID,
              '11'
            );
            MyDebugLog('[app] Sent notification successfully');
          } catch (error) {
            MyDebugLog('[app] Error sending notification', error);
          }
        }}
      />
      <View
        style={{
          flexDirection: 'row',
          justifyContent: 'space-between',
          width: '100%',
        }}
      >
        <Text style={{ fontWeight: 'bold', alignSelf: 'center' }}>
          Debug Logs:
        </Text>
        <Button
          title="Clear Logs"
          onPress={async () => {
            setDebugLogs([]);
          }}
        />
      </View>
      <ScrollView style={styles.scrollView}>
        <View style={{ flex: 1 }}>
          <FlatList
            data={debugLogs}
            keyExtractor={(_, idx) => idx.toString()}
            renderItem={({ item }) => (
              <>
                <Text style={{ fontSize: 12, marginBottom: 4 }}>{item}</Text>
                <View
                  style={{
                    borderBottomWidth: 1,
                    borderBottomColor: '#ccc',
                    marginVertical: 2,
                  }}
                />
              </>
            )}
          />
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    borderColor: '#323232',
    borderWidth: 1,
    margin: 2,
    padding: 20,
    backgroundColor: '#e2e0ceff',
    flex: 1,
    alignItems: 'center',
    justifyContent: 'flex-start',
  },
  scrollView: {
    flex: 1,
    width: '100%',
    backgroundColor: '#f0f0f0',
    padding: 10,
    borderColor: '#ccc',
    borderWidth: 1,
    borderRadius: 5,
  },
});
