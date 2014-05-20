//
//  WeightMeasureViewController.m
//  HealthABC
//
//  Created by 夏 伟 on 13-11-25.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import "WeightMeasureViewController.h"
#import "MySingleton.h"
#import "ServerConnect.h"
#import "RC_ProgressView.h"
#import "AdviceViewController.h"
#import "WMGaugeView.h"
#import "NSDate+Additions.h"

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@interface WeightMeasureViewController ()
@property (weak, nonatomic) IBOutlet UILabel *testtimeDataLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *unitSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *weightDataLabel;
@property (weak, nonatomic) IBOutlet UIImageView *btImageView;
@property (weak, nonatomic) IBOutlet UILabel *bmiDataLabel;
@property (weak, nonatomic) IBOutlet UIButton *adviceBtn;
@property (weak, nonatomic) IBOutlet WMGaugeView *myWMGaugeView;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *bmiLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *bmiResultLabel;

@end

@implementation WeightMeasureViewController
@synthesize image;
@synthesize centralManager;
@synthesize discoveredPeripheral;
@synthesize writeCharacteristic;
@synthesize notifyCharacteristic;
@synthesize targetPeripheral;
@synthesize data;


#define TRANSFER_SERVICE_UUID               @"fff0"
#define TRANSFER_NOTIFYCHARACTERISTIC_UUID  @"fff4"
#define TRANSFER_WRITECHARACTERISTIC_UUID   @"fff3"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor  = [UIColor colorWithRed:233.0/255.0 green:235.0/255.0 blue:242.0/255.0 alpha:1.0];
        self.navigationItem.title = NSLocalizedString(@"USER_WEIGHT", nil);
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:20 green:185 blue:214 alpha:1.0];
        
//        [self.navigationItem.leftBarButtonItem setImage:[UIImage imageNamed:@"ABC体重检测结果1234"]];
//        self.navigationController.navigationBar
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
    
    [_adviceBtn addTarget:self action:@selector(adviceBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self initWMGaugeViewBMI];
    
    _weightLabel.text = NSLocalizedString(@"MEASURE_TYPE_WEIGHT", nil);
    _weightUnitLabel.text = NSLocalizedString(@"WEIGHT_UNIT_KG", nil);
    [_weightDataLabel setFont:[UIFont fontWithName:@"FZNBSJW--GB1-0" size:36]];
    [_bmiDataLabel setFont:[UIFont fontWithName:@"FZNBSJW--GB1-0" size:50]];
}

-(IBAction)adviceBtnPressed:(id)sender
{
    AdviceViewController *adviceViewController = [[AdviceViewController alloc]initWithNibName:@"AdviceViewController" bundle:nil];
    [self.navigationController pushViewController:adviceViewController animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
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
    
    if([peripheral.name isEqual: @"eBody-Scale"])
    {
        if (self.discoveredPeripheral != peripheral) {
            
            // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
            self.discoveredPeripheral = peripheral;
            
            // And connect
            NSLog(@"Connecting to peripheral %@", peripheral);
            [self.centralManager connectPeripheral:peripheral options:nil];
            
            [_btImageView setImage:[UIImage imageNamed:@"ly"]];
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
            _lastWeightData = 0;
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
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_NOTIFYCHARACTERISTIC_UUID]]) {
            
            // If it is, subscribe to it
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            
            readcharacteristic = characteristic;
            notifyCharacteristic = characteristic;
            //TRANSFER_WRITECHARACTERISTIC_UUID
        }
        else if([characteristic.UUID isEqual:[CBUUID UUIDWithString:TRANSFER_WRITECHARACTERISTIC_UUID]])
        {
            Byte getData[] = {0xfd,0x29};
            NSData *testData = [[NSData alloc]initWithBytes:getData length:sizeof(getData)];
            [peripheral writeValue:testData forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
            NSLog(@"write value 0x02,0x20,0xdd,0x02,0xfd,0x29,0xd4");
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
    Byte *byte = (Byte *)[lol bytes];
    for(int i = 0;i<[lol length];i++)
    {
        NSLog(@"收到字节：%d",byte[i]);
    }
    
    if(byte[0] == 0xff)
    {
        Byte weightHigh = 0;
        if(byte[1] >= 0xc0)
        {
            weightHigh = byte[1] - 0xc0;
        }
        else if(byte[1] >= 0x80)
        {
            weightHigh = byte[1] - 0x80;
        }
        else if(byte[1]>= 0x40)
        {
            weightHigh = byte[1] - 0x40;
        }
        
        float weightdata = (float)(weightHigh * 256 + byte[2])/10;
        
        if(weightdata != _lastWeightData)
        {
            _lastWeightData = weightdata;
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Notice" message:@"Do you want save this data?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
//            [alert show];
            
            NSThread* myThread1 = [[NSThread alloc] initWithTarget:self selector:@selector(mySoundPlayer)object:nil];
            [myThread1 start];
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:[[NSString alloc] initWithFormat:@"%.1f",weightdata] forKey:@"Weight"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *datestr = [formatter stringFromDate:[NSDate date]];
            [dic setObject:datestr forKey:@"TestTime"];
            
            int height = [[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"Height"] intValue];
            float bmi = weightdata/((height/100.0f)*(height/100.0f));
            
            _bmiDataLabel.text = [[NSString alloc] initWithFormat:@"%.1f",bmi];
            NSThread* myThread2 = [[NSThread alloc] initWithTarget:self selector:@selector(uploadWeightData:)object:dic];
            [myThread2 start];
            
            NSThread* myThread3 = [[NSThread alloc] initWithTarget:self selector:@selector(getAdviceByWeightData:)object:dic];
            [myThread3 start];
            
            [_myWMGaugeView setValue:bmi];
        }
        
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *testTime = [dateFormatter stringFromDate:date];
        _testtimeDataLabel.text = testTime;
        
        if(_unitSegmentedControl.selectedSegmentIndex==0)
        {
            NSString *strData = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%.1f",weightdata]];
            _weightDataLabel.text = strData;
            int height = [[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"Height"] intValue];
            float bmi = weightdata/((height/100.0f)*(height/100.0f));
            
            _bmiDataLabel.text = [[NSString alloc] initWithFormat:@"%.1f",bmi];
        }
        else if(_unitSegmentedControl.selectedSegmentIndex==1)
        {
            weightdata = weightdata/0.45359;
            NSString *strData = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%.1f lb",weightdata]];
            
            _weightDataLabel.text = strData;
            int height = [[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"Height"] intValue];
            float bmi = weightdata/((height/100.0f)*(height/100.0f));
            
            _bmiDataLabel.text = [[NSString alloc] initWithFormat:@"%.1f",bmi];
        }
    }
    else
    {
        _lastWeightData = 0;
        
        Byte weightHigh = 0;
        if(byte[1]>=0xc0)
        {
            weightHigh = byte[1] - 0xc0;
        }
        else if(byte[1] >= 0x80)
        {
            weightHigh = byte[1] - 0x80;
        }
        else if(byte[1]>= 0x40)
        {
            weightHigh = byte[1] - 0x40;
        }
        
        float weightdata = (float)(weightHigh * 256 + byte[2])/10;
        int height = [[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"Height"] intValue];
        float bmi = weightdata/((height/100.0f)*(height/100.0f));
        [_myWMGaugeView setValue:bmi];
        
        if(_unitSegmentedControl.selectedSegmentIndex==0)
        {
            NSString *strData = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%.1f",weightdata]];
            _weightDataLabel.text = strData;
            int height = [[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"Height"] intValue];
            float bmi = weightdata/((height/100.0f)*(height/100.0f));
            
            _bmiDataLabel.text = [[NSString alloc] initWithFormat:@"%.1f",bmi];
        }
        else if(_unitSegmentedControl.selectedSegmentIndex==1)
        {
            weightdata = weightdata/0.45359;
            NSString *strData = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%.1f lb",weightdata]];
            
            _weightDataLabel.text = strData;
            int height = [[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"Height"] intValue];
            float bmi = weightdata/((height/100.0f)*(height/100.0f));
            
            _bmiDataLabel.text = [[NSString alloc] initWithFormat:@"%.1f",bmi];
        }
    }
    
    Byte getData[] = {0xfd,0x30};
    NSData *testData = [[NSData alloc]initWithBytes:getData length:sizeof(getData)];
    if(writeCharacteristic != nil){
        [self.targetPeripheral writeValue:testData forCharacteristic:writeCharacteristic type:CBCharacteristicWriteWithResponse];
        NSLog(@"write value 0x02,0x20,0xdd,0x02,0xfd,0x30,0xd4");
    }
    
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
    
}

-(void)uploadWeightData:(NSMutableDictionary *)datadic
{
    NSDictionary *resultdic = [ServerConnect uploadWeightData:datadic authkey:[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"AuthKey"]];
    NSLog(@"%@",resultdic);
    
    
    NSDictionary *dic;
    //http://www.ebelter.com/service/ehealth_uploadWeightData?authkey=NjU1YjNlNjNjMTVjNDliZWJhNzc4ZDBmNzdkMGY3YjUjMjAxNC0wMy0yNyAwOTowODo1MyMzMCN6%0AaF9DTg%3D%3D&weight=70&height=173&time=2012-02-16%2001:24:00
    NSString *testtimestr = [datadic valueForKey:@"TestTime"];
    float weight = [[datadic valueForKey:@"Weight"] floatValue];
    int height = [[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"Height"] intValue];
    
    NSString *url = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_uploadWeightData?authkey=%@&weight=%.1f&height=%d&time=%@&showresult=true&showadvice=false",
                     [[MySingleton sharedSingleton].nowuserinfo valueForKey:@"AuthKey"],
                     weight,
                     height,
                     testtimestr];
    dic = [ServerConnect getDictionaryByUrl:url];
    
    [[MySingleton sharedSingleton].nowuserinfo setObject:dic forKey:@"WeightAdviceDic"];
    
    
    [ServerConnect getAllDataFromCloud:[[NSDate date] dateByAddingDays:-90]];
}

-(void)getAdviceByWeightData:(NSMutableDictionary *)datadic
{
    NSDictionary *resultdic = [ServerConnect uploadWeightData:datadic authkey:[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"AuthKey"]];
    NSLog(@"%@",resultdic);
    
    
    NSDictionary *dic;
    //http://www.ebelter.com/service/ehealth_uploadWeightData?authkey=NjU1YjNlNjNjMTVjNDliZWJhNzc4ZDBmNzdkMGY3YjUjMjAxNC0wMy0yNyAwOTowODo1MyMzMCN6%0AaF9DTg%3D%3D&weight=70&height=173&time=2012-02-16%2001:24:00
    NSString *testtimestr = [datadic valueForKey:@"TestTime"];
    float weight = [[datadic valueForKey:@"Weight"] floatValue];
    int height = [[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"Height"] intValue];
    
    NSString *url = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_uploadWeightData?authkey=%@&weight=%.1f&height=%d&time=%@&showresult=true&showadvice=true",
                     [[MySingleton sharedSingleton].nowuserinfo valueForKey:@"AuthKey"],
                     weight,
                     height,
                     testtimestr];
    dic = [ServerConnect getDictionaryByUrl:url];
    
//    NSString *resultstr = [dic valueForKey:@"result"];
    NSString *dicadvice = [dic valueForKey:@"advice"];
//    NSString *foodSuggestion = [dicadvice valueForKey:@"foodSuggestion"];
//    NSString *sportSuggestion = [dicadvice valueForKey:@"sportSuggestion"];
//    NSString *doctorSuggestion = [dicadvice valueForKey:@"doctorSuggestion"];
    NSString *commSuggestion = [dicadvice valueForKey:@"commSuggestion"];
    NSString *result = [dic valueForKey:@"result"];
    
    _tipsDataLabel.text = [[NSString alloc]initWithFormat:@"    %@",commSuggestion];
    if(result != nil){
        _bmiResultLabel.text = [[NSString alloc]initWithFormat:@"%@",result];
    }
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
    _myWMGaugeView.rangeValues = @[ @18,                  @25,                @28,               @32,               @40              ];
    _myWMGaugeView.rangeColors = @[ RGB(232, 111, 33),    RGB(27, 202, 33),   RGB(113, 183, 252),  RGB(231, 32, 43),  RGB(170, 32, 43)    ];
//    _myWMGaugeView.rangeLabels = @[ @"过轻",               @"正常",            @"过重",            @"肥胖",            @"重度肥胖"        ];
    _myWMGaugeView.rangeLabels = @[ NSLocalizedString(@"BMI_LEVEL_Underweight", nil),               NSLocalizedString(@"BMI_LEVEL_Normal", nil),            NSLocalizedString(@"BMI_LEVEL_Overweight", nil),            NSLocalizedString(@"BMI_LEVEL_Obesity", nil),            NSLocalizedString(@"BMI_LEVEL_Severe obesity", nil)        ];
    _myWMGaugeView.unitOfMeasurement = @"BMI";
    _myWMGaugeView.showUnitOfMeasurement = YES;
    [_myWMGaugeView setValue:0];
}

@end
