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
    ADSConnectState_Connecting, // 连接中
    ADSConnectState_Connected, // 连接成功
    ADSConnectState_NotificationFinshed, // 使能成功
    ADSConnectState_TimeOut, // 连接超时
    ADSConnectState_Faiure, // 设备断开连接
};


@class ADSBLEPeripheralModel;

@protocol ADSBLECenterManagerANCSDelegate <NSObject>

// 寻找连接ANCS的代理
- (void)findANCSPeripherals:(NSArray<ADSBLEPeripheralModel *> *)peripheralModel;

@end

@protocol ADSBLECenterManagerDelegate <NSObject>

@optional
// 连接完成的回调
- (void)didConnectPeripheral:(ADSBLEPeripheralModel *)peripheralModel error:(NSError *)error;

// 扫描到设备的回调
- (void)didDiscoverPeripheral:(ADSBLEPeripheralModel *)peripheralModel error:(NSError *)error;

// 断开连接的回调
- (void)didDisconnectPeripheral:(ADSBLEPeripheralModel *)peripheralModel error:(NSError *)error;

@end

@interface ADSBLECenterManager : NSObject<CBCentralManagerDelegate>

@property (nonatomic,strong) CBCentralManager *centralManager;

@property (nonatomic,weak) id <ADSBLECenterManagerDelegate> delegate;

@property (nonatomic,weak) id <ADSBLECenterManagerANCSDelegate> ancsDelegate;

@property (nonatomic,assign) NSTimeInterval interval; // 默认

+ (instancetype)shareADSBLECenterManager:(dispatch_queue_t)queue;

// 连接设备
- (void)connectPeripheral:(ADSBLEPeripheralModel *)peripheralModel;

// 断开连接
- (void)cancelPeripheralConnection:(ADSBLEPeripheralModel *)peripheralModel;

// 开始扫描
- (void)startScan:(NSArray<NSString *> *)uuidArray ancsUUIDArray:(NSArray<NSString *> *)ancsUUIDArray;

- (void)stopScan;

@end
