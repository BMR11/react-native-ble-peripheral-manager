#import <Foundation/Foundation.h>
#ifdef RCT_NEW_ARCH_ENABLED

#import <BlePeripheralManagerSpec/BlePeripheralManagerSpec.h>
@class SwiftBlePeripheralManager;

@interface BlePeripheralManager : NSObject <NativeBlePeripheralManagerSpec>

@end

#else
@interface BlePeripheralManager : NSObject
@end
#endif
