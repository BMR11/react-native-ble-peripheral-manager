package com.bleperipheralmanager

import android.bluetooth.*
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.util.Base64
import com.facebook.react.bridge.*
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.modules.core.DeviceEventManagerModule.RCTDeviceEventEmitter
import java.util.UUID

@ReactModule(name = BlePeripheralManagerModule.NAME)
class BlePeripheralManagerModule(private val reactContext: ReactApplicationContext) :
  NativeBlePeripheralManagerSpec(reactContext) {

  private val bluetoothManager: BluetoothManager by lazy {
    reactContext.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
  }
  private val bluetoothAdapter: BluetoothAdapter by lazy { bluetoothManager.adapter }
  private var gattServer: BluetoothGattServer? = null
  private val services = HashMap<UUID, BluetoothGattService>()
  private val connectedDevices = mutableSetOf<BluetoothDevice>()
  private var advertising = false
  private val advertiser: BluetoothLeAdvertiser?
    get() = bluetoothAdapter.bluetoothLeAdvertiser

  private val advertiseCallback = object : AdvertiseCallback() {
    override fun onStartFailure(errorCode: Int) {
      advertising = false
    }
  }

  private val gattServerCallback = object : BluetoothGattServerCallback() {
    override fun onConnectionStateChange(device: BluetoothDevice, status: Int, newState: Int) {
      if (newState == BluetoothProfile.STATE_CONNECTED) {
        connectedDevices.add(device)
      } else if (newState == BluetoothProfile.STATE_DISCONNECTED) {
        connectedDevices.remove(device)
      }
    }
  }

  private val stateReceiver = object : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
      if (intent?.action == BluetoothAdapter.ACTION_STATE_CHANGED) {
        val state = when (intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, BluetoothAdapter.ERROR)) {
          BluetoothAdapter.STATE_ON -> "poweredOn"
          BluetoothAdapter.STATE_OFF -> "poweredOff"
          else -> "unknown"
        }
        sendEvent("onDidUpdateState", Arguments.createMap().apply { putString("state", state) })
      }
    }
  }

  init {
    reactContext.registerReceiver(stateReceiver, IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED))
  }

  override fun getName(): String = NAME

  override fun onCatalystInstanceDestroy() {
    super.onCatalystInstanceDestroy()
    reactContext.unregisterReceiver(stateReceiver)
    stop()
  }

  override fun multiply(a: Double, b: Double): Double = a * b

  override fun isAdvertising(promise: Promise) {
    promise.resolve(advertising)
  }

  override fun setName(name: String) {
    bluetoothAdapter.name = name
  }

  override fun addService(uuid: String, primary: Boolean) {
    val service = BluetoothGattService(
      UUID.fromString(uuid),
      if (primary) BluetoothGattService.SERVICE_TYPE_PRIMARY else BluetoothGattService.SERVICE_TYPE_SECONDARY
    )
    services[UUID.fromString(uuid)] = service
  }

  override fun addCharacteristicToService(serviceUUID: String, uuid: String, permissions: Double, properties: Double, data: String) {
    val service = services[UUID.fromString(serviceUUID)] ?: return
    val characteristic = BluetoothGattCharacteristic(
      UUID.fromString(uuid),
      properties.toInt(),
      permissions.toInt()
    )
    if (data.isNotEmpty()) {
      characteristic.value = Base64.decode(data, Base64.DEFAULT)
    }
    service.addCharacteristic(characteristic)
  }

  override fun start(promise: Promise) {
    if (advertising) {
      promise.resolve(null)
      return
    }

    gattServer = bluetoothManager.openGattServer(reactContext, gattServerCallback).apply {
      services.values.forEach { addService(it) }
    }

    val settings = AdvertiseSettings.Builder()
      .setAdvertiseMode(AdvertiseSettings.ADVERTISE_MODE_LOW_LATENCY)
      .setConnectable(true)
      .setTimeout(0)
      .setTxPowerLevel(AdvertiseSettings.ADVERTISE_TX_POWER_HIGH)
      .build()

    val data = AdvertiseData.Builder()
      .setIncludeDeviceName(true)
      .build()

    val adv = advertiser
    if (adv != null) {
      adv.startAdvertising(settings, data, advertiseCallback)
      advertising = true
      promise.resolve(null)
    } else {
      promise.reject("NO_ADVERTISER", "BluetoothLeAdvertiser not supported")
    }
  }

  override fun stop() {
    advertiser?.stopAdvertising(advertiseCallback)
    gattServer?.close()
    gattServer = null
    advertising = false
  }

  override fun sendNotificationToDevices(serviceUUID: String, characteristicUUID: String, data: String) {
    val server = gattServer ?: return
    val service = services[UUID.fromString(serviceUUID)] ?: return
    val characteristic = service.getCharacteristic(UUID.fromString(characteristicUUID)) ?: return
    characteristic.value = Base64.decode(data, Base64.DEFAULT)
    connectedDevices.forEach { device ->
      server.notifyCharacteristicChanged(device, characteristic, false)
    }
  }

  override fun addListener(eventName: String) {}

  override fun removeListeners(count: Double) {}

  private fun sendEvent(event: String, params: WritableMap?) {
    reactContext.getJSModule(RCTDeviceEventEmitter::class.java).emit(event, params)
  }

  companion object {
    const val NAME = "BlePeripheralManager"
  }
}
