//
//  WeightMeasureViewController.h
//  HealthABC
//
//  Created by 夏 伟 on 13-11-25.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "MySingleton.h"
#import "WQPlaySound.h"

@interface WeightMeasureViewController : UIViewController<CBCentralManagerDelegate,CBPeripheralDelegate,UIAlertViewDelegate>
{
    IBOutlet UIImageView *image;
}

@property(nonatomic,retain) UIImageView *image;

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheral     *discoveredPeripheral;
@property (strong, nonatomic) CBCharacteristic *writeCharacteristic;
@property (strong, nonatomic) CBCharacteristic *notifyCharacteristic;
@property (strong, nonatomic) CBPeripheral     *targetPeripheral;
@property (nonatomic, strong) NSMutableData    *data;

@property (nonatomic) float lastWeightData;
@end
