//
//  blecontroller.m
//  BTLE
//
//  Created by 夏 伟 on 13-12-27.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import "Blecontroller.h"
#import <CoreBluetooth/CoreBluetooth.h>

NSString *BleDataReceivedNotification = @"BleDataReceivedNotification";
NSString *HistoryDataNotification = @"HistoryDataNotification";
NSString *SleepMonitorDataNotification = @"SleepMonitorDataNotification";
NSString *BatteryDataNotification = @"BatteryDataNotification";
NSString *DeviceInfoNotification = @"DeviceInfoNotification";
@interface Blecontroller () <CBCentralManagerDelegate, CBPeripheralDelegate>

@end

@implementation Blecontroller
@synthesize TRANSFER_SERVICE_UUID;
@synthesize TRANSFER_CHARACTERISTIC_UUID;
@synthesize DEVICE_NAME;
@synthesize BATTERY_SERVICE_UUID;
@synthesize BATTERY_CHARACTERISTIC_UUID;
@synthesize TIME_SERVICE_UUID;
@synthesize TIME_CHARACTERISTIC_UUID;
@synthesize HISTORYSTEP_SERVICE_UUID;
@synthesize HISTORYSTEP_DATA_CHARACTERISTIC_UUID;
@synthesize HISTORYSTEP_CLEAR_CHARACTERISTIC_UUID;
@synthesize DEVICE_INFO_SERVICE_UUID;
@synthesize DEVICE_INFO_CHARACTERISTIC_UUID;
@synthesize SLEEPMONITOR_SERVICE_UUID;
@synthesize SLEEPMONITOR_DATA_CHARACTERISTIC_UUID;
@synthesize REMIND_SERVICE_UUID;
@synthesize CALLER_REMIND_CHARACTERISTIC_UUID;
@synthesize SPORT_REMIND_CHARACTERISTIC_UUID;
@synthesize ALARM_REMIND_CHARACTERISTIC_UUID;
@synthesize USERINFO_CHARACTERISTIC_UUID;
@synthesize USERINFO_SERVICE_UUID;
//@synthesize timeCharacteristic;
//@synthesize callerCharacteristic;
//@synthesize sportCharacteristic;
//@synthesize alarmCharacteristic;
//@synthesize userinfoCharacteristic;

//peripheralManagerDidUpdateState


#pragma mark - Public Methods

+(Blecontroller *)shareBlecontroller
{
    static Blecontroller *blecontroller = nil;
    if(blecontroller == nil)
    {
        blecontroller = [[Blecontroller alloc]init];
    }
    return blecontroller;
}

-(void)setDeviceName:(NSString *)devicename
{
    DEVICE_NAME = devicename;
}


-(void)setService_UUID:(NSString *)serviceuuid
{
    TRANSFER_SERVICE_UUID = serviceuuid;
}


-(void)setCharacteristec_UUID:(NSString *)characteristecuuid
{
    TRANSFER_CHARACTERISTIC_UUID = characteristecuuid;
}

-(void)setBATTERY_SERVICE_UUID:(NSString *)string_BATTERY_SERVICE_UUID
{
    BATTERY_SERVICE_UUID = string_BATTERY_SERVICE_UUID;
}

-(void)setBATTERY_CHARACTERISTIC_UUID:(NSString *)string_BATTERY_CHARACTERISTIC_UUID
{
    BATTERY_CHARACTERISTIC_UUID = string_BATTERY_CHARACTERISTIC_UUID;
}

-(void)setTIME_SERVICE_UUID:(NSString *)string_TIME_SERVICE_UUID
{
    TIME_SERVICE_UUID = string_TIME_SERVICE_UUID;
}

-(void)setTIME_CHARACTERISTIC_UUID:(NSString *)string_TIME_CHARACTERISTIC_UUID
{
    TIME_CHARACTERISTIC_UUID = string_TIME_CHARACTERISTIC_UUID;
}

-(void)setHISTORYSTEP_SERVICE_UUID:(NSString *)string_HISTORYSTEP_SERVICE_UUID
{
    HISTORYSTEP_SERVICE_UUID = string_HISTORYSTEP_SERVICE_UUID;
}

-(void)setHISTORYSTEP_CLEAR_CHARACTERISTIC_UUID:(NSString *)string_HISTORYSTEP_CLEAR_CHARACTERISTIC_UUID
{
    HISTORYSTEP_CLEAR_CHARACTERISTIC_UUID = string_HISTORYSTEP_CLEAR_CHARACTERISTIC_UUID;
}

-(void)setHISTORYSTEP_DATA_CHARACTERISTIC_UUID:(NSString *)string_HISTORYSTEP_DATA_CHARACTERISTIC_UUID
{
    HISTORYSTEP_DATA_CHARACTERISTIC_UUID = string_HISTORYSTEP_DATA_CHARACTERISTIC_UUID;
}

-(void)setDEVICE_INFO_SERVICE_UUID:(NSString *)string_DEVICE_INFO_SERVICE_UUID
{
    DEVICE_INFO_SERVICE_UUID = string_DEVICE_INFO_SERVICE_UUID;
}

-(void)setSLEEPMONITOR_SERVICE_UUID:(NSString *)string_SLEEPMONITOR_SERVICE_UUID
{
    SLEEPMONITOR_SERVICE_UUID = string_SLEEPMONITOR_SERVICE_UUID;
}

-(void)setSLEEPMONITOR_DATA_CHARACTERISTIC_UUID:(NSString *)string_SLEEPMONITOR_DATA_CHARACTERISTIC_UUID
{
    SLEEPMONITOR_DATA_CHARACTERISTIC_UUID = string_SLEEPMONITOR_DATA_CHARACTERISTIC_UUID;
}

-(void)setREMIND_SERVICE_UUID:(NSString *)string_REMIND_SERVICE_UUID
{
    REMIND_SERVICE_UUID = string_REMIND_SERVICE_UUID;
}

-(void)setCALLER_REMIND_CHARACTERISTIC_UUID:(NSString *)string_CALLER_REMIND_CHARACTERISTIC_UUID
{
    CALLER_REMIND_CHARACTERISTIC_UUID = string_CALLER_REMIND_CHARACTERISTIC_UUID;
}

-(void)setSPORT_REMIND_CHARACTERISTIC_UUID:(NSString *)string_SPORT_REMIND_CHARACTERISTIC_UUID
{
    SPORT_REMIND_CHARACTERISTIC_UUID = string_SPORT_REMIND_CHARACTERISTIC_UUID;
}

-(void)setALARM_REMIND_CHARACTERISTIC_UUID:(NSString *)string_ALARM_REMIND_CHARACTERISTIC_UUID
{
    ALARM_REMIND_CHARACTERISTIC_UUID = string_ALARM_REMIND_CHARACTERISTIC_UUID;
}

-(void)setUSERINFO_SERVICE_UUID:(NSString *)string_USERINFO_SERVICE_UUID
{
    USERINFO_SERVICE_UUID = string_USERINFO_SERVICE_UUID;
}

-(void)setUSERINFO_CHARACTERISTIC_UUID:(NSString *)string_USERINFO_CHARACTERISTIC_UUID
{
    USERINFO_CHARACTERISTIC_UUID = string_USERINFO_CHARACTERISTIC_UUID;
}

-(void)managerinit
{
    // Start up the CBCentralManager
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    // And somewhere to store the incoming data
    _data = [[NSMutableData alloc] init];
    
    _historystepdata = [[NSMutableData alloc] init];
    _sleepmonitordata = [[NSMutableData alloc] init];
    _batterydata = [[NSMutableData alloc] init];
    _deviceinfodata = [[NSMutableData alloc] init];
}

#pragma mark - Peripheral Methods



/** Required protocol method.  A full app should take care of all the possible states,
 *  but we're just waiting for  to know when the CBPeripheralManager is ready
 */
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    // Opt out from any other state
    if (peripheral.state != CBPeripheralManagerStatePoweredOn) {
        return;
    }
    
    // We're in CBPeripheralManagerStatePoweredOn state...
    NSLog(@"self.peripheralManager powered on.");
    
    // ... so build our service.
    
    // Start with the CBMutableCharacteristic
    self.transferCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]
                                                                     properties:CBCharacteristicPropertyNotify
                                                                          value:nil
                                                                    permissions:CBAttributePermissionsReadable];
    
    // Then the service
    CBMutableService *transferService = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]
                                                                       primary:YES];
    
    // Add the characteristic to the service
    transferService.characteristics = @[self.transferCharacteristic];
    
    // And add it to the peripheral manager
    [self.peripheralManager addService:transferService];
}


#pragma mark - Central Methods


/** centralManagerDidUpdateState is a required protocol method.
 *  Usually, you'd check for other states to make sure the current device supports LE, is powered on, etc.
 *  In this instance, we're just using it to wait for CBCentralManagerStatePoweredOn, which indicates
 *  the Central is ready to be used.
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state != CBCentralManagerStatePoweredOn) {
        // In a real app, you'd deal with all the states correctly
        return;
    }
    
    // The state must be CBCentralManagerStatePoweredOn...
    
    // ... so start scanning
    [self scan];
    
}


/** Scan for peripherals - specifically for our service's 128bit CBUUID
 */
- (void)scan
{
    [self.centralManager scanForPeripheralsWithServices:nil
                                                options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    
    NSLog(@"Scanning started");
}


/** This callback comes whenever a peripheral that is advertising the TRANSFER_SERVICE_UUID is discovered.
 *  We check the RSSI, to make sure it's close enough that we're interested in it, and if it is,
 *  we start the connection process
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    // Reject any where the value is above reasonable range
    
    //    if (RSSI.integerValue > -15) {
    //        return;
    //    }
    //
    //    // Reject if the signal strength is too low to be close enough (Close is around -22dB)
    //    if (RSSI.integerValue < -35) {
    //        return;
    //    }
    
    NSLog(@"Discovered %@ at %@", peripheral.name, RSSI);
    
    for(int i = 0;i < sizeof(peripheral.services);i++)
    {
        NSLog(@"services : %@",peripheral.services[i]);
    }
    
    
    if([peripheral.name isEqualToString:DEVICE_NAME]){
        
        // Ok, it's in range - have we already seen it?
        if (self.discoveredPeripheral != peripheral) {
            
            // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
            self.discoveredPeripheral = peripheral;
            self.connectedPeripheral = peripheral;
            
            // And connect
            NSLog(@"Connecting to peripheral %@", peripheral);
            [self.centralManager connectPeripheral:peripheral options:nil];
        }
    }
}


/** If the connection fails for whatever reason, we need to deal with it.
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Failed to connect to %@. (%@)", peripheral, [error localizedDescription]);
    [self cleanup];
}


/** We've connected to the peripheral, now we need to discover the services and characteristics to find the 'transfer' characteristic.
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Peripheral Connected");
    
    // Stop scanning
    [self.centralManager stopScan];
    NSLog(@"Scanning stopped");
    
    // Clear the data that we may already have
    [self.data setLength:0];
    
    // Make sure we get the discovery callbacks
    peripheral.delegate = self;
    
    // Search only for services that match our UUID
    [peripheral discoverServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]]];
//    [peripheral discoverServices:@[[CBUUID UUIDWithString:BATTERY_SERVICE_UUID]]];
//    [peripheral discoverServices:@[[CBUUID UUIDWithString:TIME_SERVICE_UUID]]];
//    [peripheral discoverServices:@[[CBUUID UUIDWithString:HISTORYSTEP_SERVICE_UUID]]];
//    [peripheral discoverServices:@[[CBUUID UUIDWithString:DEVICE_INFO_SERVICE_UUID]]];
//    [peripheral discoverServices:@[[CBUUID UUIDWithString:SLEEPMONITOR_SERVICE_UUID]]];
//    [peripheral discoverServices:@[[CBUUID UUIDWithString:REMIND_SERVICE_UUID]]];
//    [peripheral discoverServices:@[[CBUUID UUIDWithString:USERINFO_SERVICE_UUID]]];
}


/** The Transfer Service was discovered
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering services: %@", [error localizedDescription]);
        [self cleanup];
        return;
    }
    
    int i = sizeof(peripheral.services);
    NSLog(@"共有服务%d个",i);
    // Discover the characteristic we want...
    
    // Loop through the newly filled peripheral.services array, just in case there's more than one.
    for (CBService *service in peripheral.services) {
        NSLog(@"Service found with UUID: %@",service.UUID);
        // Discovers the characteristics for a given service
        
        if ([service.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]])
        {
            [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]] forService:service];
        }
        else if([service.UUID isEqual:[CBUUID UUIDWithString:BATTERY_SERVICE_UUID]])
        {
            [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:BATTERY_CHARACTERISTIC_UUID]] forService:service];
        }
        else if([service.UUID isEqual:[CBUUID UUIDWithString:TIME_SERVICE_UUID]])
        {
            [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:TIME_CHARACTERISTIC_UUID]] forService:service];
        }
        else if([service.UUID isEqual:[CBUUID UUIDWithString:HISTORYSTEP_SERVICE_UUID]])
        {
            [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:HISTORYSTEP_DATA_CHARACTERISTIC_UUID]] forService:service];
            [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:HISTORYSTEP_CLEAR_CHARACTERISTIC_UUID]] forService:service];
        }
        else if([service.UUID isEqual:[CBUUID UUIDWithString:DEVICE_INFO_SERVICE_UUID]])
        {
            [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:DEVICE_INFO_CHARACTERISTIC_UUID]] forService:service];
        }
        else if([service.UUID isEqual:[CBUUID UUIDWithString:SLEEPMONITOR_SERVICE_UUID]])
        {
            [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:SLEEPMONITOR_DATA_CHARACTERISTIC_UUID]] forService:service];
        }
        else if([service.UUID isEqual:[CBUUID UUIDWithString:REMIND_SERVICE_UUID]])
        {
            [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:CALLER_REMIND_CHARACTERISTIC_UUID]] forService:service];
            [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:SPORT_REMIND_CHARACTERISTIC_UUID]] forService:service];
            [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:ALARM_REMIND_CHARACTERISTIC_UUID]] forService:service];
        }
        else if([service.UUID isEqual:[CBUUID UUIDWithString:USERINFO_SERVICE_UUID]])
        {
            [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:USERINFO_CHARACTERISTIC_UUID]] forService:service];
        }
        //[peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]] forService:service];
    }
}


/** The Transfer characteristic was discovered.
 *  Once this has been found, we want to subscribe to it, which lets the peripheral know we want the data it contains
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    // Deal with errors (if any)
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        [self cleanup];
        return;
    }
    
    CBCharacteristic *readcharacteristic;
    
    // Again, we loop through the array, just in case.
    for (CBCharacteristic *characteristic in service.characteristics) {
        
        NSLog(@"特征:%@",characteristic.UUID);
        
        // And check if it's the right one
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
            
            // If it is, subscribe to it
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            NSString *stringFromData = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
            NSLog(@"%@", stringFromData);
            NSData *lol = characteristic.value;
            Byte *byte = (Byte *)[lol bytes];
            for(int i = 0;i<[lol length];i++)
            {
                NSLog(@"收到%d字节：%d",(int)[lol length],(int)byte[i]);
            }
            if([lol length] == 8){
                [self.data appendData:lol];
                [[NSNotificationCenter defaultCenter] postNotificationName:BleDataReceivedNotification object:self userInfo:nil];
            }
            if([lol length] >10)
            {
                NSLog(@"Coooooooooooooooooooooooooooooool~");
                NSLog(@"Cooooooooooooooooooooooooooooooool~");
            }
            
            readcharacteristic = characteristic;
        }
        else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:BATTERY_CHARACTERISTIC_UUID]])
        {
            // If it is, subscribe to it
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            NSString *stringFromData = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
            NSLog(@"%@", stringFromData);
            NSData *lol = characteristic.value;
            Byte *byte = (Byte *)[lol bytes];
            for(int i = 0;i<[lol length];i++)
            {
                NSLog(@"收到%d字节：%d",(int)[lol length],(int)byte[i]);
            }
            if(1){
                [self.batterydata appendData:lol];
                [[NSNotificationCenter defaultCenter] postNotificationName:BatteryDataNotification object:self userInfo:nil];
            }
        }
        else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:TIME_CHARACTERISTIC_UUID]])
        {
            // If it is, subscribe to it
            
            self.timeCharacteristic = characteristic;
        }
        else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:HISTORYSTEP_DATA_CHARACTERISTIC_UUID]])
        {
            // If it is, subscribe to it
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            NSString *stringFromData = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
            NSLog(@"%@", stringFromData);
            NSData *lol = characteristic.value;
            Byte *byte = (Byte *)[lol bytes];
            for(int i = 0;i<[lol length];i++)
            {
                NSLog(@"收到%d字节：%d",(int)[lol length],(int)byte[i]);
            }
        }
        else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:HISTORYSTEP_CLEAR_CHARACTERISTIC_UUID]])
        {
            // If it is, subscribe to it
            
            self.historyClearCharacteristic = characteristic;
        }
        else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:DEVICE_INFO_CHARACTERISTIC_UUID]])
        {
            // If it is, subscribe to it
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            NSString *stringFromData = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
            NSLog(@"%@", stringFromData);
            NSData *lol = characteristic.value;
            Byte *byte = (Byte *)[lol bytes];
            for(int i = 0;i<[lol length];i++)
            {
                NSLog(@"收到%d字节：%d",(int)[lol length],(int)byte[i]);
            }
            if(1){
                [self.deviceinfodata appendData:lol];
                [[NSNotificationCenter defaultCenter] postNotificationName:DeviceInfoNotification object:self userInfo:nil];
            }
        }
        else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:SLEEPMONITOR_DATA_CHARACTERISTIC_UUID]])
        {
            // If it is, subscribe to it
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            NSString *stringFromData = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
            NSLog(@"%@", stringFromData);
            NSData *lol = characteristic.value;
            Byte *byte = (Byte *)[lol bytes];
            for(int i = 0;i<[lol length];i++)
            {
                NSLog(@"收到%d字节：%d",(int)[lol length],(int)byte[i]);
            }
        }
        else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:CALLER_REMIND_CHARACTERISTIC_UUID]])
        {
            // If it is, subscribe to it
            
            self.callerCharacteristic = characteristic;
        }
        else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:SPORT_REMIND_CHARACTERISTIC_UUID]])
        {
            // If it is, subscribe to it
            
            self.sportCharacteristic = characteristic;
        }
        else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:ALARM_REMIND_CHARACTERISTIC_UUID]])
        {
            // If it is, subscribe to it
            
            self.alarmCharacteristic = characteristic;
        }
        else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:USERINFO_CHARACTERISTIC_UUID]])
        {
            // If it is, subscribe to it
            
            self.userinfoCharacteristic = characteristic;
        }
    }
    
    //[peripheral readValueForCharacteristic:readcharacteristic];
    //NSLog(@"readcharacteristic.UUID:%@",readcharacteristic.UUID);
    // Once this is complete, we just need to wait for the data to come in.
}


/** This callback lets us know more data has arrived via notification on the characteristic
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    
    NSString *stringFromData = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    
    NSData *lol = characteristic.value;
    Byte *byte = (Byte *)[lol bytes];
    for(int i = 0;i<[lol length];i++)
    {
        NSLog(@"收到%d字节：%d",(int)[lol length],(int)byte[i]);
    }
    
    if([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]){
        [self.data setLength:0];
        [self.data appendData:lol];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:BleDataReceivedNotification object:self userInfo:nil];
    }
    else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:SLEEPMONITOR_DATA_CHARACTERISTIC_UUID]]){
        [self.sleepmonitordata setLength:0];
        [self.sleepmonitordata appendData:lol];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SleepMonitorDataNotification object:self userInfo:nil];
    }
    else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:HISTORYSTEP_DATA_CHARACTERISTIC_UUID]])
    {
        [self.historystepdata setLength:0];
        [self.historystepdata appendData:lol];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:HistoryDataNotification object:self userInfo:nil];
    }
    else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:BATTERY_CHARACTERISTIC_UUID]])
    {
        [self.batterydata setLength:0];
        [self.batterydata appendData:lol];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:BatteryDataNotification object:self userInfo:nil];
    }
    else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:DEVICE_INFO_CHARACTERISTIC_UUID]])
    {
        [self.deviceinfodata setLength:0];
        [self.deviceinfodata appendData:lol];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:DeviceInfoNotification object:self userInfo:nil];
    }
    
    
    // Have we got everything we need?
    if ([stringFromData isEqualToString:@"EOM"]) {
        
        // We have, so show the data,
//        [self.textview setText:[[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding]];
        
        // Cancel our subscription to the characteristic
        [peripheral setNotifyValue:NO forCharacteristic:characteristic];
        
        // and disconnect from the peripehral
        [self.centralManager cancelPeripheralConnection:peripheral];
    }
    
    // Otherwise, just add the data on to what we already have
    [self.data appendData:characteristic.value];
    
    // Log it
    NSLog(@"Received: %@", stringFromData);
}


/** The peripheral letting us know whether our subscribe/unsubscribe happened or not
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
    }
    
    // Exit if it's not the transfer characteristic
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
        return;
    }
    
    // Notification has started
    if (characteristic.isNotifying) {
        NSLog(@"Notification began on %@", characteristic);
    }
    
    // Notification has stopped
    else {
        // so disconnect from the peripheral
        NSLog(@"Notification stopped on %@.  Disconnecting", characteristic);
        [self.centralManager cancelPeripheralConnection:peripheral];
    }
}


/** Once the disconnection happens, we need to clean up our local copy of the peripheral
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Peripheral Disconnected");
    self.discoveredPeripheral = nil;
    
    // We're disconnected, so start scanning again
    [self scan];
}


/** Call this when things either go wrong, or you're done with the connection.
 *  This cancels any subscriptions if there are any, or straight disconnects if not.
 *  (didUpdateNotificationStateForCharacteristic will cancel the connection if a subscription is involved)
 */
- (void)cleanup
{
    // Don't do anything if we're not connected
    if (!self.discoveredPeripheral.isConnected) {
        return;
    }
    
    // See if we are subscribed to a characteristic on the peripheral
    if (self.discoveredPeripheral.services != nil) {
        for (CBService *service in self.discoveredPeripheral.services) {
            if (service.characteristics != nil) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]]) {
                        if (characteristic.isNotifying) {
                            // It is notifying, so unsubscribe
                            [self.discoveredPeripheral setNotifyValue:NO forCharacteristic:characteristic];
                            
                            // And we're done.
                            return;
                        }
                    }
                }
            }
        }
    }
    
    // If we've got this far, we're connected, but we're not subscribed, so we just disconnect
    [self.centralManager cancelPeripheralConnection:self.discoveredPeripheral];
}



-(void)setCurrentTime:(NSData *)data
{
    if(self.connectedPeripheral!=nil&&self.timeCharacteristic!=nil){
        [self.connectedPeripheral writeValue:data forCharacteristic:self.timeCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}

-(void)setCallerRemind:(NSData *)data
{
    if(self.connectedPeripheral!=nil&&self.callerCharacteristic!=nil){
        [self.connectedPeripheral writeValue:data forCharacteristic:self.callerCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}

-(void)setSportRemind:(NSData *)data
{
    if(self.connectedPeripheral!=nil&&self.sportCharacteristic!=nil){
        [self.connectedPeripheral writeValue:data forCharacteristic:self.sportCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}

-(void)setAlarmRemind:(NSData *)data
{
    if(self.connectedPeripheral!=nil&&self.alarmCharacteristic!=nil){
        [self.connectedPeripheral writeValue:data forCharacteristic:self.alarmCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}

-(void)setUserInfo:(NSData *)data
{
    if(self.connectedPeripheral!=nil&&self.userinfoCharacteristic!=nil){
        [self.connectedPeripheral writeValue:data forCharacteristic:self.userinfoCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}

@end
