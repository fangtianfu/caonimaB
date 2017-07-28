//
//  ADSPeripheralList.m
//  ADSBLEManager
//
//  Created by ADSmart Tech on 2017/6/21.
//  Copyright © 2017年 ADSmart Tech. All rights reserved.
//

#import "ADSPeripheralList.h"
#import "ADSBLECenterManager.h"
#import "ADSBLEPeripheralModel.h"
#import "XYWeakTimer.h"
#import "ADSBLEPeripheralModel.h"

static ADSPeripheralList *peripheralList = nil;

@interface ADSPeripheralList ()<ADSBLECenterManagerDelegate>

@property (nonatomic,strong) NSMutableDictionary *scanDictionary;

@property (nonatomic,strong) NSTimer *scanTimer;

@property (nonatomic,strong) ADSBLECenterManager *centerManager;

@end

@implementation ADSPeripheralList

+ (instancetype)shareADSPeripheralList {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        peripheralList = [[self alloc] init];
        peripheralList.scanInterval = 2.0;
        
        peripheralList.scanDictionary = [NSMutableDictionary new];
        
        peripheralList.centerManager = [ADSBLECenterManager shareADSBLECenterManager:dispatch_queue_create("BLEQueue", NULL)];
        peripheralList.centerManager.delegate = peripheralList;
        
    });
    
    return peripheralList;
}

- (void)startScanPeripheral:(NSArray<NSString *> *)array {
    
    [self.centerManager startScan:array];
    
    self.scanTimer = [XYWeakTimer scheduledTimerWithTime:self.scanTimer interval:self.scanInterval target:self timerBlock:^(NSTimer *timer) {
        
        if (self.listBlock) {
            self.listBlock(self.scanDictionary.allValues.copy);
        }
        
        [self.scanDictionary removeAllObjects];
        
    } userInfo:nil repeats:YES];
    
}

- (void)stopScanPeripheral {
    
    [self.scanTimer invalidate];
    self.scanTimer = nil;
    
    [self.centerManager stopScan];
    
    [self.scanDictionary removeAllObjects];
    
}

- (void)listConnectPeripheral:(ADSBLEPeripheralModel *)peripheralModel {
    
    [self.centerManager connectPeripheral:peripheralModel];
    
}

- (void)listCancelPeripheralConnection:(ADSBLEPeripheralModel *)peripheralModel {
    
    [self.centerManager cancelPeripheralConnection:peripheralModel];
    
}

// 扫描到设备的回调
- (void)didDiscoverPeripheral:(ADSBLEPeripheralModel *)peripheralModel error:(NSError *)error {
    
    [self.scanDictionary setObject:peripheralModel forKey:peripheralModel.peripheral.identifier.UUIDString];
    
}

// 连接完成的回调
- (void)disConnectPeripheral:(ADSBLEPeripheralModel *)peripheralModel error:(NSError *)error {
    
    [self.scanDictionary removeObjectForKey:peripheralModel.peripheral.identifier.UUIDString];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(listDidDisconnectPeripheral:)]) {
        [self.delegate listDisConnectPeripheral:peripheralModel];
    }
    
}

// 断开连接的回调
- (void)didDisconnectPeripheral:(ADSBLEPeripheralModel *)peripheralModel error:(NSError *)error {
    
    [self.scanDictionary removeObjectForKey:peripheralModel.peripheral.identifier.UUIDString];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(listDidDisconnectPeripheral:)]) {
        [self.delegate listDidDisconnectPeripheral:peripheralModel];
    }
    
}


@end
