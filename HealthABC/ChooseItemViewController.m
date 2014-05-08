//
//  ChooseItemViewController.m
//  HealthABC
//
//  Created by 夏 伟 on 13-11-22.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import "ChooseItemViewController.h"
#import "DEMONavigationController.h"
#import "WeightMeasureViewController.h"
#import "BodyFatMeasureViewController.h"
#import "BloodPressureMeasureViewController.h"
#import "TemperatureViewController.h"
#import "MySingleton.h"
#import "ServerConnect.h"


@interface ChooseItemViewController ()
@property (weak, nonatomic) IBOutlet UILabel *temperatureDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureResultLabel;
@property (weak, nonatomic) IBOutlet UILabel *recentWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *recentBloodPressLabel;
@property (weak, nonatomic) IBOutlet UILabel *bloodPressUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *recentFatLabel;
@property (weak, nonatomic) IBOutlet UILabel *recentTemperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureUnitLabel;

@end

@implementation ChooseItemViewController
@synthesize weightDataLabel;
@synthesize bloodPressDataLabel;
@synthesize bodyFatDataLabel;
@synthesize userNameLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    self.title = @"健康ABC";
    self.title = NSLocalizedString(@"HealthABC", nil);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"MENU", nil)
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(DEMONavigationController *)self.navigationController
                                                                            action:@selector(showMenu)];
    
    //开始线程获取用户最近数据
    
    NSThread* myThread1 = [[NSThread alloc] initWithTarget:self selector:@selector(getUserLastData)object:nil];
    [myThread1 start];
    
    
    NSLog(@"当前用户性别为:%@",[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"Gender"]);
    
    if([[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"Gender"] isEqualToString:@"0"]){
        [genderButton setImage:[UIImage imageNamed:@"男"] forState:UIControlStateNormal];
    }
    else if([[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"Gender"] isEqualToString:@"1"]){
        [genderButton setImage:[UIImage imageNamed:@"女"] forState:UIControlStateNormal];
    }
    
    userNameLabel.text = [[MySingleton sharedSingleton].nowuserinfo valueForKey:@"UserName"];
    
    
    
    [self initMyView];
    //    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    //    imageView.image = [UIImage imageNamed:@"Balloon"];
    //    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //    imageView.contentMode = UIViewContentModeScaleAspectFill;
    //    [self.view addSubview:imageView];
}

-(void)initMyView
{
    [_temperatureBtn addTarget:self action:@selector(showTemperatureMeasureView:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _recentWeightLabel.text = NSLocalizedString(@"RECENT_WEIGHT", nil);
    _weightUnitLabel.text = NSLocalizedString(@"WEIGHT_UNIT_KG", nil);
    weightResultLabel.text = NSLocalizedString(@"", nil);
    
    _recentBloodPressLabel.text = NSLocalizedString(@"RECENT_BLOODPRESS", nil);
    _bloodPressUnitLabel.text = NSLocalizedString(@"PRESS_UNIT_MMHG", nil);
    bloodPressResultLabel.text = NSLocalizedString(@"", nil);
    
    _recentFatLabel.text = NSLocalizedString(@"RECENT_FAT", nil);
    bodyFatResultLabel.text = NSLocalizedString(@"", nil);
    
    _recentTemperatureLabel.text = NSLocalizedString(@"RECENT_TEMPERATURE", nil);
    _temperatureUnitLabel.text = NSLocalizedString(@"TEMPERATURE_UNIT_SHESHIDU", nil);
    _temperatureResultLabel.text = NSLocalizedString(@"", nil);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//显示血压测试界面
-(IBAction)showBloodPressMeasureView:(id)sender
{
    NSLog(@"showBloodPressMeasureView");
    BloodPressureMeasureViewController *bloodPressureMeasureViewController = [[BloodPressureMeasureViewController alloc]initWithNibName:@"BloodPressureMeasureViewController" bundle:nil];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    
    [self.navigationController pushViewController:bloodPressureMeasureViewController animated:YES];
}

//显示体成分测试界面
-(IBAction)showBodyFatMeasureView:(id)sender
{
    NSLog(@"showBodyFatMeasureView");
    
    
    BodyFatMeasureViewController *bodyFatMeasureViewController = [[BodyFatMeasureViewController alloc]initWithNibName:@"BodyFatMeasureViewController" bundle:nil];
    [self.navigationController pushViewController:bodyFatMeasureViewController animated:YES];
}


//显示体重测量界面
-(IBAction)showWeightMeasureView:(id)sender
{
    NSLog(@"showWeightMeasureView");
    WeightMeasureViewController *weightMeasureViewController = [[WeightMeasureViewController alloc]initWithNibName:@"WeightMeasureViewController" bundle:nil];
    
    [self.navigationController pushViewController:weightMeasureViewController animated:YES];
}

//显示体温测量界面
-(IBAction)showTemperatureMeasureView:(id)sender
{
    NSLog(@"showTemperatureView");
    TemperatureViewController *temperatureViewController = [[TemperatureViewController alloc]initWithNibName:@"TemperatureViewController" bundle:nil];
    
    [self.navigationController pushViewController:temperatureViewController animated:YES];
}

//显示计步器测量界面
-(IBAction)showPedometerMeasureView:(id)sender
{
    NSLog(@"showPedometerMeasureView");
}

//慢跑
-(IBAction)showManPaoMeasureView:(id)sender
{
    NSLog(@"showManPaoMeasureView");
}

//徒步
-(IBAction)showTuBuMeasureView:(id)sender
{
    NSLog(@"showTuBuMeasureView");
}

//骑行
-(IBAction)showQiXingMeasureView:(id)sender
{
    NSLog(@"showQiXingMeasureView");
}

//攀登
-(IBAction)showPanDengMeasureView:(id)sender
{
    NSLog(@"showPanDengMeasureView");
}

//显示用户信息界面
-(IBAction)showUserInfoView:(id)sender
{
    NSLog(@"showUserInfoView");
}

-(void)getUserLastData
{
    [self getLastWeightData];
    [self getLastFatData];
    [self getLastBloodPressureData];
    [self getLastTemperatureData];
}

-(void)getLastWeightData
{
    //获取最近的体重例句
    //http://localhost:8080/service/ehealth_getLatelyWeightData?authkey=ZGJiNzAwOTYyYTc1NDBlNWIzYTY1MzgyM2U5N2NlNzEjMjAxMy0xMS0xMiAxMzo0MzowMSMzMCN6%0D%0AaF9DTg%3D%3D&requestnum=1&dtype=30
    NSString *authkey = [[MySingleton sharedSingleton].nowuserinfo valueForKey:@"AuthKey"];
    NSString *url = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_getLatelyWeightData?authkey=%@&requestnum=1&dtype=30",authkey];
    NSDictionary *dic = [ServerConnect getLastData:url];
    NSArray *weightdataArray = [[NSArray alloc]init];
    if([[dic valueForKey:@"weightdata"] isKindOfClass:[NSArray class]])
    {
        weightdataArray = (NSArray *)[dic valueForKey:@"weightdata"];
        
        if([weightdataArray count]!=0){
            
            NSDictionary *dicweightdataArray0 = weightdataArray[0];
            
            NSLog(@"建议: %@",[dicweightdataArray0 valueForKey:@"advice"]);
            NSLog(@"日期: %@",[dicweightdataArray0 valueForKey:@"date"]);
            NSLog(@"结果: %@",[dicweightdataArray0 valueForKey:@"result"]);
            NSLog(@"分享id: %@",[dicweightdataArray0 valueForKey:@"shareid"]);
            NSLog(@"值: %@",[dicweightdataArray0 valueForKey:@"value"]);
            
            if([[dicweightdataArray0 valueForKey:@"advice"] isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dicAdvice = (NSDictionary *)[dicweightdataArray0 valueForKey:@"advice"];
                NSLog(@"commSuggestion: %@",[dicAdvice valueForKey:@"commSuggestion"]);
                NSLog(@"doctorSuggestion: %@",[dicAdvice valueForKey:@"doctorSuggestion"]);
                NSLog(@"foodSuggestion: %@",[dicAdvice valueForKey:@"foodSuggestion"]);
                NSLog(@"sportSuggestion: %@",[dicAdvice valueForKey:@"sportSuggestion"]);
            }
            
            //设置界面体重值
            weightDataLabel.text = [dicweightdataArray0 valueForKey:@"value"];
            weightResultLabel.text = [dicweightdataArray0 valueForKey:@"result"];
            weightResultLabel.text = @"";
            
        }
    }
    
    NSLog(@"%@",dic);
}

-(void)getLastFatData
{
    //获取最近放入体成分
    //http://localhost:8080/service/ehealth_getLatelyBodyCompositionData?authkey=ZGJiNzAwOTYyYTc1NDBlNWIzYTY1MzgyM2U5N2NlNzEjMjAxMy0xMS0xMiAxMzo0MzowMSMzMCN6%0D%0AaF9DTg%3D%3D&requestnum=1&dtype=30
    
    NSString *authkey = [[MySingleton sharedSingleton].nowuserinfo valueForKey:@"AuthKey"];
    NSString *url = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_getLatelyBodyCompositionData?authkey=%@&requestnum=1&dtype=30",authkey];
    NSDictionary *dic = [ServerConnect getLastData:url];
    NSArray *bodyFatDataArray = [[NSArray alloc]init];
    if([[dic valueForKey:@"bodycompositiondata"] isKindOfClass:[NSArray class]])
    {
        bodyFatDataArray = (NSArray *)[dic valueForKey:@"bodycompositiondata"];
        
        NSLog(@"%@",bodyFatDataArray);
        
        if([bodyFatDataArray count] != 0){
            NSDictionary *dicdataArray0 = bodyFatDataArray[0];
            
            NSLog(@"日期: %@",[dicdataArray0 valueForKey:@"date"]);
            NSLog(@"结果: %@",[dicdataArray0 valueForKey:@"result"]);
            NSLog(@"分享id: %@",[dicdataArray0 valueForKey:@"shareid"]);
            NSLog(@"肌肉量: %@",[dicdataArray0 valueForKey:@"muscle_value"]);
            NSLog(@"脂肪率: %@",[dicdataArray0 valueForKey:@"adiposerate_value"]);
            NSLog(@"内脂肪等级: %@",[dicdataArray0 valueForKey:@"visceralfat_value"]);
            NSLog(@"水分: %@",[dicdataArray0 valueForKey:@"moisture_value"]);
            NSLog(@"骨量: %@",[dicdataArray0 valueForKey:@"bone"]);
            NSLog(@"基础代谢: %@",[dicdataArray0 valueForKey:@"thermal"]);
            NSLog(@"阻抗: %@",[dicdataArray0 valueForKey:@"impedance"]);
            NSLog(@"BMI: %@",[dicdataArray0 valueForKey:@"bmi"]);
            
            
            if([[dicdataArray0 valueForKey:@"advice"] isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dicAdvice = (NSDictionary *)[dicdataArray0 valueForKey:@"advice"];
                NSLog(@"commSuggestion: %@",[dicAdvice valueForKey:@"commSuggestion"]);
                NSLog(@"doctorSuggestion: %@",[dicAdvice valueForKey:@"doctorSuggestion"]);
                NSLog(@"foodSuggestion: %@",[dicAdvice valueForKey:@"foodSuggestion"]);
                NSLog(@"sportSuggestion: %@",[dicAdvice valueForKey:@"sportSuggestion"]);
            }
            
            bodyFatDataLabel.text =[dicdataArray0 valueForKey:@"adiposerate_value"];
        }
    }
    
    
    NSLog(@"%@",dic);
}

-(void)getLastBloodPressureData
{
    //获取最近的血压
    //http://localhost:8080/service/ehealth_getLatelyBloodPressureData?authkey=ZGJiNzAwOTYyYTc1NDBlNWIzYTY1MzgyM2U5N2NlNzEjMjAxMy0xMS0xMiAxMzo0MzowMSMzMCN6%0D%0AaF9DTg%3D%3D&requestnum=1&dtype=30
    
    NSString *authkey = [[MySingleton sharedSingleton].nowuserinfo valueForKey:@"AuthKey"];
    NSString *url = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_getLatelyBloodPressureData?authkey=%@&requestnum=1&dtype=30",authkey];
    NSDictionary *dic = [ServerConnect getLastData:url];
    
    NSArray *bloodPressureDataArray = [[NSArray alloc]init];
    if([[dic valueForKey:@"bloodpressuredata"] isKindOfClass:[NSArray class]])
    {
        bloodPressureDataArray = (NSArray *)[dic valueForKey:@"bloodpressuredata"];
        
        NSLog(@"%@",bloodPressureDataArray);
        if([bloodPressureDataArray count] != 0){
            NSDictionary *dicweightdataArray0 = bloodPressureDataArray[0];
            NSLog(@"建议: %@",[dicweightdataArray0 valueForKey:@"advice"]);
            NSLog(@"日期: %@",[dicweightdataArray0 valueForKey:@"date"]);
            NSLog(@"结果: %@",[dicweightdataArray0 valueForKey:@"result"]);
            NSLog(@"分享id: %@",[dicweightdataArray0 valueForKey:@"shareid"]);
            NSLog(@"收缩压: %@",[dicweightdataArray0 valueForKey:@"systolic"]);
            NSLog(@"舒张压: %@",[dicweightdataArray0 valueForKey:@"diastolic"]);
            NSLog(@"脉搏: %@",[dicweightdataArray0 valueForKey:@"pulse"]);
            
            if([[dicweightdataArray0 valueForKey:@"advice"] isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dicAdvice = (NSDictionary *)[dicweightdataArray0 valueForKey:@"advice"];
                NSLog(@"commSuggestion: %@",[dicAdvice valueForKey:@"commSuggestion"]);
                NSLog(@"doctorSuggestion: %@",[dicAdvice valueForKey:@"doctorSuggestion"]);
                NSLog(@"foodSuggestion: %@",[dicAdvice valueForKey:@"foodSuggestion"]);
                NSLog(@"sportSuggestion: %@",[dicAdvice valueForKey:@"sportSuggestion"]);
            }
            
            //设置界面的血压数据
            bloodPressDataLabel.text = [[NSString alloc]initWithFormat:@"%@/%@",[dicweightdataArray0 valueForKey:@"diastolic"],[dicweightdataArray0 valueForKey:@"systolic"]];
            bloodPressResultLabel.text = [dicweightdataArray0 valueForKey:@"result"];
            bloodPressResultLabel.text = @"";
        }
    }
    
    
    NSLog(@"%@",dic);
}

-(void)getLastTemperatureData
{
    //http://www.ebelter.com/service/ehealth_getLatelyTemperatureData?authkey=NjU1YjNlNjNjMTVjNDliZWJhNzc4ZDBmNzdkMGY3YjUjMjAxNC0wMy0yNiAxODoxMTo0MyMzMCN6%0AaF9DTg%3D%3D&requestnum=1&dtype=30
    
    NSString *authkey = [[MySingleton sharedSingleton].nowuserinfo valueForKey:@"AuthKey"];
    NSString *url = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_getLatelyTemperatureData?authkey=%@&requestnum=1&dtype=30",authkey];
    NSDictionary *dic = [ServerConnect getLastData:url];
    
    NSArray *temperatureDataArray = [[NSArray alloc]init];
    if([[dic valueForKey:@"temperaturedata"] isKindOfClass:[NSArray class]])
    {
        temperatureDataArray = (NSArray *)[dic valueForKey:@"temperaturedata"];
        
        NSLog(@"%@",temperatureDataArray);
        if([temperatureDataArray count] != 0){
            NSDictionary *dicweightdataArray0 = temperatureDataArray[0];
            
            NSLog(@"日期: %@",[dicweightdataArray0 valueForKey:@"date"]);
            NSLog(@"脉搏: %@",[dicweightdataArray0 valueForKey:@"value"]);
            
            if([[dicweightdataArray0 valueForKey:@"advice"] isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dicAdvice = (NSDictionary *)[dicweightdataArray0 valueForKey:@"advice"];
                NSLog(@"commSuggestion: %@",[dicAdvice valueForKey:@"commSuggestion"]);
                NSLog(@"doctorSuggestion: %@",[dicAdvice valueForKey:@"doctorSuggestion"]);
                NSLog(@"foodSuggestion: %@",[dicAdvice valueForKey:@"foodSuggestion"]);
                NSLog(@"sportSuggestion: %@",[dicAdvice valueForKey:@"sportSuggestion"]);
            }
            
            //设置界面的血压数据
            _temperatureDataLabel.text = [[NSString alloc]initWithFormat:@"%@",[dicweightdataArray0 valueForKey:@"value"]];
        }
        //        _temperatureResultLabel.text = [dicweightdataArray0 valueForKey:@"result"];
    }
    
}

@end
