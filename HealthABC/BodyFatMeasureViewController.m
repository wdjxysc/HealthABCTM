//
//  BodyFatMeasureViewController.m
//  HealthABC
//
//  Created by 夏 伟 on 13-11-27.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import "BodyFatMeasureViewController.h"
#import "ServerConnect.h"
#import "WMGaugeView.h"
#import "NSDate+Additions.h"

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@interface BodyFatMeasureViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *btImageView;
@property (weak, nonatomic) IBOutlet WMGaugeView *myWMGaugeView;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *fatLabel;
@property (weak, nonatomic) IBOutlet UILabel *muscleLabel;
@property (weak, nonatomic) IBOutlet UILabel *waterLabel;
@property (weak, nonatomic) IBOutlet UILabel *boneLabel;
@property (weak, nonatomic) IBOutlet UILabel *boneUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *bmrLabel;
@property (weak, nonatomic) IBOutlet UILabel *bmrUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *visFatLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *bmiResultLabel;

@end

@implementation BodyFatMeasureViewController
@synthesize image;
@synthesize button;
@synthesize centralManager;
@synthesize discoveredPeripheral;
@synthesize writeCharacteristic;
@synthesize notifyCharacteristic;
@synthesize targetPeripheral;
@synthesize data;

@synthesize lastwater;
@synthesize lastweight;
@synthesize lastbmi;
@synthesize lastbmr;
@synthesize lastbone;
@synthesize lastfat;
@synthesize lastheight;
@synthesize lastmuscle;
@synthesize lastvisfat;

#define TRANSFER_SERVICE_UUID               @"fff0"
#define TRANSFER_NOTIFYCHARACTERISTIC_UUID  @"fff4"
#define TRANSFER_WRITECHARACTERISTIC_UUID   @"fff3"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor  = [UIColor colorWithRed:233.0/255.0 green:235.0/255.0 blue:242.0/255.0 alpha:1.0];
        self.navigationItem.title = NSLocalizedString(@"MEASURE_TYPE_BODYFAT", nil);
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
    [self initWMGaugeViewBMI];
    
    _weightLabel.text = NSLocalizedString(@"USER_WEIGHT", nil);
    _weightUnitLabel.text = NSLocalizedString(@"WEIGHT_UNIT_KG", nil);
    
    _fatLabel.text = NSLocalizedString(@"USER_FAT", nil);
    _muscleLabel.text = NSLocalizedString(@"USER_MUSCLE", nil);
    _waterLabel.text = NSLocalizedString(@"USER_WATER", nil);
    _boneLabel.text = NSLocalizedString(@"USER_BONE", nil);
    _boneUnitLabel.text = NSLocalizedString(@"WEIGHT_UNIT_KG", nil);
    _bmrLabel.text = NSLocalizedString(@"USER_BMR", nil);
    _bmrUnitLabel.text = NSLocalizedString(@"KCAL", nil);
    _visFatLabel.text = NSLocalizedString(@"USER_VISFAT", nil);
    [fatDataLabel setFont:[UIFont fontWithName:@"FZNBSJW--GB1-0" size:24]];
    [muscleDataLabel setFont:[UIFont fontWithName:@"FZNBSJW--GB1-0" size:24]];
    [waterDataLabel setFont:[UIFont fontWithName:@"FZNBSJW--GB1-0" size:24]];
    [boneDataLabel setFont:[UIFont fontWithName:@"FZNBSJW--GB1-0" size:24]];
    [bmrDataLabel setFont:[UIFont fontWithName:@"FZNBSJW--GB1-0" size:24]];
    [weightDataLabel setFont:[UIFont fontWithName:@"FZNBSJW--GB1-0" size:24]];
    [bmiDataLabel setFont:[UIFont fontWithName:@"FZNBSJW--GB1-0" size:50]];
    [visceralfatDataLabel setFont:[UIFont fontWithName:@"FZNBSJW--GB1-0" size:24]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)beginMeasure:(id)sender
{
    self.image.hidden = NO;
    self.navigationItem.title = NSLocalizedString(@"等待体成分测量...", nil);
    
    // Start up the CBCentralManager
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
    
//    self.image.hidden = NO;
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
    if([peripheral.name isEqual:@"eBody-Fat-Scale"]||[peripheral.name isEqualToString:@"eBody-Fat-Analyzer"])
    {
        if (self.discoveredPeripheral != peripheral) {
            
            // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
            self.discoveredPeripheral = peripheral;
            
            // And connect
            NSLog(@"Connecting to peripheral %@", peripheral);
            [self.centralManager connectPeripheral:peripheral options:nil];
            
            //设置图片消失
            image.hidden = true;
            
            _btImageView.image = [UIImage imageNamed:@"ly"];
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
    
//    self.bluetoothImageView.image = [UIImage imageNamed:@"ly"];
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
            NSString *sportlvlstr = [[MySingleton sharedSingleton].nowuserinfo objectForKey:@"Profession"];
            if([sportlvlstr isEqualToString:@""]||sportlvlstr == nil)
            {
                sportlvl = 0;
            }
            else
            {
                //服务网是0，1，2等级  设备是1，2，3等级
                sportlvl = [sportlvlstr intValue] + 1;
            }
            
            NSString *sexstr = [[MySingleton sharedSingleton].nowuserinfo objectForKey:@"Gender"];
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
            NSLog(@"height : %d",height);
            
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
    
    if([lol length]== 3)
    {
        Byte weightHigh = revdata[1] & 0x3f;
        float weightdata = (float)(weightHigh * 256 + revdata[2])/10.0;
        NSString *strData = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%.1f",weightdata]];
        weightDataLabel.text = strData;
    }
    
    if(revdata[0] == 0xff && [lol length]==20)
    {
        Byte weightHigh = revdata[1] & 0x3f;
        float weightdata = (float)(weightHigh * 256 + revdata[2])/10.0;
        double heightdata = revdata[10]/100.0;
        double fatdata = ((revdata[12]>>4) * 256 + revdata[11])/10.0;
        double waterdata = ((revdata[12] & 0x0f) * 256 + revdata[13])/10.0;
        double muscledata = (revdata[14]*256 + revdata[15])/10.0;
        double bonedata = revdata[16]/10.0;
        int visfatdata = revdata[17];
        int bmrdata = revdata[18]*256 + revdata[19];
        double bmidata = weightdata /(heightdata*heightdata);
        
        fatDataLabel.text = [[NSString alloc]initWithFormat:@"%.1f",fatdata];
        waterDataLabel.text = [[NSString alloc]initWithFormat:@"%.1f",waterdata];
        muscleDataLabel.text = [[NSString alloc]initWithFormat:@"%.1f",muscledata];
        boneDataLabel.text = [[NSString alloc]initWithFormat:@"%.1f",bonedata];
        visceralfatDataLabel.text = [[NSString alloc]initWithFormat:@"%d",visfatdata];
        bmrDataLabel.text = [[NSString alloc]initWithFormat:@"%d",bmrdata];
        bmiDataLabel.text = [[NSString alloc]initWithFormat:@"%.1f",bmidata];
        
        
//        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        NSString *testTime = [dateFormatter stringFromDate:date];
        
        NSString *strData = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%.1f",weightdata]];
        weightDataLabel.text = strData;
//        if(unitSegmentedControl.selectedSegmentIndex==0)
//        {
//            NSString *strData = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%.1f kg",weightdata]];
//            weightDataLabel.text = strData;
//        }
//        else if(unitSegmentedControl.selectedSegmentIndex==0)
//        {
//            weightdata = weightdata/0.45359;
//            NSString *strData = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%.1f lb",weightdata]];
//            
//            weightDataLabel.text = strData;
//        }
        if (!(weightdata == lastweight && fatdata == lastfat && waterdata ==  lastwater && bonedata == lastbone && bmidata == lastbmi && bmrdata == lastbmr && heightdata == lastheight && muscledata == lastmuscle && visfatdata == lastvisfat)) {
            
            lastweight = weightdata;
            lastfat = fatdata;
            lastwater = waterdata;
            lastbone = bonedata;
            lastbmi = bmidata;
            lastbmr = bmrdata;
            lastheight = heightdata;
            lastmuscle = muscledata;
            lastvisfat = visfatdata;
            
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Notice" message:@"Do you want save this data?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
//            [alert show];
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:[[NSString alloc] initWithFormat:@"%.1f",weightdata] forKey:@"Weight"];
            [dic setObject:[[NSString alloc] initWithFormat:@"%.1f",fatdata] forKey:@"Fat"];
            [dic setObject:[[NSString alloc] initWithFormat:@"%.1f",waterdata] forKey:@"Water"];
            [dic setObject:[[NSString alloc] initWithFormat:@"%.1f",bonedata] forKey:@"Bone"];
            [dic setObject:[[NSString alloc] initWithFormat:@"%.1f",bmidata] forKey:@"BMI"];
            [dic setObject:[[NSString alloc] initWithFormat:@"%d",bmrdata] forKey:@"BMR"];
            [dic setObject:[[NSString alloc] initWithFormat:@"%.1f",muscledata] forKey:@"Muscle"];
            [dic setObject:[[NSString alloc] initWithFormat:@"%d",visfatdata] forKey:@"VisceralFat"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *datestr = [formatter stringFromDate:[NSDate date]];
            [dic setObject:datestr forKey:@"TestTime"];
            
            //上传数据
            NSThread* myThread2 = [[NSThread alloc] initWithTarget:self selector:@selector(uploadBodyFatData:)object:dic];
            [myThread2 start];
            
            //获取建议
            NSThread* myThread3 = [[NSThread alloc] initWithTarget:self selector:@selector(getAdviceByBodyFatData:)object:dic];
            [myThread3 start];
            
            //播放音效
            NSThread* myThread1 = [[NSThread alloc] initWithTarget:self selector:@selector(mySoundPlayer)object:nil];
            [myThread1 start];
            
            [_myWMGaugeView setValue:bmidata];
        }
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
    
    _btImageView.image = [UIImage imageNamed:@"ly0"];
    
//    self.bluetoothImageView.image = [UIImage imageNamed:@"ly0"];
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
        lastweight = 0;
        lastwater = 0;
        lastmuscle = 0;
        lastfat = 0;
    }
}

-(void)uploadBodyFatData:(NSMutableDictionary *)datadic
{
    NSDictionary *resultdic = [ServerConnect uploadBodyFatData:datadic authkey:[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"AuthKey"]];
    NSLog(@"%@",resultdic);
    
    [ServerConnect getAllDataFromCloud:[[NSDate date] dateByAddingDays:-90]];
}

-(void)getAdviceByBodyFatData:(NSMutableDictionary *)datadic
{
    NSDictionary *dicadvice;
    
    NSString *urlgetadvice = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_uploadBodyCompositionData?authkey=%@&muscle=%.1f&adiposerate=%.1f&Metabolism=%d&visceralfat=%.1f&moisture=%.1f&bone=%.1f&thermal=%d&impedance=%d&bmi=%.1f&time=%@&showtresult=true&showadvice=true&shareid=123",
                              [[MySingleton sharedSingleton].nowuserinfo valueForKey:@"AuthKey"],
                              [[datadic valueForKey:@"Muscle"] floatValue],
                              [[datadic valueForKey:@"Fat"] floatValue],
                              [[datadic valueForKey:@"BMR"] intValue],
                              [[datadic valueForKey:@"VisceralFat"] floatValue],
                              [[datadic valueForKey:@"Water"] floatValue],
                              [[datadic valueForKey:@"Bone"] floatValue],
                              [[datadic valueForKey:@"BMR"] intValue],
                              70,
                              [[datadic valueForKey:@"BMI"] floatValue],
                              [datadic valueForKey:@"TestTime"]];
    
    
    dicadvice = [ServerConnect getDictionaryByUrl:urlgetadvice];
    NSLog(@"%@",dicadvice);
    NSDictionary *dicresult = [dicadvice valueForKey:@"result"];
    NSDictionary *dicbmi = [dicresult valueForKey:@"bmi"];
    NSDictionary *dicbmiadvice = [dicbmi valueForKey:@"advice"];
//    NSString *foodSuggestion = [dicbmiadvice valueForKey:@"foodSuggestion"];
//    NSString *sportSuggestion = [dicbmiadvice valueForKey:@"sportSuggestion"];
    NSString *doctorSuggestion = [dicbmiadvice valueForKey:@"doctorSuggestion"];
    NSString *commSuggestion = [dicbmiadvice valueForKey:@"CommSuggestion"];
    
    
    _tipsDataLabel.text = [[NSString alloc]initWithFormat:@"    %@%@",doctorSuggestion,commSuggestion];
    //_bmiResultLabel.text = [[NSString alloc]initWithFormat:@"%@",dicresult];
}


-(void)mySoundPlayer
{
    WQPlaySound *sound = sound = [[WQPlaySound alloc]initForPlayingSoundEffectWith:NSLocalizedString(@"NOVA_GOTIT", nil)];
    
    [sound play];
    sleep(2);
    
}

-(void)initWMGaugeViewBMI
{
    [_myWMGaugeView setBackgroundColor:[UIColor clearColor]];
    _myWMGaugeView.showInnerBackground = NO;
    _myWMGaugeView.minValue = 10;
    _myWMGaugeView.maxValue = 40;
    _myWMGaugeView.scaleSubdivisions = 5;
    _myWMGaugeView.scaleDivisions = 6;
    _myWMGaugeView.showRangeLabels = YES;
    _myWMGaugeView.rangeValues = @[ @18,                  @25,                @28,               @32,             @40 ];
    _myWMGaugeView.rangeColors = @[ RGB(113, 183, 252),    RGB(27, 202, 33),   RGB(200, 111, 70), RGB(215, 70, 70),RGB(231, 32, 140)    ];
    _myWMGaugeView.rangeLabels = @[ @"过轻",               @"正常",            @"过重",            @"肥胖",         @"重度肥胖"        ];
    _myWMGaugeView.rangeLabels = @[ NSLocalizedString(@"BMI_LEVEL_Underweight", nil),               NSLocalizedString(@"BMI_LEVEL_Normal", nil),            NSLocalizedString(@"BMI_LEVEL_Overweight", nil),            NSLocalizedString(@"BMI_LEVEL_Obesity", nil),            NSLocalizedString(@"BMI_LEVEL_Severe obesity", nil)        ];
    _myWMGaugeView.unitOfMeasurement = @"BMI";
    _myWMGaugeView.showUnitOfMeasurement = YES;
    [_myWMGaugeView setValue:0];
}

@end
