//
//  ADSPeripheralList.h
//  ADSBLEManager
//
//  Created by ADSmart Tech on 2017/6/21.
//  Copyright © 2017年 ADSmart Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADSBLEPeripheralModel;

typedef void(^PeripheralListBlock)(NSArray *peripheralList);

@protocol ADSPeripheralListDelegate <NSObject>

- (void)listDidConnectPeripheral:(ADSBLEPeripheralModel *)peripheralModel;

- (void)listDidDisconnectPeripheral:(ADSBLEPeripheralModel *)peripheralModel;

@end

@interface ADSPeripheralList : NSObject

@property (nonatomic,copy) PeripheralListBlock listBlock;

@property (nonatomic,assign) NSTimeInterval scanInterval; // 默认 2.0s

@property (nonatomic,weak) id <ADSPeripheralListDelegate> delegate;

- (void)startScanPeripheral:(NSArray<NSString *> *)array ancsUUIDArray:(NSArray<NSString *> *)ancsUUIDArray;

- (void)stopScanPeripheral;

- (void)listConnectPeripheral:(ADSBLEPeripheralModel *)peripheralModel;

- (void)listCancelPeripheralConnection:(ADSBLEPeripheralModel *)peripheralModel;

@end
