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
        _swBlePeripheralManager = [[SwiftBlePeripheralManager alloc] initWithBlePeripheralManager:self];
    }
    return self;
}

RCT_EXPORT_MODULE()

- (NSNumber *)multiply:(double)a b:(double)b {
    // NSNumber *result = @(a * b);

    // return result;
    return [_swBlePeripheralManager multiply:a b:b];
}

//// Write for isAdvertising similar to multiply and without RCT_EXPORT_METHOD
//- (void)isAdvertising:(RCTPromiseResolveBlock)resolve
//               rejecter:(RCTPromiseRejectBlock)reject {
//    [_swBlePeripheralManager isAdvertising:resolve rejecter:reject];
//}
//
//- (void)setName:(NSString *)name {
//    [_swBlePeripheralManager setName:name];
//}   

- (void)addCharacteristicToService:(nonnull NSString *)serviceUUID uuid:(nonnull NSString *)uuid permissions:(double)permissions properties:(double)properties data:(nonnull NSString *)data {
    [_swBlePeripheralManager addCharacteristicToService:serviceUUID uuid:uuid permissions:permissions properties:properties data:data];
}


- (void)addService:(nonnull NSString *)uuid primary:(BOOL)primary { 
    [_swBlePeripheralManager addService:uuid primary:primary];
}


- (void)isAdvertising:(nonnull RCTPromiseResolveBlock)resolve reject:(nonnull RCTPromiseRejectBlock)reject { 
    [_swBlePeripheralManager isAdvertising:resolve rejecter:reject];

}

- (void)sendNotificationToDevices:(nonnull NSString *)serviceUUID characteristicUUID:(NSString *)characteristicUUID data:(NSString *)data {
//    [_swBlePeripheralManager sendNotificationToDevices:serviceUUID characteristicUUID:characteristicUUID data:data];
}




- (void)start:(nonnull RCTPromiseResolveBlock)resolve reject:(nonnull RCTPromiseRejectBlock)reject { 
    [_swBlePeripheralManager start:resolve rejecter:reject];
}


- (void)stop { 
    [_swBlePeripheralManager stop];
}

- (void)setName:(nonnull NSString *)name { 
    [_swBlePeripheralManager setName:name];
}





- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeBlePeripheralManagerSpecJSI>(params);
}


@end
