//
//  ADSPeripheralModel.m
//  ADSBLEManager
//
//  Created by ADSmart Tech on 2017/6/21.
//  Copyright © 2017年 ADSmart Tech. All rights reserved.
//

#import "ADSBLEPeripheralModel.h"
#import "XYWeakTimer.h"
#import "BLEUtility.h"

static NSArray *_serviceArray = nil;
static NSArray *_characteristicsArray = nil;

@interface ADSBLEPeripheralModel ()<CBPeripheralDelegate>

@property (nonatomic,strong) NSTimer *connectTimer;

@property (nonatomic,strong) ADSBLECenterManager *centerManager;

@end

@implementation ADSBLEPeripheralModel

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        self.connectTimeOut = 3.0;
        self.centerManager = [ADSBLECenterManager shareADSBLECenterManager:dispatch_queue_create("BLEQueue", NULL)];
        
    }
    return self;
}

- (void)changeServiceArray:(NSArray<NSString *> *)serviceArray characteristicsArray:(NSArray<NSString *> *)characteristicsArray {
    
    NSMutableArray *serviceUUID = [[NSMutableArray alloc] init];
    for (NSString *string in serviceArray) {
        [serviceUUID addObject:[CBUUID UUIDWithString:string]];
    }
    _serviceArray = serviceUUID.copy;
    
    NSMutableArray *characteristicsUUID = [[NSMutableArray alloc] init];
    for (NSString *string in characteristicsArray) {
        [characteristicsUUID addObject:[CBUUID UUIDWithString:string]];
    }
    _characteristicsArray = characteristicsArray.copy;
    
}

- (void)setConnectState:(ADSConnectState)connectState {
    
    _connectState = connectState;
    
    switch (connectState) {
        case ADSConnectState_Connecting:
        {
            self.connectTimer = [XYWeakTimer scheduledTimerWithTime:self.connectTimer interval:self.connectTimeOut target:self timerBlock:^(NSTimer *timer) {
                
                _connectState = ADSConnectState_TimeOut;
                if (self.connectStateBlock) {
                    self.connectStateBlock(self);
                }
                
                [self.centerManager cancelPeripheralConnection:self];
                
            } userInfo:nil repeats:NO];
            
            if (![NSThread isMainThread]) {
                [[NSRunLoop currentRunLoop] run];
            }
            
            break;
        }
        case ADSConnectState_Connected:
        {
            [self.connectTimer invalidate];
            self.connectTimer = nil;
            self.peripheral.delegate = self;
            [self.peripheral discoverServices:_serviceArray];
            break;
        }
        default:
            break;
    }
    
    if (self.connectStateBlock) {
        self.connectStateBlock(self);
    }
    
}

#pragma mark - CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    
    if (error) {
        NSLog(@"didDiscoverServices %@",error);
    }
    
    for (CBService *service in peripheral.services) {
        
        [peripheral discoverCharacteristics:_characteristicsArray forService:service];
        
    }
    
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    
    if (error) {
        NSLog(@"didDiscoverCharacteristicsForService %@",error);
    }
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        
        if ((characteristic.properties == CBCharacteristicPropertyNotify) || (characteristic.properties == CBCharacteristicPropertyIndicate)) {
            
            [BLEUtility setNotificationForCharacteristic:peripheral sCBUUID:service.UUID cCBUUID:characteristic.UUID enable:YES];
            
        }
        
    }
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    if (error) {
        NSLog(@"didUpdateNotificationStateForCharacteristic %@",error);
    }
    else {
        
        if (characteristic.properties == CBCharacteristicPropertyNotify) {
            _connectState = ADSConnectState_NotificationFinshed;
            
            // 连接完成之后产生回调
            if ([self.centerManager.delegate respondsToSelector:@selector(disConnectPeripheral:error:)] && self.centerManager.delegate) {
                [self.centerManager.delegate disConnectPeripheral:self error:error];
            }
            
            if (self.notificationBlock) {
                self.notificationBlock(characteristic.UUID.UUIDString,self);
            }
        }
        
    }
    
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    if (error) {
        NSLog(@"didWriteValueForCharacteristic %@",error);
    }
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    if (error) {
        NSLog(@"didUpdateValueForCharacteristic %@",error);
    }
    
    if (self.receiveDataBlock) {
        self.receiveDataBlock(characteristic);
    }
    
}



@end
