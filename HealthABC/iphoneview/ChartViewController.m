//
//  ChartViewController.m
//  HealthABC
//
//  Created by 夏 伟 on 14-4-9.
//  Copyright (c) 2014年 夏 伟. All rights reserved.
//

#import "ChartViewController.h"
#import "MySingleton.h"
#import "LineChartView.h"
#import "NSDate+Additions.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
@interface ChartViewController ()
@property (weak, nonatomic) IBOutlet UIButton *weightBtn;
@property (weak, nonatomic) IBOutlet UIButton *bodyfatBtn;
@property (weak, nonatomic) IBOutlet UIButton *bloodpressBtn;
@property (weak, nonatomic) IBOutlet UIButton *temperatureBtn;

@end

@implementation ChartViewController

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
    // Do any additional setup after loading the view from its nib.
    
    [self initMyView];
    
    NSDate *date1 = [[NSDate date] dateByAddingDays:(-6)];
    NSDate *date2 = [[NSDate date] dateByAddingDays:1];
    [self showWeightChart:date1 endtime:date2];
    [_weightBtn setBackgroundColor:[UIColor lightGrayColor]];
    
    _nowDataType = @"weight";
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initMyView
{
    [_weightBtn addTarget:self action:@selector(weightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_bodyfatBtn addTarget:self action:@selector(bodyfatBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_bloodpressBtn addTarget:self action:@selector(bloodpressBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_temperatureBtn addTarget:self action:@selector(temperatureBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [_weightBtn setTitle:NSLocalizedString(@"MEASURE_TYPE_WEIGHT", nil)  forState:UIControlStateNormal];
    [_bodyfatBtn setTitle:NSLocalizedString(@"MEASURE_TYPE_BODYFAT", nil) forState:UIControlStateNormal];
    [_bloodpressBtn setTitle:NSLocalizedString(@"MEASURE_TYPE_BLOODPRESSURE", nil) forState:UIControlStateNormal];
    [_temperatureBtn setTitle:NSLocalizedString(@"MEASURE_TYPE_TEMPERATURE", nil) forState:UIControlStateNormal];
}

-(IBAction)weightBtnPressed:(id)sender
{
    _nowDataType = @"weight";
    [self updateChartView];
    
    [_weightBtn setBackgroundColor:[UIColor lightGrayColor]];
    [_bloodpressBtn setBackgroundColor:[UIColor darkGrayColor]];
    [_bodyfatBtn setBackgroundColor:[UIColor darkGrayColor]];
    [_temperatureBtn setBackgroundColor:[UIColor darkGrayColor]];
}

-(IBAction)bodyfatBtnPressed:(id)sender
{
    _nowDataType = @"bodyfat";
    [self updateChartView];
    
    [_weightBtn setBackgroundColor:[UIColor darkGrayColor]];
    [_bloodpressBtn setBackgroundColor:[UIColor darkGrayColor]];
    [_bodyfatBtn setBackgroundColor:[UIColor lightGrayColor]];
    [_temperatureBtn setBackgroundColor:[UIColor darkGrayColor]];
}

-(IBAction)bloodpressBtnPressed:(id)sender
{
    _nowDataType = @"bloodpress";
    [self updateChartView];
    
    [_weightBtn setBackgroundColor:[UIColor darkGrayColor]];
    [_bloodpressBtn setBackgroundColor:[UIColor lightGrayColor]];
    [_bodyfatBtn setBackgroundColor:[UIColor darkGrayColor]];
    [_temperatureBtn setBackgroundColor:[UIColor darkGrayColor]];
}

-(IBAction)temperatureBtnPressed:(id)sender
{
    _nowDataType = @"temperature";
    [self updateChartView];
    
    [_weightBtn setBackgroundColor:[UIColor darkGrayColor]];
    [_bloodpressBtn setBackgroundColor:[UIColor darkGrayColor]];
    [_bodyfatBtn setBackgroundColor:[UIColor darkGrayColor]];
    [_temperatureBtn setBackgroundColor:[UIColor lightGrayColor]];
}

-(void)updateChartView
{
    if([_nowDataType isEqualToString:@"weight"])
    {
        [self showWeightChart:_nowBeginTime endtime:_nowEndTime];
    }
    else if ([_nowDataType isEqualToString:@"bodyfat"])
    {
        [self showFatChart:_nowBeginTime endtime:_nowEndTime];
    }
    else if ([_nowDataType isEqualToString:@"bloodpress"])
    {
        [self showBloodPressureChart:_nowBeginTime endtime:_nowEndTime];
    }
    else if ([_nowDataType isEqualToString:@"temperature"])
    {
        [self showTemperatureChart:_nowBeginTime endtime:_nowEndTime];
    }
}


-(void)showTemperatureChart:(NSDate *)begintime endtime:(NSDate *)endtime
{
    if(_nowBeginTimeLabel != nil)[_nowBeginTimeLabel removeFromSuperview];
    if(_nowEndTimeLabel != nil)[_nowEndTimeLabel removeFromSuperview];
    if(_previousBtn != nil)[_previousBtn removeFromSuperview];
    if(_nextBtn != nil)[_nextBtn removeFromSuperview];
    
    
    
    CGRect myChartFrame        = CGRectMake(10,  107, 280, 240);
    CGRect beginTimeLabelFrame = CGRectMake(25,  340, 50,  10);
    CGRect endTimeLabelFrame   = CGRectMake(245, 340, 50,  10);
    CGRect previousBtnFrame    = CGRectMake(100, 350, 60,  40);
    CGRect nextBtnFrame        = CGRectMake(160, 350, 60,  40);
    
    if(iPhone5)
    {
        myChartFrame = CGRectMake(10, 107, 280, 240);
    }
    
    self.nowBeginTime = begintime;
    self.nowEndTime = endtime;
    
    LineChartData *temperatureline = [self getLine:@"value" title:NSLocalizedString(@"MEASURE_TYPE_TEMPERATURE", nil) linecolor:[UIColor greenColor] begintime:begintime endtime:endtime];
    LineChartView *chartView = [[LineChartView alloc] initWithFrame:myChartFrame];
    chartView.yMin = 33;
    chartView.yMax = 43;
    chartView.ySteps = @[@"33.0℃",@"35.0",@"37.0",@"39.0",@"41.0",@"43.0"];
    chartView.data = @[temperatureline];
    
    [self.view addSubview:chartView];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    _nowBeginTimeLabel = [[UILabel alloc]initWithFrame:beginTimeLabelFrame];
    _nowBeginTimeLabel.textAlignment = NSTextAlignmentLeft;
    [_nowBeginTimeLabel setFont:[UIFont fontWithName:@"Helvetica" size:9]];
    _nowBeginTimeLabel.text = [formatter stringFromDate:begintime];
    
    _nowEndTimeLabel = [[UILabel alloc]initWithFrame:endTimeLabelFrame];
    _nowEndTimeLabel.textAlignment = NSTextAlignmentRight;
    [_nowEndTimeLabel setFont:[UIFont fontWithName:@"Helvetica" size:9]];
    _nowEndTimeLabel.text = [formatter stringFromDate:endtime];
    
    [self.view addSubview:_nowBeginTimeLabel];
    [self.view addSubview:_nowEndTimeLabel];
    
    
    _previousBtn = [[UIButton alloc]initWithFrame:previousBtnFrame];
    [_previousBtn setBackgroundColor:[UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0]];
    [_previousBtn setTitle:NSLocalizedString(@"EARLIER", nil) forState:UIControlStateNormal];
    [_previousBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    _previousBtn.titleLabel.textColor = [UIColor orangeColor];
    [_previousBtn addTarget:self action:@selector(previousBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _nextBtn = [[UIButton alloc]initWithFrame:nextBtnFrame];
    [_nextBtn setBackgroundColor:[UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0]];
    [_nextBtn setTitle:NSLocalizedString(@"LATER", nil) forState:UIControlStateNormal];
    [_nextBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    _nextBtn.titleLabel.textColor = [UIColor orangeColor];
    [_nextBtn addTarget:self action:@selector(nextBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_previousBtn];
    [self.view addSubview:_nextBtn];
}


-(LineChartData *)getLine:(NSString *)dataname title:(NSString *)title linecolor:(UIColor *)linecolor begintime:(NSDate *)begintime endtime:(NSDate *)endtime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    LineChartData *data = [LineChartData new];
    {
        LineChartData *d1 = data;
        
        NSMutableArray *dataarray = [self getArrayBetweenFromArray:[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"UserTemperatureDataArray"] begintime:begintime endtime:endtime];
        
        
        d1.xMin = [begintime timeIntervalSinceReferenceDate];
        d1.xMax = [endtime timeIntervalSinceReferenceDate];
        d1.title = title;
        d1.color = linecolor;
        d1.itemCount = [dataarray count];
        NSMutableArray *arr = [NSMutableArray array];
        
        for(NSUInteger i = 0; i < d1.itemCount; ++i) {
            NSDate *testtime = [formatter dateFromString:[dataarray[i] valueForKey:@"date"]];
            long item = [testtime timeIntervalSinceReferenceDate];
            [arr addObject:@(item)];
            //            [arr addObject:@(d1.xMin + (rand() / (float)RAND_MAX) * (d1.xMax - d1.xMin))];
        }
        //        [arr addObject:@(d1.xMin)];
        //        [arr addObject:@(d1.xMax)];
        //        [arr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        //            return [obj1 compare:obj2];
        //        }];
        
        NSMutableArray *arr2 = [NSMutableArray array];
        for(NSUInteger i = 0; i < d1.itemCount; ++i) {
            float y = [[dataarray[i] valueForKey:dataname] floatValue];
            [arr2 addObject:@(y)];
            //            [arr2 addObject:@((rand() / (float)RAND_MAX) * 6)];
        }
        d1.getData = ^(NSUInteger item) {
            float x = [arr[item] floatValue];
            float y = [arr2[item] floatValue];
            
            NSString *label1 = [formatter stringFromDate:[formatter dateFromString:[dataarray[item] valueForKey:@"date"]]];
            NSString *label2 = [NSString stringWithFormat:@"%.1f", y];
            return [LineChartDataItem dataItemWithX:x y:y xLabel:label1 dataLabel:label2];
        };
    }
    
    return data;
}

-(IBAction)previousBtnPressed:(id)sender
{
    NSDate *date1 = [self.nowBeginTime dateByAddingDays:-6];
    NSDate *date2 = [self.nowEndTime dateByAddingDays:-6];
    
    if([_nowDataType isEqualToString:@"weight"])
    {
        [self showWeightChart:date1 endtime:date2];
    }
    else if ([_nowDataType isEqualToString:@"bodyfat"])
    {
        [self showFatChart:date1 endtime:date2];
    }
    else if ([_nowDataType isEqualToString:@"bloodpress"])
    {
        [self showBloodPressureChart:date1 endtime:date2];
    }
    else if ([_nowDataType isEqualToString:@"temperature"])
    {
        [self showTemperatureChart:date1 endtime:date2];
    }
    
}

-(IBAction)nextBtnPressed:(id)sender
{
    NSDate *date1 = [self.nowBeginTime dateByAddingDays:6];
    NSDate *date2 = [self.nowEndTime dateByAddingDays:6];
    if([_nowDataType isEqualToString:@"weight"])
    {
        [self showWeightChart:date1 endtime:date2];
    }
    else if ([_nowDataType isEqualToString:@"bodyfat"])
    {
        [self showFatChart:date1 endtime:date2];
    }
    else if ([_nowDataType isEqualToString:@"bloodpress"])
    {
        [self showBloodPressureChart:date1 endtime:date2];
    }
    else if ([_nowDataType isEqualToString:@"temperature"])
    {
        [self showTemperatureChart:date1 endtime:date2];
    }
}







//从一个序列化数据数组中获取一段时间内的数据
-(NSMutableArray *)getArrayBetweenFromArray : (NSArray *)array begintime:(NSDate *)begintime endtime : (NSDate *)endtime
{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    
    if(array == nil || array.count == 0)
    {
        return result;
    }
    else
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        for(int i = 0; i<array.count; i++ )
        {
            NSDate *date = [formatter dateFromString:[array[i] valueForKey:@"date"]];
            if([date compare:begintime] != NSOrderedAscending && [date compare:endtime] != NSOrderedDescending)
            {
                [result addObject:array[i]];
            }
        }
    }
    
    return result;
}




//体重图表
-(void)showWeightChart:(NSDate *)begintime endtime:(NSDate *)endtime
{
    if(_nowBeginTimeLabel != nil)[_nowBeginTimeLabel removeFromSuperview];
    if(_nowEndTimeLabel != nil)[_nowEndTimeLabel removeFromSuperview];
    if(_previousBtn != nil)[_previousBtn removeFromSuperview];
    if(_nextBtn != nil)[_nextBtn removeFromSuperview];
    
    
    
    CGRect myChartFrame        = CGRectMake(10,  107, 280, 240);
    CGRect beginTimeLabelFrame = CGRectMake(25,  340, 50,  10);
    CGRect endTimeLabelFrame   = CGRectMake(245, 340, 50,  10);
    CGRect previousBtnFrame    = CGRectMake(100, 350, 60,  40);
    CGRect nextBtnFrame        = CGRectMake(160, 350, 60,  40);
    
    if(iPhone5)
    {
        myChartFrame = CGRectMake(10, 107, 280, 240);
    }
    
    self.nowBeginTime = begintime;
    self.nowEndTime = endtime;
    
    LineChartData *temperatureline = [self getWeightLine:@"value" title:NSLocalizedString(@"USER_WEIGHT", nil) linecolor:[UIColor greenColor] begintime:begintime endtime:endtime];
    LineChartView *chartView = [[LineChartView alloc] initWithFrame:myChartFrame];
    chartView.yMin = 0;
    chartView.yMax = 150;
    chartView.ySteps = @[@"0kg",@"30",@"60",@"90",@"120",@"150"];
    chartView.data = @[temperatureline];
    
    [self.view addSubview:chartView];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    _nowBeginTimeLabel = [[UILabel alloc]initWithFrame:beginTimeLabelFrame];
    _nowBeginTimeLabel.textAlignment = NSTextAlignmentLeft;
    [_nowBeginTimeLabel setFont:[UIFont fontWithName:@"Helvetica" size:9]];
    _nowBeginTimeLabel.text = [formatter stringFromDate:begintime];
    
    _nowEndTimeLabel = [[UILabel alloc]initWithFrame:endTimeLabelFrame];
    _nowEndTimeLabel.textAlignment = NSTextAlignmentRight;
    [_nowEndTimeLabel setFont:[UIFont fontWithName:@"Helvetica" size:9]];
    _nowEndTimeLabel.text = [formatter stringFromDate:endtime];
    
    [self.view addSubview:_nowBeginTimeLabel];
    [self.view addSubview:_nowEndTimeLabel];
    
    
    _previousBtn = [[UIButton alloc]initWithFrame:previousBtnFrame];
    [_previousBtn setBackgroundColor:[UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0]];
    [_previousBtn setTitle:NSLocalizedString(@"EARLIER", nil) forState:UIControlStateNormal];
    [_previousBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    _previousBtn.titleLabel.textColor = [UIColor orangeColor];
    [_previousBtn addTarget:self action:@selector(previousBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _nextBtn = [[UIButton alloc]initWithFrame:nextBtnFrame];
    [_nextBtn setBackgroundColor:[UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0]];
    [_nextBtn setTitle:NSLocalizedString(@"LATER", nil) forState:UIControlStateNormal];
    [_nextBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    _nextBtn.titleLabel.textColor = [UIColor orangeColor];
    [_nextBtn addTarget:self action:@selector(nextBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_previousBtn];
    [self.view addSubview:_nextBtn];
}


-(LineChartData *)getWeightLine:(NSString *)dataname title:(NSString *)title linecolor:(UIColor *)linecolor begintime:(NSDate *)begintime endtime:(NSDate *)endtime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    LineChartData *data = [LineChartData new];
    {
        LineChartData *d1 = data;
        
        NSMutableArray *dataarray = [self getArrayBetweenFromArray:[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"UserWeightDataArray"] begintime:begintime endtime:endtime];
        
        
        d1.xMin = [begintime timeIntervalSinceReferenceDate];
        d1.xMax = [endtime timeIntervalSinceReferenceDate];
        d1.title = title;
        d1.color = linecolor;
        d1.itemCount = [dataarray count];
        NSMutableArray *arr = [NSMutableArray array];
        
        for(NSUInteger i = 0; i < d1.itemCount; ++i) {
            NSDate *testtime = [formatter dateFromString:[dataarray[i] valueForKey:@"date"]];
            long item = [testtime timeIntervalSinceReferenceDate];
            [arr addObject:@(item)];
            //            [arr addObject:@(d1.xMin + (rand() / (float)RAND_MAX) * (d1.xMax - d1.xMin))];
        }
        //        [arr addObject:@(d1.xMin)];
        //        [arr addObject:@(d1.xMax)];
        //        [arr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        //            return [obj1 compare:obj2];
        //        }];
        
        NSMutableArray *arr2 = [NSMutableArray array];
        for(NSUInteger i = 0; i < d1.itemCount; ++i) {
            float y = [[dataarray[i] valueForKey:dataname] floatValue];
            [arr2 addObject:@(y)];
            //            [arr2 addObject:@((rand() / (float)RAND_MAX) * 6)];
        }
        d1.getData = ^(NSUInteger item) {
            float x = [arr[item] floatValue];
            float y = [arr2[item] floatValue];
            
            NSString *label1 = [formatter stringFromDate:[formatter dateFromString:[dataarray[item] valueForKey:@"date"]]];
            NSString *label2 = [NSString stringWithFormat:@"%.1f", y];
            return [LineChartDataItem dataItemWithX:x y:y xLabel:label1 dataLabel:label2];
        };
    }
    
    return data;
}


//体成分图表
-(void)showFatChart:(NSDate *)begintime endtime:(NSDate *)endtime
{
    if(_nowBeginTimeLabel != nil)[_nowBeginTimeLabel removeFromSuperview];
    if(_nowEndTimeLabel != nil)[_nowEndTimeLabel removeFromSuperview];
    if(_previousBtn != nil)[_previousBtn removeFromSuperview];
    if(_nextBtn != nil)[_nextBtn removeFromSuperview];
    
    
    
    CGRect myChartFrame        = CGRectMake(10,  107, 280, 240);
    CGRect beginTimeLabelFrame = CGRectMake(25,  340, 50,  10);
    CGRect endTimeLabelFrame   = CGRectMake(245, 340, 50,  10);
    CGRect previousBtnFrame    = CGRectMake(100, 350, 60,  40);
    CGRect nextBtnFrame        = CGRectMake(160, 350, 60,  40);
    
    if(iPhone5)
    {
        myChartFrame = CGRectMake(10, 107, 280, 240);
    }
    
    self.nowBeginTime = begintime;
    self.nowEndTime = endtime;
    
    LineChartData *temperatureline = [self getFatLine:@"adiposerate_value" title:NSLocalizedString(@"USER_FAT", nil) linecolor:[UIColor greenColor] begintime:begintime endtime:endtime];
    LineChartView *chartView = [[LineChartView alloc] initWithFrame:myChartFrame];
    chartView.yMin = 0;
    chartView.yMax = 100;
    chartView.ySteps = @[@"0%",@"20",@"40",@"60",@"80",@"100"];
    chartView.data = @[temperatureline];
    
    [self.view addSubview:chartView];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    _nowBeginTimeLabel = [[UILabel alloc]initWithFrame:beginTimeLabelFrame];
    _nowBeginTimeLabel.textAlignment = NSTextAlignmentLeft;
    [_nowBeginTimeLabel setFont:[UIFont fontWithName:@"Helvetica" size:9]];
    _nowBeginTimeLabel.text = [formatter stringFromDate:begintime];
    
    _nowEndTimeLabel = [[UILabel alloc]initWithFrame:endTimeLabelFrame];
    _nowEndTimeLabel.textAlignment = NSTextAlignmentRight;
    [_nowEndTimeLabel setFont:[UIFont fontWithName:@"Helvetica" size:9]];
    _nowEndTimeLabel.text = [formatter stringFromDate:endtime];
    
    [self.view addSubview:_nowBeginTimeLabel];
    [self.view addSubview:_nowEndTimeLabel];
    
    
    _previousBtn = [[UIButton alloc]initWithFrame:previousBtnFrame];
    [_previousBtn setBackgroundColor:[UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0]];
    [_previousBtn setTitle:NSLocalizedString(@"EARLIER", nil) forState:UIControlStateNormal];
    [_previousBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    _previousBtn.titleLabel.textColor = [UIColor orangeColor];
    [_previousBtn addTarget:self action:@selector(previousBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _nextBtn = [[UIButton alloc]initWithFrame:nextBtnFrame];
    [_nextBtn setBackgroundColor:[UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0]];
    [_nextBtn setTitle:NSLocalizedString(@"LATER", nil) forState:UIControlStateNormal];
    [_nextBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    _nextBtn.titleLabel.textColor = [UIColor orangeColor];
    [_nextBtn addTarget:self action:@selector(nextBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_previousBtn];
    [self.view addSubview:_nextBtn];
}


-(LineChartData *)getFatLine:(NSString *)dataname title:(NSString *)title linecolor:(UIColor *)linecolor begintime:(NSDate *)begintime endtime:(NSDate *)endtime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    LineChartData *data = [LineChartData new];
    {
        LineChartData *d1 = data;
        
        NSMutableArray *dataarray = [self getArrayBetweenFromArray:[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"UserBodyFatDataArray"] begintime:begintime endtime:endtime];
        
        
        d1.xMin = [begintime timeIntervalSinceReferenceDate];
        d1.xMax = [endtime timeIntervalSinceReferenceDate];
        d1.title = title;
        d1.color = linecolor;
        d1.itemCount = [dataarray count];
        NSMutableArray *arr = [NSMutableArray array];
        
        for(NSUInteger i = 0; i < d1.itemCount; ++i) {
            NSDate *testtime = [formatter dateFromString:[dataarray[i] valueForKey:@"date"]];
            long item = [testtime timeIntervalSinceReferenceDate];
            [arr addObject:@(item)];
            //            [arr addObject:@(d1.xMin + (rand() / (float)RAND_MAX) * (d1.xMax - d1.xMin))];
        }
        //        [arr addObject:@(d1.xMin)];
        //        [arr addObject:@(d1.xMax)];
        //        [arr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        //            return [obj1 compare:obj2];
        //        }];
        
        NSMutableArray *arr2 = [NSMutableArray array];
        for(NSUInteger i = 0; i < d1.itemCount; ++i) {
            float y = [[dataarray[i] valueForKey:dataname] floatValue];
            [arr2 addObject:@(y)];
            //            [arr2 addObject:@((rand() / (float)RAND_MAX) * 6)];
        }
        d1.getData = ^(NSUInteger item) {
            float x = [arr[item] floatValue];
            float y = [arr2[item] floatValue];
            
            NSString *label1 = [formatter stringFromDate:[formatter dateFromString:[dataarray[item] valueForKey:@"date"]]];
            NSString *label2 = [NSString stringWithFormat:@"%.1f", y];
            return [LineChartDataItem dataItemWithX:x y:y xLabel:label1 dataLabel:label2];
        };
    }
    
    return data;
}


//血压图表
-(void)showBloodPressureChart:(NSDate *)begintime endtime:(NSDate *)endtime
{
    if(_nowBeginTimeLabel != nil)[_nowBeginTimeLabel removeFromSuperview];
    if(_nowEndTimeLabel != nil)[_nowEndTimeLabel removeFromSuperview];
    if(_previousBtn != nil)[_previousBtn removeFromSuperview];
    if(_nextBtn != nil)[_nextBtn removeFromSuperview];
    
    
    
    CGRect myChartFrame        = CGRectMake(10,  107, 280, 240);
    CGRect beginTimeLabelFrame = CGRectMake(25,  340, 50,  10);
    CGRect endTimeLabelFrame   = CGRectMake(245, 340, 50,  10);
    CGRect previousBtnFrame    = CGRectMake(100, 350, 60,  40);
    CGRect nextBtnFrame        = CGRectMake(160, 350, 60,  40);
    
    if(iPhone5)
    {
        myChartFrame = CGRectMake(10, 107, 280, 240);
    }
    
    self.nowBeginTime = begintime;
    self.nowEndTime = endtime;
    
    LineChartData *sysline = [self getBloodPressLine:@"systolic" title:NSLocalizedString(@"USER_SYS", nil) linecolor:[UIColor greenColor] begintime:begintime endtime:endtime];
    LineChartData *dialine = [self getBloodPressLine:@"diastolic" title:NSLocalizedString(@"USER_DIA", nil) linecolor:[UIColor blueColor] begintime:begintime endtime:endtime];
    LineChartView *chartView = [[LineChartView alloc] initWithFrame:myChartFrame];
    chartView.yMin = 0;
    chartView.yMax = 200;
    chartView.ySteps = @[@"0mmHg",@"50",@"100",@"150",@"200"];
    chartView.data = @[sysline,dialine];
    
    [self.view addSubview:chartView];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    _nowBeginTimeLabel = [[UILabel alloc]initWithFrame:beginTimeLabelFrame];
    _nowBeginTimeLabel.textAlignment = NSTextAlignmentLeft;
    [_nowBeginTimeLabel setFont:[UIFont fontWithName:@"Helvetica" size:9]];
    _nowBeginTimeLabel.text = [formatter stringFromDate:begintime];
    
    _nowEndTimeLabel = [[UILabel alloc]initWithFrame:endTimeLabelFrame];
    _nowEndTimeLabel.textAlignment = NSTextAlignmentRight;
    [_nowEndTimeLabel setFont:[UIFont fontWithName:@"Helvetica" size:9]];
    _nowEndTimeLabel.text = [formatter stringFromDate:endtime];
    
    [self.view addSubview:_nowBeginTimeLabel];
    [self.view addSubview:_nowEndTimeLabel];
    
    
    _previousBtn = [[UIButton alloc]initWithFrame:previousBtnFrame];
    [_previousBtn setBackgroundColor:[UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0]];
    [_previousBtn setTitle:NSLocalizedString(@"EARLIER", nil) forState:UIControlStateNormal];
    [_previousBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    _previousBtn.titleLabel.textColor = [UIColor orangeColor];
    [_previousBtn addTarget:self action:@selector(previousBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _nextBtn = [[UIButton alloc]initWithFrame:nextBtnFrame];
    [_nextBtn setBackgroundColor:[UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0]];
    [_nextBtn setTitle:NSLocalizedString(@"LATER", nil) forState:UIControlStateNormal];
    [_nextBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    _nextBtn.titleLabel.textColor = [UIColor orangeColor];
    [_nextBtn addTarget:self action:@selector(nextBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_previousBtn];
    [self.view addSubview:_nextBtn];
}


-(LineChartData *)getBloodPressLine:(NSString *)dataname title:(NSString *)title linecolor:(UIColor *)linecolor begintime:(NSDate *)begintime endtime:(NSDate *)endtime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    LineChartData *data = [LineChartData new];
    {
        LineChartData *d1 = data;
        
        NSMutableArray *dataarray = [self getArrayBetweenFromArray:[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"UserBloodpressDataArray"] begintime:begintime endtime:endtime];
        
        
        d1.xMin = [begintime timeIntervalSinceReferenceDate];
        d1.xMax = [endtime timeIntervalSinceReferenceDate];
        d1.title = title;
        d1.color = linecolor;
        d1.itemCount = [dataarray count];
        NSMutableArray *arr = [NSMutableArray array];
        
        for(NSUInteger i = 0; i < d1.itemCount; ++i) {
            NSDate *testtime = [formatter dateFromString:[dataarray[i] valueForKey:@"date"]];
            long item = [testtime timeIntervalSinceReferenceDate];
            [arr addObject:@(item)];
            //            [arr addObject:@(d1.xMin + (rand() / (float)RAND_MAX) * (d1.xMax - d1.xMin))];
        }
        //        [arr addObject:@(d1.xMin)];
        //        [arr addObject:@(d1.xMax)];
        //        [arr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        //            return [obj1 compare:obj2];
        //        }];
        
        NSMutableArray *arr2 = [NSMutableArray array];
        for(NSUInteger i = 0; i < d1.itemCount; ++i) {
            float y = [[dataarray[i] valueForKey:dataname] floatValue];
            [arr2 addObject:@(y)];
            //            [arr2 addObject:@((rand() / (float)RAND_MAX) * 6)];
        }
        d1.getData = ^(NSUInteger item) {
            float x = [arr[item] floatValue];
            float y = [arr2[item] floatValue];
            
            NSString *label1 = [formatter stringFromDate:[formatter dateFromString:[dataarray[item] valueForKey:@"date"]]];
            NSString *label2 = [NSString stringWithFormat:@"%.0f", y];
            return [LineChartDataItem dataItemWithX:x y:y xLabel:label1 dataLabel:label2];
        };
    }
    
    return data;
}


@end
