//
//  TemperatureViewController.h
//  HealthABC
//
//  Created by 夏 伟 on 14-3-28.
//  Copyright (c) 2014年 夏 伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface TemperatureViewController : UIViewController<CBCentralManagerDelegate,CBPeripheralDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheral     *discoveredPeripheral;
@property (strong, nonatomic) CBCharacteristic *writeCharacteristic;
@property (strong, nonatomic) CBCharacteristic *notifyCharacteristic;
@property (strong, nonatomic) CBPeripheral     *targetPeripheral;
@property (nonatomic, strong) NSMutableData    *data;

@property float currentTemperature;
@end
