/*
 *  bleUtility.h
 *
 * Created by Ole Andreas Torvmark on 10/2/12.
 * Copyright (c) 2012 Texas Instruments Incorporated - http://www.ti.com/
 * ALL RIGHTS RESERVED
 */

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BLEUtility : NSObject
//函数名：readCharacteristic:(CBPeripheral *)peripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID
//作者：skyfang
//函数入参:peripheral：操作的外设对象
//       sUUID:服务的uuid字符串
//       cUUID:子项的uuid字符串
//函数返回:无；
//函数功能：读取相应uuid的值
+(void)readCharacteristic:(CBPeripheral *)peripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID;
//函数名：setNotificationForCharacteristic:(CBPeripheral *)peripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID enable:(BOOL)enable
//作者：skyfang
//函数入参:peripheral：操作的外设对象
//       sUUID:服务的uuid字符串
//       cUUID:子项的uuid字符串
//       enable:使能标志位
//函数返回:无；
//函数功能：使能通知
+(void)setNotificationForCharacteristic:(CBPeripheral *)peripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID enable:(BOOL)enable;
//函数名：writeCharacteristic:(CBPeripheral *)peripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID data:(NSData *)data
//作者：skyfang
//函数入参:peripheral：操作的外设对象
//       sUUID:服务的uuid
//       cUUID:子项的uuid
//       data:要写入数据
//函数返回:无；
//函数功能：写入数据带返回
+(void)writeCharacteristic:(CBPeripheral *)peripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID data:(NSData *)data;
//函数名：writeCharacteristicWithoutResponse:(CBPeripheral *)peripheral sCBUUID:(CBUUID *)sCBUUID cCBUUID:(CBUUID *)cCBUUID data:(NSData *)data
//作者：skyfang
//函数入参:peripheral：操作的外设对象
//       sUUID:服务的uuid字符串
//       cUUID:子项的uuid字符串
//       data:要写入数据
//函数返回:无；
//函数功能：写入数据不带返回
+(void)writeCharacteristicWithoutResponse:(CBPeripheral *)peripheral sCBUUID:(CBUUID *)sCBUUID cCBUUID:(CBUUID *)cCBUUID data:(NSData *)data;
//函数名：writeCharacteristic:(CBPeripheral *)peripheral sCBUUID:(CBUUID *)sCBUUID cCBUUID:(CBUUID *)cCBUUID data:(NSData *)data
//作者：skyfang
//函数入参:peripheral：操作的外设对象
//       sUUID:服务的uuid
//       cUUID:子项的uuid
//函数返回:无；
//函数功能：读写入数据带返回
+(void)writeCharacteristic:(CBPeripheral *)peripheral sCBUUID:(CBUUID *)sCBUUID cCBUUID:(CBUUID *)cCBUUID data:(NSData *)data;
//函数名：readCharacteristic:(CBPeripheral *)peripheral sCBUUID:(CBUUID *)sCBUUID cCBUUID:(CBUUID *)cCBUUID;
//作者：skyfang
//函数入参:peripheral：操作的外设对象
//       sUUID:服务的uuid
//       cUUID:子项的uuid
//函数返回:无；
//函数功能：读取相应uuid的值
+(void)readCharacteristic:(CBPeripheral *)peripheral sCBUUID:(CBUUID *)sCBUUID cCBUUID:(CBUUID *)cCBUUID;
//函数名：setNotificationForCharacteristic:(CBPeripheral *)peripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID enable:(BOOL)enable
//作者：skyfang
//函数入参:peripheral：操作的外设对象
//       sUUID:服务的uuid
//       cUUID:子项的uuid
//       enable:使能标志位
//函数返回:无；
//函数功能：使能通知
+(void)setNotificationForCharacteristic:(CBPeripheral *)peripheral sCBUUID:(CBUUID *)sCBUUID cCBUUID:(CBUUID *)cCBUUID enable:(BOOL)enable;
//函数名：isCharacteristicNotifiable:(CBPeripheral *)peripheral sCBUUID:(CBUUID *)sCBUUID cCBUUID:(CBUUID *) cCBUUID
//作者：skyfang
//函数入参:peripheral：操作的外设对象
//       sUUID:服务的uuid
//       cUUID:子项的uuid
//函数返回:无；
//函数功能：子项是否已经使能
+(bool) isCharacteristicNotifiable:(CBPeripheral *)peripheral sCBUUID:(CBUUID *)sCBUUID cCBUUID:(CBUUID *) cCBUUID;


@end
