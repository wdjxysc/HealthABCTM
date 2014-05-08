//
//  BloodPressureMeasureViewController.h
//  HealthABC
//
//  Created by 夏 伟 on 13-11-25.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <stdlib.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "MySingleton.h"
#import "WQPlaySound.h"

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@interface BloodPressureMeasureViewController : UIViewController<CBCentralManagerDelegate,CBPeripheralDelegate,UIAlertViewDelegate>
{
    IBOutlet UIImageView *image;
    IBOutlet UILabel *sysDataLabel;
    IBOutlet UILabel *diaDataLabel;
    IBOutlet UILabel *pulseDataLabel;
}


@property(nonatomic,retain) UIImageView *image;

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheral     *discoveredPeripheral;
@property (strong, nonatomic) CBCharacteristic *writeCharacteristic;
@property (strong, nonatomic) CBCharacteristic *notifyCharacteristic;
@property (strong, nonatomic) CBPeripheral     *targetPeripheral;
@property (nonatomic, strong) NSMutableData    *data;

@property (nonatomic) int lastsys;
@property (nonatomic) int lastdia;
@property (nonatomic) int lastpulse;

@end