//
//  ADSBLEDataHandle.h
//  ADSBLEManager
//
//  Created by ADSmart Tech on 2017/6/21.
//  Copyright © 2017年 ADSmart Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADSBLEPeripheralModel.h"

/*
    数据的发送打包方法
    数据回调的解析方法
 
    广播包的解析方法
    
    这个类为空实现,继承出来重写该类
 
 */

@interface ADSBLEDataHandle : NSObject

/**
 发送蓝牙数据 打包方法

 @param peripheralModel peripheralModel description
 @param sCBUUID 服务UUID
 @param cCBUUID 特征UUID
 */
- (void)sendDataWithPeripheralModel:(ADSBLEPeripheralModel *)peripheralModel sCBUUID:(NSString *)sCBUUID cCBUUID:(NSString *)cCBUUID;

/**
 解析蓝牙返回的数据方法

 @param value 数据
 */
- (void)resolveUpdateValueForCharacteristic:(NSData *)value;

/**
 解析广播包内容

 @param advertisementData 广播包字典
 */
- (void)resolveAdvertisementData:(NSDictionary<NSString *, id> *)advertisementData;

@end
