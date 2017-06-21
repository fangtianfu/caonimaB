//
//  ADSPeripheralModel.h
//  ADSBLEManager
//
//  Created by ADSmart Tech on 2017/6/21.
//  Copyright © 2017年 ADSmart Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADSBLECenterManager.h"

typedef void(^ConnectStateBlock)(ADSBLEPeripheralModel *peripheralModel);

typedef void(^NotificationBlock)(NSString *characteristic,ADSBLEPeripheralModel *peripheralModel);

typedef void(^ReceiveDataBlock)(CBCharacteristic *characteristic);

@interface ADSBLEPeripheralModel : NSObject

@property (nonatomic,strong) CBPeripheral *peripheral;

@property (nonatomic,strong) NSDictionary<NSString *, id> *madvertisementData;

@property (nonatomic,assign) NSInteger rssi;

@property (nonatomic,assign) ADSConnectState connectState;

@property (nonatomic,assign) NSTimeInterval connectTimeOut;

@property (nonatomic,copy) ConnectStateBlock connectStateBlock;

@property (nonatomic,copy) NotificationBlock notificationBlock;

@property (nonatomic,copy) ReceiveDataBlock receiveDataBlock;

/**
 初始化 服务与特征 UUID数组

 @param serviceArray 服务UUID数组
 @param characteristicsArray 特征UUID数组
 */
- (void)changeServiceArray:(NSArray<NSString *> *)serviceArray characteristicsArray:(NSArray<NSString *> *)characteristicsArray;

@end
