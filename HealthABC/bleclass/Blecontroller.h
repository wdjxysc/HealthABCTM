//
//  blecontroller.h
//  BTLE
//
//  Created by 夏 伟 on 13-12-27.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

extern NSString *BleDataReceivedNotification;
extern NSString *HistoryDataNotification;
extern NSString *SleepMonitorDataNotification;
extern NSString *BatteryDataNotification;
extern NSString *DeviceInfoNotification;

@interface Blecontroller : NSObject<CBPeripheralManagerDelegate, UITextViewDelegate>


@property (strong, nonatomic) CBCentralManager      *centralManager;
@property (strong, nonatomic) CBPeripheral          *discoveredPeripheral;
@property (strong, nonatomic) CBPeripheral          *connectedPeripheral;
@property (strong, nonatomic) NSMutableData         *data;
@property (strong, nonatomic) NSMutableData         *batterydata;
@property (strong, nonatomic) NSMutableData         *deviceinfodata;
@property (strong, nonatomic) NSMutableData         *historystepdata;
@property (strong, nonatomic) NSMutableData         *sleepmonitordata;
@property (strong, nonatomic) CBCharacteristic      *timeCharacteristic;
@property (strong, nonatomic) CBCharacteristic      *historyClearCharacteristic;
@property (strong, nonatomic) CBCharacteristic      *callerCharacteristic;
@property (strong, nonatomic) CBCharacteristic      *sportCharacteristic;
@property (strong, nonatomic) CBCharacteristic      *alarmCharacteristic;
@property (strong, nonatomic) CBCharacteristic      *userinfoCharacteristic;

@property (strong, nonatomic) CBPeripheralManager       *peripheralManager;
@property (strong, nonatomic) CBMutableCharacteristic   *transferCharacteristic;
@property (strong, nonatomic) NSData                    *dataToSend;
@property (nonatomic, readwrite) NSInteger              sendDataIndex;

//设备名
@property (strong, nonatomic) NSString *DEVICE_NAME;

//当天步数服务及特征
@property (strong, nonatomic) NSString *TRANSFER_SERVICE_UUID;
@property (strong, nonatomic) NSString *TRANSFER_CHARACTERISTIC_UUID;

//电量服务及特征
@property (strong, nonatomic) NSString *BATTERY_SERVICE_UUID;
@property (strong, nonatomic) NSString *BATTERY_CHARACTERISTIC_UUID;

//设备时间
@property (strong, nonatomic) NSString *TIME_SERVICE_UUID;
@property (strong, nonatomic) NSString *TIME_CHARACTERISTIC_UUID;

//历史步数服务及特征
@property (strong, nonatomic) NSString *HISTORYSTEP_SERVICE_UUID;
@property (strong, nonatomic) NSString *HISTORYSTEP_CLEAR_CHARACTERISTIC_UUID;
@property (strong, nonatomic) NSString *HISTORYSTEP_DATA_CHARACTERISTIC_UUID;

//设备信息服务及特征
@property (strong, nonatomic) NSString *DEVICE_INFO_SERVICE_UUID;
@property (strong, nonatomic) NSString *DEVICE_INFO_CHARACTERISTIC_UUID;

//睡眠监控服务及特征
@property (strong, nonatomic) NSString *SLEEPMONITOR_SERVICE_UUID;
@property (strong, nonatomic) NSString *SLEEPMONITOR_DATA_CHARACTERISTIC_UUID;

//提醒服务及特征
@property (strong, nonatomic) NSString *REMIND_SERVICE_UUID;
@property (strong, nonatomic) NSString *CALLER_REMIND_CHARACTERISTIC_UUID;
@property (strong, nonatomic) NSString *SPORT_REMIND_CHARACTERISTIC_UUID;
@property (strong, nonatomic) NSString *ALARM_REMIND_CHARACTERISTIC_UUID;

//用户信息服务及特征
@property (strong, nonatomic) NSString *USERINFO_SERVICE_UUID;
@property (strong, nonatomic) NSString *USERINFO_CHARACTERISTIC_UUID;


+(Blecontroller *)shareBlecontroller;
-(void)cleanup;
-(void)setService_UUID:(NSString *)serviceuuid;
-(void)setCharacteristec_UUID:(NSString *)characteristecuuid;
-(void)managerinit;
-(void)setDeviceName:(NSString *)devicename;

-(void)setBATTERY_SERVICE_UUID:(NSString *)string_BATTERY_SERVICE_UUID;
-(void)setBATTERY_CHARACTERISTIC_UUID:(NSString *)string_BATTERY_CHARACTERISTIC_UUID;
-(void)setTIME_SERVICE_UUID:(NSString *)string_TIME_SERVICE_UUID;
-(void)setTIME_CHARACTERISTIC_UUID:(NSString *)string_TIME_CHARACTERISTIC_UUID;
-(void)setHISTORYSTEP_SERVICE_UUID:(NSString *)string_HISTORYSTEP_SERVICE_UUID;
-(void)setHISTORYSTEP_CLEAR_CHARACTERISTIC_UUID:(NSString *)vHISTORYSTEP_CLEAR_CHARACTERISTIC_UUID;
-(void)setHISTORYSTEP_DATA_CHARACTERISTIC_UUID:(NSString *)string_HISTORYSTEP_DATA_CHARACTERISTIC_UUID;
-(void)setDEVICE_INFO_SERVICE_UUID:(NSString *)string_DEVICE_INFO_SERVICE_UUID;
-(void)setSLEEPMONITOR_SERVICE_UUID:(NSString *)string_SLEEPMONITOR_SERVICE_UUID;
-(void)setSLEEPMONITOR_DATA_CHARACTERISTIC_UUID:(NSString *)string_SLEEPMONITOR_DATA_CHARACTERISTIC_UUID;
-(void)setREMIND_SERVICE_UUID:(NSString *)string_REMIND_SERVICE_UUID;
-(void)setCALLER_REMIND_CHARACTERISTIC_UUID:(NSString *)string_CALLER_REMIND_CHARACTERISTIC_UUID;
-(void)setSPORT_REMIND_CHARACTERISTIC_UUID:(NSString *)string_SPORT_REMIND_CHARACTERISTIC_UUID;
-(void)setALARM_REMIND_CHARACTERISTIC_UUID:(NSString *)string_ALARM_REMIND_CHARACTERISTIC_UUID;
-(void)setUSERINFO_SERVICE_UUID:(NSString *)string_USERINFO_SERVICE_UUID;
-(void)setUSERINFO_CHARACTERISTIC_UUID:(NSString *)string_USERINFO_CHARACTERISTIC_UUID;
-(void)setCurrentTime:(NSData *)data;
-(void)setCallerRemind:(NSData *)data;
-(void)setSportRemind:(NSData *)data;
-(void)setAlarmRemind:(NSData *)data;
-(void)setUserInfo:(NSData *)data;
@end
