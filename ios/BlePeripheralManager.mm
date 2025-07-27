#import <BlePeripheralManager.h>
#if __has_include("RNBlePeripheralManager-Swift.h")
#import <RNBlePeripheralManager-Swift.h>
#else
#import <RNBlePeripheralManager/RNBlePeripheralManager-Swift.h>
#endif

@implementation BlePeripheralManager {
    SwiftBlePeripheralManager * _swBlePeripheralManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _swBlePeripheralManager = [[SwiftBlePeripheralManager alloc] init];
    }
    return self;
}

RCT_EXPORT_MODULE()

- (NSNumber *)multiply:(double)a b:(double)b {
    // NSNumber *result = @(a * b);

    // return result;
    return [_swBlePeripheralManager multiply:a b:b];
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeBlePeripheralManagerSpecJSI>(params);
}

@end
