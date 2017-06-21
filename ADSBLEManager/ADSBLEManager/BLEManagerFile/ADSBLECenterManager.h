//
//  ADSBLECenterManager.h
//  ADSBLEManager
//
//  Created by ADSmart Tech on 2017/6/21.
//  Copyright © 2017年 ADSmart Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define kADSCentralManagerDidUpdateState @"ADSCentralManagerDidUpdateState"

typedef NS_ENUM(NSInteger, ADSConnectState) {
    ADSConnectState_None,
    ADSConnectState_Connecting,
    ADSConnectState_Connected,
    ADSConnectState_NotificationFinshed, // 使能成功
    ADSConnectState_TimeOut,
    ADSConnectState_Faiure,
};


@class ADSBLEPeripheralModel;

@protocol ADSBLECenterManagerANCSDelegate <NSObject>

- (void)findANCSPeripherals:(NSArray<ADSBLEPeripheralModel *> *)peripheralModel;

@end

@protocol ADSBLECenterManagerDelegate <NSObject>

@optional
// 连接完成的回调
- (void)disConnectPeripheral:(ADSBLEPeripheralModel *)peripheralModel error:(NSError *)error;

// 扫描到设备的回调
- (void)didDiscoverPeripheral:(ADSBLEPeripheralModel *)peripheralModel error:(NSError *)error;

// 断开连接的回调
- (void)didDisconnectPeripheral:(ADSBLEPeripheralModel *)peripheralModel error:(NSError *)error;

@end

@interface ADSBLECenterManager : NSObject 

@property (nonatomic,weak) id <ADSBLECenterManagerDelegate> delegate;

@property (nonatomic,weak) id <ADSBLECenterManagerANCSDelegate> ancsDelegate;

@property (nonatomic,assign) NSTimeInterval interval; // 默认

+ (instancetype)shareADSBLECenterManager:(dispatch_queue_t)queue;

- (void)connectPeripheral:(ADSBLEPeripheralModel *)peripheralModel;

- (void)cancelPeripheralConnection:(ADSBLEPeripheralModel *)peripheralModel;

- (void)startScan:(NSArray<NSString *> *)uuidArray;

- (void)stopScan;

@end
