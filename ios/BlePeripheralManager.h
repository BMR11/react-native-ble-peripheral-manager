#import <CoreBluetooth/CoreBluetooth.h>
#import <Foundation/Foundation.h>

#ifdef RCT_NEW_ARCH_ENABLED

#import <BlePeripheralManagerSpec/BlePeripheralManagerSpec.h>
@class SwiftBlePeripheralManager;

@interface BlePeripheralManager : NativeBlePeripheralManagerSpecBase <NativeBlePeripheralManagerSpec>
- (void)emitOnDidUpdateState:(NSDictionary *)value;
@end

#else
@interface BlePeripheralManager : NSObject
- (void)emitOnDidUpdateState:(NSDictionary *)value;

@end
#endif
