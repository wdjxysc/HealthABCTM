//
//  BodyFatMeasureViewController.h
//  HealthABC
//
//  Created by 夏 伟 on 13-11-27.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <stdlib.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "MySingleton.h"
#import "WQPlaySound.h"

@interface BodyFatMeasureViewController : UIViewController<CBCentralManagerDelegate,CBPeripheralDelegate,UIAlertViewDelegate>
{
    IBOutlet UIButton *button;
    IBOutlet UIImageView *image;
    
    IBOutlet UILabel *weightDataLabel;
    IBOutlet UILabel *fatDataLabel;
    IBOutlet UILabel *muscleDataLabel;
    IBOutlet UILabel *waterDataLabel;
    IBOutlet UILabel *boneDataLabel;
    IBOutlet UILabel *visceralfatDataLabel;
    IBOutlet UILabel *bmiDataLabel;
    IBOutlet UILabel *bmrDataLabel;
    
}

@property(nonatomic,retain) UIImageView *image;
@property(nonatomic,retain) UIButton *button;

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheral     *discoveredPeripheral;
@property (strong, nonatomic) CBCharacteristic *writeCharacteristic;
@property (strong, nonatomic) CBCharacteristic *notifyCharacteristic;
@property (strong, nonatomic) CBPeripheral     *targetPeripheral;
@property (nonatomic, strong) NSMutableData    *data;

@property (nonatomic) double lastweight;
@property (nonatomic) double lastfat;
@property (nonatomic) double lastvisfat;
@property (nonatomic) double lastmuscle;
@property (nonatomic) double lastwater;
@property (nonatomic) double lastbmi;
@property (nonatomic) double lastbmr;
@property (nonatomic) double lastbone;
@property (nonatomic) double lastheight;

@end
