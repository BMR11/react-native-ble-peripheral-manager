# React Native BLE Peripheral Manager

> A cross-platform React Native library to enable **BLE Peripheral Mode** on iOS and Android.

---

## 🚀 Overview

**React Native BLE Peripheral Manager** aims to expose full support for **Bluetooth Low Energy (BLE) Peripheral mode** in React Native apps. It bridges native BLE peripheral APIs on both iOS and Android, enabling your app to **advertise**, **expose services and characteristics**, and **communicate with central devices** (like phones, tablets, or medical devices).

> ⚠️ This library is under active development and not yet production-ready. Contributions, feedback, and issues are welcome!

---

## 🔧 Features (Planned)

- ✅ Advertise as a BLE peripheral
- ✅ Expose custom and standard GATT services & characteristics
- 🔄 Notify characteristics to connected centrals
- 🔄 Support read/write request handlers
- 🔄 Support for bonding and secure characteristics
- 🔄 Cross-platform API with TypeScript support
- 🔄 Event emitters for connection and request handling
- 🔄 Simulator/emulator mode for testing BLE central apps

---

## 📱 Platform Support

| Platform | Peripheral Mode Support |
|----------|--------------------------|
| iOS      | ✅ Fully supported (iOS 11+) |
| Android  | ✅ Supported on Android 5.0+ with some hardware limitations ⚠️ |

> Note: Android peripheral mode support depends on chipset and manufacturer (e.g., most Samsung and Pixel phones support it; many others do not).

---

## 📦 Installation

```bash
npm install react-native-ble-peripheral-manager
# or
yarn add react-native-ble-peripheral-manager
