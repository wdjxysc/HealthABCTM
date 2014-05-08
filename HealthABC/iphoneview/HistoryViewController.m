//
//  HistoryViewController.m
//  HealthABC
//
//  Created by 夏 伟 on 14-3-24.
//  Copyright (c) 2014年 夏 伟. All rights reserved.
//

#import "HistoryViewController.h"
#import "DEMONavigationController.h"
#import "database.h"
#import "MySingleton.h"
#import "NSDate+Additions.h"
#import "TempDataTableViewCell.h"
#import "WeightTableViewCell.h"
#import "BodyFatTableViewCell.h"
#import "BloodPressTableViewCell.h"
#import "ServerConnect.h"
#import "ChartViewController.h"

@interface HistoryViewController ()
@property (weak, nonatomic) IBOutlet UIButton *weightBtn;
@property (weak, nonatomic) IBOutlet UIButton *bodyFatBtn;
@property (weak, nonatomic) IBOutlet UIButton *bloodPressureBtn;
@property (weak, nonatomic) IBOutlet UIButton *temperatureBtn;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation HistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"HISTORY", nil);
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"MENU", nil)
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:(DEMONavigationController *)self.navigationController
                                                                                action:@selector(showMenu)];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"CHART", nil)
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(showChartView)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initMyView];
    self.nowDataType = @"bloodpress";
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                [[NSString alloc] initWithFormat:@"2014-03-23 15:25:35"],@"TestTime",
                                [[NSString alloc] initWithFormat:@"37.1"],@"Temperature",
                                nil];
    
    dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
          [[NSString alloc] initWithFormat:@"2014-03-23 15:25:35"],@"TestTime",
          [[NSString alloc] initWithFormat:@"37.1"],@"Weight",
          nil];
//    cell.testtimeDataLabel.text = [[NSString alloc] initWithFormat:@"%@",[rowData objectForKey:@"TestTime"]];
//    
//    cell.weightDataLabel.text = [[NSString alloc] initWithFormat:@"%@ kg",[rowData objectForKey:@"Weight"]];
//    cell.bodyfatDataLabel.text = [[NSString alloc] initWithFormat:@"%@ %%",[rowData objectForKey:@"Fat"]];
//    cell.muscleDataLabel.text = [[NSString alloc] initWithFormat:@"%@ kg",[rowData objectForKey:@"Muscle"]];
//    cell.waterDataLabel.text = [[NSString alloc] initWithFormat:@"%@ %%",[rowData objectForKey:@"Water"]];
//    cell.boneDataLabel.text = [[NSString alloc] initWithFormat:@"%@ kg",[rowData objectForKey:@"Bone"]];
//    cell.visfatDataLabel.text = [[NSString alloc] initWithFormat:@"%@",[rowData objectForKey:@"VisceralFat"]];
//    cell.bmiDataLabel.text = [[NSString alloc] initWithFormat:@"%@",[rowData objectForKey:@"BMI"]];
//    cell.kcalDataLabel.text = [[NSString alloc] initWithFormat:@"%@ kcal",[rowData objectForKey:@"BMR"]];
    dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
           [[NSString alloc] initWithFormat:@"2014-03-23 15:25:35"],@"TestTime",
           [[NSString alloc] initWithFormat:@"67.0"],@"Weight",
           [[NSString alloc] initWithFormat:@"28.1"],@"Fat",
           [[NSString alloc] initWithFormat:@"38.1"],@"Muscle",
           [[NSString alloc] initWithFormat:@"60.1"],@"Water",
           [[NSString alloc] initWithFormat:@"3.6"],@"Bone",
           [[NSString alloc] initWithFormat:@"3"],@"VisceralFat",
           [[NSString alloc] initWithFormat:@"23.6"],@"BMI",
           [[NSString alloc] initWithFormat:@"1234"],@"BMR",
           nil];
    
    dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
           [[NSString alloc] initWithFormat:@"2014-03-23 15:25:35"],@"TestTime",
           [[NSString alloc] initWithFormat:@"67.0"],@"SYS",
           [[NSString alloc] initWithFormat:@"28.1"],@"DIA",
           [[NSString alloc] initWithFormat:@"38.1"],@"Pulse",
           nil];
    
    self.dataArray = [[NSMutableArray alloc] init];
    
//    [self.dataArray addObject:dic];
    
//    self.dataArray = [database getTemperatureDataByUserName:[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"UserName"] begintime:[[NSDate date] dateByAddingDays:-7] endtime:[NSDate date]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initMyView
{
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    
    [_weightBtn setTitle:NSLocalizedString(@"MEASURE_TYPE_WEIGHT", nil)  forState:UIControlStateNormal];
    [_bodyFatBtn setTitle:NSLocalizedString(@"MEASURE_TYPE_BODYFAT", nil) forState:UIControlStateNormal];
    [_bloodPressureBtn setTitle:NSLocalizedString(@"MEASURE_TYPE_BLOODPRESSURE", nil) forState:UIControlStateNormal];
    [_temperatureBtn setTitle:NSLocalizedString(@"MEASURE_TYPE_TEMPERATURE", nil) forState:UIControlStateNormal];
    
    
    [_weightBtn addTarget:self action:@selector(weightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_bodyFatBtn addTarget:self action:@selector(bodyfatBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_bloodPressureBtn addTarget:self action:@selector(bloodpressBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_temperatureBtn addTarget:self action:@selector(temperatureBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _weightDataArray = [[NSMutableArray alloc]init];
    _bodyfatDataArray = [[NSMutableArray alloc]init];
    _bloodpressDataArray = [[NSMutableArray alloc]init];
    _temperatrueDataArray = [[NSMutableArray alloc]init];
    
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(getDataFromCloud) object:nil];
    [thread start];
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger i = 0;
    
    i = [self.dataArray count];
    
    return i;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    UITableViewCell *returncell = [[UITableViewCell alloc]init];
    if ([_nowDataType isEqualToString:@"temperature"])
    {
        TempDataTableViewCell *cell = (TempDataTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        
        if(cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TempDataTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        NSUInteger row = [indexPath row];
        NSDictionary *rowData = [self.dataArray objectAtIndex:row];
        cell.testTimeLabel.text = [[NSString alloc] initWithFormat:@"%@",[rowData objectForKey:@"date"]];
        cell.dataLabel.text = [[NSString alloc] initWithFormat:@"%@",[rowData objectForKey:@"value"]];
        
        
        [cell.statusBtn setTitle:NSLocalizedString(@"正常", nil) forState:UIControlStateNormal];
        //        [cell.statusBtn setBackgroundColor:[UIColor blueColor]];
        returncell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        returncell = cell;
    }
    else if ([_nowDataType isEqualToString:@"weight"])
    {
        WeightTableViewCell *cell =(WeightTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        if(cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WeightTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        NSUInteger row = [indexPath row];
        NSDictionary *rowData = [self.dataArray objectAtIndex:row];
        cell.testTimeLabel.text = [[NSString alloc] initWithFormat:@"%@",[rowData objectForKey:@"date"]];
        
        cell.weightDataLabel.text = [[NSString alloc] initWithFormat:@"%@",[rowData objectForKey:@"value"]];
        
        
        //        [cell.statusBtn setBackgroundColor:[UIColor blueColor]];
        returncell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        returncell = cell;
    }
    else if ([_nowDataType isEqualToString:@"bodyfat"])
    {
        BodyFatTableViewCell *cell =(BodyFatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        if(cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BodyFatTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        NSUInteger row = [indexPath row];
        NSDictionary *rowData = [self.dataArray objectAtIndex:row];
        cell.testtimeDataLabel.text = [[NSString alloc] initWithFormat:@"%@",[rowData objectForKey:@"date"]];
        
        cell.weightDataLabel.text = [[NSString alloc] initWithFormat:@"%@ kg",[rowData objectForKey:@"weight"]];
        cell.bodyfatDataLabel.text = [[NSString alloc] initWithFormat:@"%@ %%",[rowData objectForKey:@"adiposerate_value"]];
        cell.muscleDataLabel.text = [[NSString alloc] initWithFormat:@"%@ kg",[rowData objectForKey:@"muscle_value"]];
        cell.waterDataLabel.text = [[NSString alloc] initWithFormat:@"%@ %%",[rowData objectForKey:@"moisture_value"]];
        cell.boneDataLabel.text = [[NSString alloc] initWithFormat:@"%@ kg",[rowData objectForKey:@"bone"]];
        cell.visfatDataLabel.text = [[NSString alloc] initWithFormat:@"%@",[rowData objectForKey:@"visceralfat_value"]];
        cell.bmiDataLabel.text = [[NSString alloc] initWithFormat:@"%@",[rowData objectForKey:@"bmi"]];
        cell.kcalDataLabel.text = [[NSString alloc] initWithFormat:@"%@ kcal",[rowData objectForKey:@"thermal"]];
        
        
        //        [cell.statusBtn setBackgroundColor:[UIColor blueColor]];
        returncell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        returncell = cell;
    }
    else if ([_nowDataType isEqualToString:@"bloodpress"])
    {
        BloodPressTableViewCell *cell =(BloodPressTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        if(cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BloodPressTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        NSUInteger row = [indexPath row];
        NSDictionary *rowData = [self.dataArray objectAtIndex:row];
        cell.testtimeDataLabel.text = [[NSString alloc] initWithFormat:@"%@",[rowData objectForKey:@"date"]];
        
        cell.sysDataLabel.text = [[NSString alloc] initWithFormat:@"%@ mmHg",[rowData objectForKey:@"systolic"]];
        cell.diaDataLabel.text = [[NSString alloc] initWithFormat:@"%@ mmHg",[rowData objectForKey:@"diastolic"]];
        cell.pulseDataLabel.text = [[NSString alloc] initWithFormat:@"%@",[rowData objectForKey:@"pulse"]];
        
        
        //        [cell.statusBtn setBackgroundColor:[UIColor blueColor]];
        returncell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        returncell = cell;
    }
    return returncell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat result = 50.0f;
    if([_nowDataType isEqualToString:@"temperature"])
    {
        result = 55.0f;
    }
    else if([_nowDataType isEqualToString:@"weight"])
    {
        result = 55.0f;
    }
    else if([_nowDataType isEqualToString:@"bodyfat"])
    {
        result = 115.0f;
    }
    else if([_nowDataType isEqualToString:@"bloodpress"])
    {
        result = 64.0f;
    }
    
    return result;
    //    return roundf(50);
}

-(IBAction)showTempChart:(id)sender
{
//    TempChartViewController *tempChartViewController = [[TempChartViewController alloc]initWithNibName:@"TempChartViewController" bundle:nil];
//    [self.navigationController pushViewController:tempChartViewController animated:YES];
}

-(void)updateListViewData
{
    if([_nowDataType isEqualToString:@"weight"])
    {
        _dataArray = _weightDataArray;
    }
    else if([_nowDataType isEqualToString:@"bodyfat"])
    {
        _dataArray = _bodyfatDataArray;
    }
    else if([_nowDataType isEqualToString:@"bloodpress"])
    {
        _dataArray = _bloodpressDataArray;
    }
    else if([_nowDataType isEqualToString:@"temperature"])
    {
        _dataArray = _temperatrueDataArray;
    }
    
    [_myTableView reloadData];
    _myTableView.separatorInset = UIEdgeInsetsZero;
}

-(IBAction)weightBtnPressed:(id)sender
{
    _nowDataType = @"weight";
    [self updateListViewData];
    
    [_weightBtn setBackgroundColor:[UIColor lightGrayColor]];
    [_bloodPressureBtn setBackgroundColor:[UIColor darkGrayColor]];
    [_bodyFatBtn setBackgroundColor:[UIColor darkGrayColor]];
    [_temperatureBtn setBackgroundColor:[UIColor darkGrayColor]];
}

-(IBAction)bodyfatBtnPressed:(id)sender
{
    _nowDataType = @"bodyfat";
    [self updateListViewData];
    
    [_weightBtn setBackgroundColor:[UIColor darkGrayColor]];
    [_bloodPressureBtn setBackgroundColor:[UIColor darkGrayColor]];
    [_bodyFatBtn setBackgroundColor:[UIColor lightGrayColor]];
    [_temperatureBtn setBackgroundColor:[UIColor darkGrayColor]];
}

-(IBAction)bloodpressBtnPressed:(id)sender
{
    _nowDataType = @"bloodpress";
    [self updateListViewData];
    
    [_weightBtn setBackgroundColor:[UIColor darkGrayColor]];
    [_bloodPressureBtn setBackgroundColor:[UIColor lightGrayColor]];
    [_bodyFatBtn setBackgroundColor:[UIColor darkGrayColor]];
    [_temperatureBtn setBackgroundColor:[UIColor darkGrayColor]];
}

-(IBAction)temperatureBtnPressed:(id)sender
{
    _nowDataType = @"temperature";
    [self updateListViewData];
    
    [_weightBtn setBackgroundColor:[UIColor darkGrayColor]];
    [_bloodPressureBtn setBackgroundColor:[UIColor darkGrayColor]];
    [_bodyFatBtn setBackgroundColor:[UIColor darkGrayColor]];
    [_temperatureBtn setBackgroundColor:[UIColor lightGrayColor]];
}

-(void)getDataFromCloud
{
    [self getWeightDataFromCloud:50];
    [self getTemperatureDataFromCloud:50];
    [self getBloodPressureDataFromCloud:50];
    [self getFatDataFromCloud:50];
}

-(void)getWeightDataFromCloud:(int)number
{
    //获取最近的体重例句
    //http://localhost:8080/service/ehealth_getLatelyWeightData?authkey=ZGJiNzAwOTYyYTc1NDBlNWIzYTY1MzgyM2U5N2NlNzEjMjAxMy0xMS0xMiAxMzo0MzowMSMzMCN6%0D%0AaF9DTg%3D%3D&requestnum=1&dtype=30
    NSString *authkey = [[MySingleton sharedSingleton].nowuserinfo valueForKey:@"AuthKey"];
    NSString *url = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_getLatelyWeightData?authkey=%@&requestnum=%d&dtype=30",authkey,number];
    NSDictionary *dic = [ServerConnect getDictionaryByUrl:url];
//    NSArray *weightdataArray = [[NSArray alloc]init];
    if([[dic valueForKey:@"weightdata"] isKindOfClass:[NSArray class]])
    {
        _weightDataArray = (NSMutableArray *)[dic valueForKey:@"weightdata"];
        
        [[MySingleton sharedSingleton].nowuserinfo setObject:_weightDataArray forKey:@"UserWeightDataArray"];
        
//        NSLog(@"建议: %@",[dicweightdataArray0 valueForKey:@"advice"]);
//        NSLog(@"日期: %@",[dicweightdataArray0 valueForKey:@"date"]);
//        NSLog(@"结果: %@",[dicweightdataArray0 valueForKey:@"result"]);
//        NSLog(@"分享id: %@",[dicweightdataArray0 valueForKey:@"shareid"]);
//        NSLog(@"值: %@",[dicweightdataArray0 valueForKey:@"value"]);
//        
//        if([[dicweightdataArray0 valueForKey:@"advice"] isKindOfClass:[NSDictionary class]])
//        {
//            NSDictionary *dicAdvice = (NSDictionary *)[dicweightdataArray0 valueForKey:@"advice"];
//            NSLog(@"commSuggestion: %@",[dicAdvice valueForKey:@"commSuggestion"]);
//            NSLog(@"doctorSuggestion: %@",[dicAdvice valueForKey:@"doctorSuggestion"]);
//            NSLog(@"foodSuggestion: %@",[dicAdvice valueForKey:@"foodSuggestion"]);
//            NSLog(@"sportSuggestion: %@",[dicAdvice valueForKey:@"sportSuggestion"]);
//        }
    }
    
}
    
    
-(void)getFatDataFromCloud:(int)number
{
    //获取最近放入体成分
    //http://localhost:8080/service/ehealth_getLatelyBodyCompositionData?authkey=ZGJiNzAwOTYyYTc1NDBlNWIzYTY1MzgyM2U5N2NlNzEjMjAxMy0xMS0xMiAxMzo0MzowMSMzMCN6%0D%0AaF9DTg%3D%3D&requestnum=1&dtype=30
    
    NSString *authkey = [[MySingleton sharedSingleton].nowuserinfo valueForKey:@"AuthKey"];
    NSString *url = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_getLatelyBodyCompositionData?authkey=%@&requestnum=%d&dtype=30",authkey,number];
    NSDictionary *dic = [ServerConnect getLastData:url];
//    NSArray *bodyFatDataArray = [[NSArray alloc]init];
    if([[dic valueForKey:@"bodycompositiondata"] isKindOfClass:[NSArray class]])
    {
        _bodyfatDataArray = (NSMutableArray *)[dic valueForKey:@"bodycompositiondata"];
        
        [[MySingleton sharedSingleton].nowuserinfo setObject:_bodyfatDataArray forKey:@"UserBodyFatDataArray"];
        
//        NSLog(@"%@",bodyFatDataArray);
//        
//        _bodyfatDataArray = bodyFatDataArray[0];
        
//        NSLog(@"日期: %@",[dicdataArray0 valueForKey:@"date"]);
//        NSLog(@"结果: %@",[dicdataArray0 valueForKey:@"result"]);
//        NSLog(@"分享id: %@",[dicdataArray0 valueForKey:@"shareid"]);
//        NSLog(@"肌肉量: %@",[dicdataArray0 valueForKey:@"muscle_value"]);
//        NSLog(@"脂肪率: %@",[dicdataArray0 valueForKey:@"adiposerate_value"]);
//        NSLog(@"内脂肪等级: %@",[dicdataArray0 valueForKey:@"visceralfat_value"]);
//        NSLog(@"水分: %@",[dicdataArray0 valueForKey:@"moisture_value"]);
//        NSLog(@"骨量: %@",[dicdataArray0 valueForKey:@"bone"]);
//        NSLog(@"基础代谢: %@",[dicdataArray0 valueForKey:@"thermal"]);
//        NSLog(@"阻抗: %@",[dicdataArray0 valueForKey:@"impedance"]);
//        NSLog(@"BMI: %@",[dicdataArray0 valueForKey:@"bmi"]);
//        
//        
//        if([[dicdataArray0 valueForKey:@"advice"] isKindOfClass:[NSDictionary class]])
//        {
//            NSDictionary *dicAdvice = (NSDictionary *)[dicdataArray0 valueForKey:@"advice"];
//            NSLog(@"commSuggestion: %@",[dicAdvice valueForKey:@"commSuggestion"]);
//            NSLog(@"doctorSuggestion: %@",[dicAdvice valueForKey:@"doctorSuggestion"]);
//            NSLog(@"foodSuggestion: %@",[dicAdvice valueForKey:@"foodSuggestion"]);
//            NSLog(@"sportSuggestion: %@",[dicAdvice valueForKey:@"sportSuggestion"]);
//        }
//        
//        bodyFatDataLabel.text =[dicdataArray0 valueForKey:@"adiposerate_value"];
    }
    
    
    NSLog(@"%@",dic);
}

-(void)getBloodPressureDataFromCloud:(int)number
{
    //获取最近的血压
    //http://localhost:8080/service/ehealth_getLatelyBloodPressureData?authkey=ZGJiNzAwOTYyYTc1NDBlNWIzYTY1MzgyM2U5N2NlNzEjMjAxMy0xMS0xMiAxMzo0MzowMSMzMCN6%0D%0AaF9DTg%3D%3D&requestnum=1&dtype=30
    
    NSString *authkey = [[MySingleton sharedSingleton].nowuserinfo valueForKey:@"AuthKey"];
    NSString *url = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_getLatelyBloodPressureData?authkey=%@&requestnum=%d&dtype=30",authkey,number];
    NSDictionary *dic = [ServerConnect getLastData:url];
    
//    NSArray *bloodPressureDataArray = [[NSArray alloc]init];
    if([[dic valueForKey:@"bloodpressuredata"] isKindOfClass:[NSArray class]])
    {
        _bloodpressDataArray = (NSMutableArray *)[dic valueForKey:@"bloodpressuredata"];
        
        [[MySingleton sharedSingleton].nowuserinfo setObject:_bloodpressDataArray forKey:@"UserBloodpressDataArray"];
        
//        NSLog(@"%@",bloodPressureDataArray);
//        
//        NSDictionary *dicweightdataArray0 = bloodPressureDataArray[0];
//        NSLog(@"建议: %@",[dicweightdataArray0 valueForKey:@"advice"]);
//        NSLog(@"日期: %@",[dicweightdataArray0 valueForKey:@"date"]);
//        NSLog(@"结果: %@",[dicweightdataArray0 valueForKey:@"result"]);
//        NSLog(@"分享id: %@",[dicweightdataArray0 valueForKey:@"shareid"]);
//        NSLog(@"收缩压: %@",[dicweightdataArray0 valueForKey:@"systolic"]);
//        NSLog(@"舒张压: %@",[dicweightdataArray0 valueForKey:@"diastolic"]);
//        NSLog(@"脉搏: %@",[dicweightdataArray0 valueForKey:@"pulse"]);
//        
//        if([[dicweightdataArray0 valueForKey:@"advice"] isKindOfClass:[NSDictionary class]])
//        {
//            NSDictionary *dicAdvice = (NSDictionary *)[dicweightdataArray0 valueForKey:@"advice"];
//            NSLog(@"commSuggestion: %@",[dicAdvice valueForKey:@"commSuggestion"]);
//            NSLog(@"doctorSuggestion: %@",[dicAdvice valueForKey:@"doctorSuggestion"]);
//            NSLog(@"foodSuggestion: %@",[dicAdvice valueForKey:@"foodSuggestion"]);
//            NSLog(@"sportSuggestion: %@",[dicAdvice valueForKey:@"sportSuggestion"]);
//        }
//        
//        //设置界面的血压数据
//        bloodPressDataLabel.text = [[NSString alloc]initWithFormat:@"%@/%@",[dicweightdataArray0 valueForKey:@"diastolic"],[dicweightdataArray0 valueForKey:@"systolic"]];
//        bloodPressResultLabel.text = [dicweightdataArray0 valueForKey:@"result"];
    }
    
    
    NSLog(@"%@",dic);
}

-(void)getTemperatureDataFromCloud:(int)number
{
    //http://www.ebelter.com/service/ehealth_getLatelyTemperatureData?authkey=NjU1YjNlNjNjMTVjNDliZWJhNzc4ZDBmNzdkMGY3YjUjMjAxNC0wMy0yNiAxODoxMTo0MyMzMCN6%0AaF9DTg%3D%3D&requestnum=1&dtype=30
    
    NSString *authkey = [[MySingleton sharedSingleton].nowuserinfo valueForKey:@"AuthKey"];
    NSString *url = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_getLatelyTemperatureData?authkey=%@&requestnum=%d&dtype=30",authkey,number];
    NSDictionary *dic = [ServerConnect getLastData:url];
    
//    NSArray *temperatureDataArray = [[NSArray alloc]init];
    if([[dic valueForKey:@"temperaturedata"] isKindOfClass:[NSArray class]])
    {
        _temperatrueDataArray = (NSMutableArray *)[dic valueForKey:@"temperaturedata"];
        
        [[MySingleton sharedSingleton].nowuserinfo setObject:_temperatrueDataArray forKey:@"UserTemperatureDataArray"];
//        NSLog(@"%@",temperatureDataArray);
//        
//        NSDictionary *dicweightdataArray0 = temperatureDataArray[0];
//        
//        NSLog(@"日期: %@",[dicweightdataArray0 valueForKey:@"date"]);
//        NSLog(@"脉搏: %@",[dicweightdataArray0 valueForKey:@"value"]);
//        
//        if([[dicweightdataArray0 valueForKey:@"advice"] isKindOfClass:[NSDictionary class]])
//        {
//            NSDictionary *dicAdvice = (NSDictionary *)[dicweightdataArray0 valueForKey:@"advice"];
//            NSLog(@"commSuggestion: %@",[dicAdvice valueForKey:@"commSuggestion"]);
//            NSLog(@"doctorSuggestion: %@",[dicAdvice valueForKey:@"doctorSuggestion"]);
//            NSLog(@"foodSuggestion: %@",[dicAdvice valueForKey:@"foodSuggestion"]);
//            NSLog(@"sportSuggestion: %@",[dicAdvice valueForKey:@"sportSuggestion"]);
//        }
//
//        //设置界面的血压数据
//        _temperatureDataLabel.text = [[NSString alloc]initWithFormat:@"%@",[dicweightdataArray0 valueForKey:@"value"]];
//        _temperatureResultLabel.text = [dicweightdataArray0 valueForKey:@"result"];
    }
    
}

-(void)showChartView
{
    ChartViewController *chartViewController = [[ChartViewController alloc]initWithNibName:@"ChartViewController" bundle:nil];
    
    [self.navigationController pushViewController:chartViewController animated:YES];
}
@end
