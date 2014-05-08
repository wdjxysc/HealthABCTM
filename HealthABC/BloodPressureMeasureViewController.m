//
//  BloodPressureMeasureViewController.m
//  HealthABC
//
//  Created by 夏 伟 on 13-11-25.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import "BloodPressureMeasureViewController.h"
#import "RC_ProgressView.h"
#import "ServerConnect.h"
#import "WMGaugeView.h"
#import "NSDate+Additions.h"

@interface BloodPressureMeasureViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *btImage;
@property (weak, nonatomic) IBOutlet WMGaugeView *mySYSWMGaugeView;
@property (weak, nonatomic) IBOutlet WMGaugeView *myDIAWMGaugeView;
@property (weak, nonatomic) IBOutlet WMGaugeView *myPulseWMGaugeView;
@property (weak, nonatomic) IBOutlet UILabel *sysLabel;
@property (weak, nonatomic) IBOutlet UILabel *sysUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *diaLabel;
@property (weak, nonatomic) IBOutlet UILabel *diaUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *pulseLabel;
@property (weak, nonatomic) IBOutlet UILabel *pulseUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsDataLabel;


@end

@implementation BloodPressureMeasureViewController
@synthesize image;
@synthesize centralManager;
@synthesize discoveredPeripheral;
@synthesize writeCharacteristic;
@synthesize notifyCharacteristic;
@synthesize targetPeripheral;
@synthesize data;

@synthesize lastdia;
@synthesize lastpulse;
@synthesize lastsys;

#define TRANSFER_SERVICE_UUID               @"fff0"
#define TRANSFER_NOTIFYCHARACTERISTIC_UUID  @"fff4"
#define TRANSFER_WRITECHARACTERISTIC_UUID   @"fff3"
#define DEVICE_NAME                         @"eBlood-Pressure"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor  = [UIColor colorWithRed:233.0/255.0 green:235.0/255.0 blue:242.0/255.0 alpha:1.0];
        self.navigationItem.title = NSLocalizedString(@"MEASURE_TYPE_BLOODPRESSURE", nil);
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:20 green:185 blue:214 alpha:1.0];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initMyView];
}

-(void)initMyView
{
    [self initWMGaugeViewDIA];
    [self initWMGaugeViewPulse];
    [self initWMGaugeViewSYS];
    
    _sysLabel.text = NSLocalizedString(@"USER_SYS", nil);
    _sysUnitLabel.text = NSLocalizedString(@"PRESS_UNIT_MMHG", nil);
    _diaLabel.text = NSLocalizedString(@"USER_DIA", nil);
    _diaUnitLabel.text = NSLocalizedString(@"PRESS_UNIT_MMHG", nil);
    _pulseLabel.text = NSLocalizedString(@"USER_PULSE", nil);
    _pulseUnitLabel.text = NSLocalizedString(@"PULSE_UNIT_BPM", nil);
    
    [sysDataLabel setFont:[UIFont fontWithName:@"FZNBSJW--GB1-0" size:36]];
    [diaDataLabel setFont:[UIFont fontWithName:@"FZNBSJW--GB1-0" size:36]];
    [pulseDataLabel setFont:[UIFont fontWithName:@"FZNBSJW--GB1-0" size:36]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)beginMeasure:(id)sender
{
    self.image.hidden = NO;
    self.navigationItem.title = NSLocalizedString(@"正在进行血压测量...", nil);
    
    // Start up the CBCentralManagenig9r
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    // And somewhere to store the incoming data
    self.data = [[NSMutableData alloc] init];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.centralManager stopScan];
    [self cleanup];
}

-(void)viewWillAppear:(BOOL)animated
{
    // Start up the CBCentralManager
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    // And somewhere to store the incoming data
    self.data = [[NSMutableData alloc] init];
    
    self.image.hidden = NO;
}


///corebluetooth

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
        NSLog(@"%@",peripheral.services[i]);
    }
    
    
    // Ok, it's in range - have we already seen it?
    if([peripheral.name isEqual: @"eBlood-Pressure"])
    {
        if (self.discoveredPeripheral != peripheral) {
            
            // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
            self.discoveredPeripheral = peripheral;
            
            // And connect
            NSLog(@"Connecting to  %@", peripheral);
            [self.centralManager connectPeripheral:peripheral options:nil];
            
            //设置图片消失
            image.hidden = true;
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
    
    _btImage.image = [UIImage imageNamed:@"ly"];
    // Stop scanning
    [self.centralManager stopScan];
    NSLog(@"Scanning stopped");
    
    // Clear the data that we may already have
    [self.data setLength:0];
    
    // Make sure we get the discovery callbacks
    peripheral.delegate = self;
    
    // Search only for services that match our UUID
    [peripheral discoverServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]]];
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
            [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:TRANSFER_NOTIFYCHARACTERISTIC_UUID]] forService:service];
            [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:TRANSFER_WRITECHARACTERISTIC_UUID]] forService:service];
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
        //        [self cleanup];
        //        return;
    }
    
    CBCharacteristic *readcharacteristic;
    
    // Again, we loop through the array, just in case.
    for (CBCharacteristic *characteristic in service.characteristics) {
        
        NSLog(@"特征:%@",characteristic.UUID);
        // And check if it's the right one
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_NOTIFYCHARACTERISTIC_UUID]]) {
            
            // If it is, subscribe to it
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            
            readcharacteristic = characteristic;
            notifyCharacteristic = characteristic;
            //TRANSFER_WRITECHARACTERISTIC_UUID
        }
        else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_WRITECHARACTERISTIC_UUID]])
        {
            Byte weighthigh,weightlow,sportlvl,genderage,height;
            NSString *weightstr = [[MySingleton sharedSingleton].nowuserinfo objectForKey:@"Weight"];
            double weight = [weightstr doubleValue];
            weighthigh = ((int)(weight*10))/256;
            weightlow = ((int)(weight*10))%256;
            weighthigh += 64;
            NSString *sportlvlstr = [[MySingleton sharedSingleton].nowuserinfo objectForKey:@"Profesion"];
            if([sportlvlstr isEqualToString:@""]||sportlvlstr == nil)
            {
                sportlvl = 0;
            }
            else
            {
                //服务网是0，1，2等级  设备是1，2，3等级
                sportlvl = [sportlvlstr intValue] + 1;
            }
            
            NSString *sexstr = [[MySingleton sharedSingleton].nowuserinfo objectForKey:@"Sex"];
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
            [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,这里可以设置成自己需要的格式
            //            NSDate *birthdate =[dateFormat dateFromString:[[NSString alloc]initWithFormat:@"%@",[[MySingleton sharedSingleton].nowuserinfo objectForKey:@"Brithday"]]];
            //            Byte age = [self GetAgeByBrithday:brithdate];
            NSString *agestr = [[MySingleton sharedSingleton].nowuserinfo objectForKey:@"Age"];
            Byte age = [agestr intValue];
            
            
            //性别代码 服务网 0男，1女  设备0女，1男
            if([sexstr isEqualToString:@"0"])
            {
                genderage =  age + 0x80;
            }
            else
            {
                genderage = age;
            }
            
            height = [[[MySingleton sharedSingleton].nowuserinfo objectForKey:@"Height"] intValue];
            
            sleep(3);
            Byte setUserInfo[] = {0xfd,0x53,weighthigh,weightlow,sportlvl,genderage,height};
            NSData *testData = [[NSData alloc]initWithBytes:setUserInfo length:sizeof(setUserInfo)];
            [peripheral writeValue:testData forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
            NSLog(@"write value %@ ---- 0x02,0x20,0xdd,0x02,0xfd,0x29,0xd4",[CBUUID UUIDWithString:TRANSFER_NOTIFYCHARACTERISTIC_UUID]);
            writeCharacteristic = characteristic;
            //            [peripheral readValueForCharacteristic:characteristic];
            //            NSData *revData = characteristic.value;
            //            Byte *revbyte = (Byte *)[revData bytes];
            //            int size = sizeof(revbyte);
            //            NSLog(@"revData Length:%d",size);
            //            for(int i = 0; i<sizeof(revbyte);i++)
            //            {
            //                NSLog(@"revdata:%d",revbyte[i]);
            //            }
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
    
    self.targetPeripheral = peripheral;
    
    NSString *stringFromData = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    
    NSData *lol = characteristic.value;
    Byte *revdata = (Byte *)[lol bytes];
    for(int i = 0;i<[lol length];i++)
    {
        NSLog(@"收到字节：%d",revdata[i]);
    }
    
    //收到测量中数据
    if([lol length]==2)
    {
        sysDataLabel.text = [[NSString alloc] initWithFormat:@"%d",revdata[1]];
        diaDataLabel.text = @"0";
        pulseDataLabel.text = @"0";
        
        [_mySYSWMGaugeView setValue:revdata[1]];
        [_myDIAWMGaugeView setValue:0];
        [_myPulseWMGaugeView setValue:0];
        
    }
    
    //收到确定数据
    if([lol length]==12)
    {
        int sysdata = revdata[1]*256 +revdata[2];
        int diadata = revdata[3]*256 + revdata[4];
        int pulsedata = revdata[7]*256+ revdata[8];
        
        sysDataLabel.text = [[NSString alloc]initWithFormat:@"%d",sysdata];
        diaDataLabel.text = [[NSString alloc]initWithFormat:@"%d",diadata];
        pulseDataLabel.text = [[NSString alloc]initWithFormat:@"%d",pulsedata];
        
        
//        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        NSString *testTime = [dateFormatter stringFromDate:date];
        
        
        //if (!(sysdata == lastsys && diadata == lastdia && pulsedata ==  lastpulse )) {
            
            lastsys = sysdata;
            lastdia = diadata;
            lastpulse = pulsedata;
            
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Notice" message:@"Do you want save this data?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
//            [alert show];
        
        
            NSThread* myThread1 = [[NSThread alloc] initWithTarget:self selector:@selector(mySoundPlayer)object:nil];
            [myThread1 start];
        
        
        //}
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:[[NSString alloc] initWithFormat:@"%d",sysdata] forKey:@"SYS"];
        [dic setObject:[[NSString alloc] initWithFormat:@"%d",diadata] forKey:@"DIA"];
        [dic setObject:[[NSString alloc] initWithFormat:@"%d",pulsedata] forKey:@"Pulse"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *datestr = [formatter stringFromDate:[NSDate date]];
        [dic setObject:datestr forKey:@"TestTime"];
        
        NSThread* myThread2 = [[NSThread alloc] initWithTarget:self selector:@selector(uploadBloodPressureData:)object:dic];
        [myThread2 start];
        
        NSThread* myThread3 = [[NSThread alloc] initWithTarget:self selector:@selector(getAdviceByBloodPressureData:)object:dic];
        [myThread3 start];
        
        [_mySYSWMGaugeView setValue:sysdata];
        [_myDIAWMGaugeView setValue:diadata];
        [_myPulseWMGaugeView setValue:pulsedata];
    }
    
//    Byte getData[] = {0xfd,0x31};
//    NSData *testData = [[NSData alloc]initWithBytes:getData length:sizeof(getData)];
    //    [self.targetPeripheral writeValue:testData forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithResponse];
    //    [self.targetPeripheral writeValue:testData forDescriptor:nil];
    NSLog(@"write value 0x02,0x20,0xdd,0x02,0xfd,0x30,0xd4");
    
    NSThread* myThread = [[NSThread alloc] initWithTarget:self selector:@selector(myThreadMainMethod)object:nil];
    [myThread start];
    
    
    
    // Have we got everything we need?
    if ([stringFromData isEqualToString:@"EOM"]) {
        
        // We have, so show the data,
        //[self.textview setText:[[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding]];
        NSLog(@"GetDataValue : %@",[[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding]);
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
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_NOTIFYCHARACTERISTIC_UUID]]) {
        return;
    }
    
    // Notification has started
    if (characteristic.isNotifying) {
        NSLog(@"Notification began on %@", characteristic);
        [peripheral readValueForCharacteristic:characteristic];
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
    
    _btImage.image = [UIImage imageNamed:@"ly0"];
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
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_NOTIFYCHARACTERISTIC_UUID]]) {
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

-(void)myThreadMainMethod
{
    //    weightLabel.text = @"adsdasd";
    for(int i = 0;i<1;i++){
        sleep(2);
//        Byte getData[] = {0xfd,0x29};
//        NSData *testData = [[NSData alloc]initWithBytes:getData length:sizeof(getData)];
        //        [self.targetPeripheral writeValue:testData forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
        NSLog(@"write value 0x02,0x20,0xdd,0x02,0xfd,0x29,0xd4");
        
        sleep(5);
        lastsys = 0;
        lastdia = 0;
        lastpulse = 0;
    }
}

-(void)uploadBloodPressureData:(NSMutableDictionary *)datadic
{
    NSDictionary *resultdic = [ServerConnect uploadBloodPressureData:datadic authkey:[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"AuthKey"]];
    NSLog(@"%@",resultdic);
    
    [ServerConnect getAllDataFromCloud:[[NSDate date] dateByAddingDays:-90]];
}

-(void)getAdviceByBloodPressureData:(NSMutableDictionary *)datadic
{
    NSDictionary *dicadvice;
    //http://www.ebelter.com/service/ehealth_uploadBloodPressureData?authkey=NjU1YjNlNjNjMTVjNDliZWJhNzc4ZDBmNzdkMGY3YjUjMjAxNC0wMy0yNyAwOTowODo1MyMzMCN6%0AaF9DTg%3D%3D&systolic=110&diastolic=80&pulse=100&time=2012-02-16%2001:57:00&shareid=123&showresult=true&showadvice=true
    NSString *testtimestr = [datadic valueForKey:@"TestTime"];
    int sys = [[datadic valueForKey:@"SYS"] intValue];
    int dia = [[datadic valueForKey:@"DIA"] intValue];
    int pulse = [[datadic valueForKey:@"Pulse"] intValue];
    
    NSString *urladvice = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_uploadBloodPressureData?authkey=%@&systolic=%d&diastolic=%d&pulse=%d&time=%@&shareid=123&showresult=true&showadvice=true",
                           [[MySingleton sharedSingleton].nowuserinfo valueForKey:@"AuthKey"],
                           sys,
                           dia,
                           pulse,
                           testtimestr];
    dicadvice = [ServerConnect getDictionaryByUrl:urladvice];
    
    NSString *resultstr = [dicadvice valueForKey:@"result"];
    NSDictionary *dicadvice1 = [dicadvice valueForKey:@"advice"];
//    NSString *foodSuggestion = [dicadvice valueForKey:@"foodSuggestion"];
//    NSString *sportSuggestion = [dicadvice valueForKey:@"sportSuggestion"];
//    NSString *doctorSuggestion = [dicadvice valueForKey:@"doctorSuggestion"];
    NSString *commSuggestion = [dicadvice1 valueForKey:@"commSuggestion"];
    _tipsDataLabel.text = [[NSString alloc]initWithFormat:@"    %@",commSuggestion];
    NSLog(@"%@",resultstr);
}

-(void)mySoundPlayer
{
    WQPlaySound *sound = sound = [[WQPlaySound alloc]initForPlayingSoundEffectWith:NSLocalizedString(@"NOVA_GOTIT", nil)];
    
    [sound play];
    sleep(2);
    
}


-(void)initWMGaugeViewSYS
{
    [_mySYSWMGaugeView setBackgroundColor:[UIColor clearColor]];
    _mySYSWMGaugeView.showInnerBackground = NO;
    _mySYSWMGaugeView.scaleSubdivisions = 5;
    _mySYSWMGaugeView.scaleDivisions = 8;
    _mySYSWMGaugeView.minValue = 0.0;
    _mySYSWMGaugeView.maxValue = 200.0;
    _mySYSWMGaugeView.showRangeLabels = YES;
    _mySYSWMGaugeView.rangeValues = @[ @90,                  @140,                @200           ];
    _mySYSWMGaugeView.rangeColors = @[ RGB(113, 183, 252),    RGB(27, 202, 33),    RGB(232, 111, 33)    ];
//    _mySYSWMGaugeView.rangeLabels = @[ @"低压",               @"正常",             @"高压"           ];
    _mySYSWMGaugeView.rangeLabels = @[ NSLocalizedString(@"BLOODPRESS_LEVEL_Low", nil),               NSLocalizedString(@"BLOODPRESS_LEVEL_Normal", nil),             NSLocalizedString(@"BLOODPRESS_LEVEL_High", nil)           ];
    _mySYSWMGaugeView.unitOfMeasurement = NSLocalizedString(@"USER_SYS", nil);
    _mySYSWMGaugeView.showUnitOfMeasurement = YES;
    [_mySYSWMGaugeView setValue:0];
}

-(void)initWMGaugeViewDIA
{
    [_myDIAWMGaugeView setBackgroundColor:[UIColor clearColor]];
    _myDIAWMGaugeView.showInnerBackground = NO;
    _myDIAWMGaugeView.scaleSubdivisions = 5;
    _myDIAWMGaugeView.scaleDivisions = 8;
    _myDIAWMGaugeView.minValue = 0.0;
    _myDIAWMGaugeView.maxValue = 200.0;
    _myDIAWMGaugeView.showRangeLabels = YES;
    _myDIAWMGaugeView.rangeValues = @[ @60,                  @90,                 @200           ];
    _myDIAWMGaugeView.rangeColors = @[ RGB(113, 183, 252),    RGB(27, 202, 33),    RGB(232, 111, 33)    ];
    _myDIAWMGaugeView.rangeLabels = @[ @"低压",               @"正常",             @"高压"           ];
    _myDIAWMGaugeView.rangeLabels = @[ NSLocalizedString(@"BLOODPRESS_LEVEL_Low", nil),               NSLocalizedString(@"BLOODPRESS_LEVEL_Normal", nil),             NSLocalizedString(@"BLOODPRESS_LEVEL_High", nil)           ];
    _myDIAWMGaugeView.unitOfMeasurement = NSLocalizedString(@"USER_DIA", nil);
    _myDIAWMGaugeView.showUnitOfMeasurement = YES;
    [_myDIAWMGaugeView setValue:0];
}

-(void)initWMGaugeViewPulse
{
    [_myPulseWMGaugeView setBackgroundColor:[UIColor clearColor]];
    _myPulseWMGaugeView.showInnerBackground = NO;
    _myPulseWMGaugeView.scaleSubdivisions = 5;
    _myPulseWMGaugeView.scaleDivisions = 8;
    _myPulseWMGaugeView.minValue = 0.0;
    _myPulseWMGaugeView.maxValue = 160.0;
    _myPulseWMGaugeView.showRangeLabels = YES;
    _myPulseWMGaugeView.rangeValues = @[ @60,                  @100,                @160           ];
    _myPulseWMGaugeView.rangeColors = @[ RGB(113, 183, 252),    RGB(27, 202, 33),    RGB(232, 111, 33)    ];
    _myPulseWMGaugeView.rangeLabels = @[ @"心率过缓",               @"正常",             @"心率过速"           ];
    _myPulseWMGaugeView.rangeLabels = @[ NSLocalizedString(@"PULSE_LEVEL_Slow", nil),               NSLocalizedString(@"PULSE_LEVEL_Normal", nil),             NSLocalizedString(@"PULSE_LEVEL_Fast", nil)           ];
    _myPulseWMGaugeView.unitOfMeasurement = NSLocalizedString(@"USER_PULSE", nil);
    _myPulseWMGaugeView.showUnitOfMeasurement = YES;
    [_myPulseWMGaugeView setValue:0];
}


@end