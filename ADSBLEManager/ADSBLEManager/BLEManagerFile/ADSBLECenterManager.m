//
//  ADSBLECenterManager.m
//  ADSBLEManager
//
//  Created by ADSmart Tech on 2017/6/21.
//  Copyright © 2017年 ADSmart Tech. All rights reserved.
//

#import "ADSBLECenterManager.h"
#import "ADSBLEPeripheralModel.h"

static ADSBLECenterManager *bleCenterManager = nil;

static NSArray *scanUUIDArray = nil;

@interface ADSBLECenterManager ()<CBCentralManagerDelegate>

@property (nonatomic,strong) CBCentralManager *centralManager;

@property (nonatomic,strong) NSMutableDictionary *mutableDictionary;

@property (nonatomic,assign) BOOL isScaning;

@property (nonatomic,strong) NSTimer *scanTimer;

@end

@implementation ADSBLECenterManager

+ (instancetype)shareADSBLECenterManager:(dispatch_queue_t)queue {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        bleCenterManager = [[self alloc] init];
        bleCenterManager.centralManager = [[CBCentralManager alloc] initWithDelegate:bleCenterManager queue:queue options:nil];
        bleCenterManager.mutableDictionary = [[NSMutableDictionary alloc] init];
        
        bleCenterManager.interval = 2.2;
        
        bleCenterManager.scanTimer = [NSTimer scheduledTimerWithTimeInterval:bleCenterManager.interval target:bleCenterManager selector:@selector(scanTimerAction) userInfo:nil repeats:YES];
        
    });
    
    return bleCenterManager;
}

- (void)scanTimerAction {
    
    if (self.isScaning) {
        
        // 重新开启扫描
        [self stopScan];
        [self startScan:scanUUIDArray];
        
        // 寻找ANCS设备列表
        if (self.ancsDelegate && [self.ancsDelegate respondsToSelector:@selector(findANCSPeripherals:)]) {
            
            NSArray *array = [self.centralManager retrieveConnectedPeripheralsWithServices:scanUUIDArray];
            
            NSMutableArray *peripherals = [[NSMutableArray alloc] init];
            for (CBPeripheral *peripheral in array) {
                
                ADSBLEPeripheralModel *model = [[ADSBLEPeripheralModel alloc] init];
                model.peripheral = peripheral;
                
                [peripherals addObject:model];
                
            }
            
            if (peripherals.count > 0) {
                [self.ancsDelegate findANCSPeripherals:peripherals];
            }
            
        }
        
    }
    
}

- (void)startScan:(NSArray<NSString *> *)uuidArray {
    
    self.isScaning = YES;
    
    @try {
        if (self.centralManager.state == CBManagerStatePoweredOn) {
            
            NSMutableArray *uuid = [[NSMutableArray alloc] init];
            for (NSString *string in uuidArray) {
                [uuid addObject:[CBUUID UUIDWithString:string]];
            }
            
            scanUUIDArray = uuid;
            
            [self.centralManager scanForPeripheralsWithServices:uuid options:nil];
        }
    } @catch (NSException *exception) {
        NSLog(@"蓝牙扫描失败!");
    }
    
}

- (void)stopScan {
    
    self.isScaning = NO;
    
    if (self.centralManager.state == CBManagerStatePoweredOn) {
        [self.centralManager stopScan];
    }
    
}

- (void)connectPeripheral:(ADSBLEPeripheralModel *)peripheralModel {
    
    @try {
       
        [self.centralManager connectPeripheral:peripheralModel.peripheral options:nil];
        [self.mutableDictionary setObject:peripheralModel forKey:[peripheralModel.peripheral.identifier UUIDString]];
        
        peripheralModel.connectState = ADSConnectState_Connecting;
        
    } @catch (NSException *exception) {
        NSLog(@"蓝牙设备为空 连接失败");
    }
    
}

- (void)cancelPeripheralConnection:(ADSBLEPeripheralModel *)peripheralModel {
    
    @try {
        
        [self.centralManager cancelPeripheralConnection:peripheralModel.peripheral];
        [self.mutableDictionary removeObjectForKey:peripheralModel.peripheral.identifier.UUIDString];
        
    } @catch (NSException *exception) {
        NSLog(@"蓝牙设备为空 连接失败");
    }
    
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    if (central.state == CBManagerStatePoweredOn) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kADSCentralManagerDidUpdateState object:nil userInfo:@{@"State":@YES}];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kADSCentralManagerDidUpdateState object:nil userInfo:@{@"State":@NO}];
        [self.mutableDictionary removeAllObjects];
    }
    
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didDiscoverPeripheral:error:)]) {
        
        ADSBLEPeripheralModel *model = [[ADSBLEPeripheralModel alloc] init];
        model.madvertisementData = advertisementData;
        model.peripheral = peripheral;
        model.rssi = [RSSI integerValue];
        [self.delegate didDiscoverPeripheral:model error:nil];
        
    }
    
}

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *,id> *)dict {
    
    self.centralManager = central;
    
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    NSString *uuidString = [peripheral.identifier UUIDString];
    ADSBLEPeripheralModel *model = [self.mutableDictionary objectForKey:uuidString];
    model.connectState = ADSConnectState_Connected;
    
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didDisconnectPeripheral:error:)]) {
        NSString *uuidString = [peripheral.identifier UUIDString];
        ADSBLEPeripheralModel *model = [self.mutableDictionary objectForKey:uuidString];
        model.connectState = ADSConnectState_Faiure;
        [self.delegate didDisconnectPeripheral:model error:error];
        [self.mutableDictionary removeObjectForKey:uuidString];
    }
    
}

@end
