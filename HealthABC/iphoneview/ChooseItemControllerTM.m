//
//  ChooseItemControllerTM.m
//  HealthABC
//
//  Created by 夏 伟 on 14-4-25.
//  Copyright (c) 2014年 夏 伟. All rights reserved.
//

#import "ChooseItemControllerTM.h"

#import "WeightMeasureViewController.h"
#import "BloodPressureMeasureViewController.h"
#import "BodyFatMeasureViewController.h"
#import "TemperatureViewController.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define Screen_height   [[UIScreen mainScreen] bounds].size.height
#define Screen_width    [[UIScreen mainScreen] bounds].size.width

@interface ChooseItemControllerTM ()
@property (weak, nonatomic) IBOutlet UIButton *weightBtn;
@property (weak, nonatomic) IBOutlet UIButton *bodyfatBtn;
@property (weak, nonatomic) IBOutlet UIButton *bloodpressBtn;
@property (weak, nonatomic) IBOutlet UIButton *temperatureBtn;
@property (strong, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *recentWeightDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyfatLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyfatRecentDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *bloodpressLabel;
@property (weak, nonatomic) IBOutlet UILabel *bloodpressRecentDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempRecentDataLabel;

@end

@implementation ChooseItemControllerTM

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.title = NSLocalizedString(@"MEASURE", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"TM_measure"];
        
//        self.navigationItem.title = NSLocalizedString(@"MEASURE", nil);
        self.navigationItem.title = @"";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:nil//NSLocalizedString(@"BACK", nil)
                                                                                style:UIBarButtonItemStyleBordered
                                                                               target:self
                                                                               action:nil];
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor colorWithRed:20.0/255.0 green:185.0/255.0 blue:214.0/255.0 alpha:1.0]];
//        [self.navigationItem.leftBarButtonItem setBackgroundImage:[UIImage imageNamed:@"ABC体重检测结果12"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//        [self.navigationItem.leftBarButtonItem setImage:[UIImage imageNamed:@"ABC体重检测结果1234"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initMyView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    if([[MySingleton sharedSingleton].nowuserinfo valueForKey:@"UserWeightDataArray"] != nil && [[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"UserWeightDataArray"] count] != 0)
    _recentWeightDataLabel.text = [[NSString alloc]initWithFormat:@"上次称重%.1f kg",[[[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"UserWeightDataArray"][0] valueForKey:@"weight"] floatValue]];
    if([[MySingleton sharedSingleton].nowuserinfo valueForKey:@"UserBodyFatDataArray"] != nil && [[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"UserBodyFatDataArray"] count] != 0)
    _bodyfatRecentDataLabel.text = [[NSString alloc]initWithFormat:@"上次脂肪率%.1f %%",[[[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"UserBodyFatDataArray"][0] valueForKey:@"adiposerate"] floatValue]];
    if([[MySingleton sharedSingleton].nowuserinfo valueForKey:@"UserBloodpressDataArray"] != nil && [[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"UserBloodpressDataArray"] count] != 0)
    _bloodpressRecentDataLabel.text = [[NSString alloc]initWithFormat:@"上次血压%d/%d mmHg",[[[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"UserBloodpressDataArray"][0] valueForKey:@"systolic"] intValue],[[[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"UserBloodpressDataArray"][0] valueForKey:@"diastolic"] intValue]];
    if([[MySingleton sharedSingleton].nowuserinfo valueForKey:@"UserTemperatureDataArray"] != nil && [[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"UserTemperatureDataArray"] count] != 0)
    _tempRecentDataLabel.text = [[NSString alloc]initWithFormat:@"上次体温%.1f ℃",[[[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"UserTemperatureDataArray"][0] valueForKey:@"temperature"] floatValue]];
}

-(void)initMyView
{
    [_weightBtn addTarget:self action:@selector(showWeightMeasureView:) forControlEvents:UIControlEventTouchUpInside];
    [_bodyfatBtn addTarget:self action:@selector(showBodyFatMeasureView:) forControlEvents:UIControlEventTouchUpInside];
    [_bloodpressBtn addTarget:self action:@selector(showBloodPressMeasureView:) forControlEvents:UIControlEventTouchUpInside];
    [_temperatureBtn addTarget:self action:@selector(showTemperatureMeasureView:) forControlEvents:UIControlEventTouchUpInside];
    
    if(iPhone5)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(7, 150, 307, 430)];
    }
    else{
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(7, 150, 307, 280)];
    }
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(_scrollContentView.frame.size.width,_scrollContentView.frame.size.height);
    _scrollView.alwaysBounceHorizontal = NO;//滑到边缘是否反弹
    _scrollView.alwaysBounceVertical = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [_scrollContentView setFrame:CGRectMake(0, 0, _scrollContentView.frame.size.width, _scrollContentView.frame.size.height)];
    [_scrollView addSubview:_scrollContentView];
    
    CGFloat topLogoImageViewy=34.0;
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
    {
        topLogoImageViewy = 34.0;
    }
    else if([[[UIDevice currentDevice] systemVersion] floatValue]<7.0)
    {
        topLogoImageViewy = 14.0;
    }
    UIImageView *topLogoImageView = [[UIImageView alloc]initWithFrame:CGRectMake((Screen_width-143)/2, topLogoImageViewy, 143.0, 16.0)];
    [topLogoImageView setImage:[UIImage imageNamed:@"TM_logo"]];
    [self.view addSubview:topLogoImageView];
    _usernameLabel.text = [[MySingleton sharedSingleton].nowuserinfo valueForKey:@"UserName"];
    
}


//显示血压测试界面
-(IBAction)showBloodPressMeasureView:(id)sender
{
    NSLog(@"showBloodPressMeasureView");
    BloodPressureMeasureViewController *bloodPressureMeasureViewController = [[BloodPressureMeasureViewController alloc]initWithNibName:@"BloodPressureMeasureViewController" bundle:nil];
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
//    backItem.image = [UIImage imageNamed:@"ABC体重检测结果1234"];
//    [self.navigationItem setBackBarButtonItem: backItem];
//    self.navigationController.navigationItem.leftBarButtonItem = backItem;
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

@end
