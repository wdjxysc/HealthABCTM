//
//  HistoryViewControllerTM.m
//  HealthABC
//
//  Created by 夏 伟 on 14-4-25.
//  Copyright (c) 2014年 夏 伟. All rights reserved.
//

#import "HistoryViewControllerTM.h"
#import "TempDataTableViewCell.h"
#import "BodyFatTableViewCell.h"
#import "WeightTableViewCell.h"
#import "BloodPressTableViewCell.h"
#import "MySingleton.h"
#import "ServerConnect.h"
#import "NSDate+Additions.h"


#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define Screen_height   [[UIScreen mainScreen] bounds].size.height
#define Screen_width    [[UIScreen mainScreen] bounds].size.width

@interface HistoryViewControllerTM ()
@property (weak, nonatomic) IBOutlet UIButton *weightBtn;
@property (weak, nonatomic) IBOutlet UIButton *bodyfatBtn;
@property (weak, nonatomic) IBOutlet UIButton *bloodpressBtn;
@property (weak, nonatomic) IBOutlet UIButton *temperatureBtn;
@property (weak, nonatomic) IBOutlet UIButton *dayBtn;
@property (weak, nonatomic) IBOutlet UIButton *weekBtn;
@property (weak, nonatomic) IBOutlet UIButton *monthBtn;

@end

@implementation HistoryViewControllerTM
@synthesize myTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.title = NSLocalizedString(@"HISTORY", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"TM_history"];
        
        self.navigationItem.title = NSLocalizedString(@"HISTORY", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initMyView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self getDataFromCloud];
    [self updateListViewData];
//    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(getDataFromCloud) object:nil];
//    [thread start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initMyView
{
    
    CGRect frame;
    if(iPhone5)
    {
        frame = CGRectMake(10, 168, 300, 262 + 85);
    }
    else
    {
        frame = CGRectMake(10, 168, 300, 262);
    }
    
    if(myTableView != nil)
        [myTableView removeFromSuperview];
    myTableView = [[UITableView alloc]initWithFrame:frame];
    [self.view addSubview:myTableView];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.delegate = self;
    myTableView.dataSource = self;
//    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
//    [_weightBtn setTitle:NSLocalizedString(@"MEASURE_TYPE_WEIGHT", nil)  forState:UIControlStateNormal];
//    [_bodyfatBtn setTitle:NSLocalizedString(@"MEASURE_TYPE_BODYFAT", nil) forState:UIControlStateNormal];
//    [_bloodpressBtn setTitle:NSLocalizedString(@"MEASURE_TYPE_BLOODPRESSURE", nil) forState:UIControlStateNormal];
//    [_temperatureBtn setTitle:NSLocalizedString(@"MEASURE_TYPE_TEMPERATURE", nil) forState:UIControlStateNormal];
    
    
    [_weightBtn addTarget:self action:@selector(weightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_bodyfatBtn addTarget:self action:@selector(bodyfatBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_bloodpressBtn addTarget:self action:@selector(bloodpressBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_temperatureBtn addTarget:self action:@selector(temperatureBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_dayBtn setBackgroundImage:[UIImage imageNamed:@"TM_tab_nianyueri_item_down" ] forState:UIControlStateNormal];
    [_weekBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [_monthBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [_dayBtn addTarget:self action:@selector(dayBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [_weekBtn addTarget:self action:@selector(weekBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [_monthBtn addTarget:self action:@selector(monthBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    _weightDataArray = [[NSMutableArray alloc]init];
    _bodyfatDataArray = [[NSMutableArray alloc]init];
    _bloodpressDataArray = [[NSMutableArray alloc]init];
    _temperatrueDataArray = [[NSMutableArray alloc]init];
    
    _nowDataType = @"weight";
    [self dayBtnPressed];
}

-(void)dayBtnPressed
{
    _nowTimeType = @"day";
    [_dayBtn setBackgroundImage:[UIImage imageNamed:@"TM_tab_nianyueri_item_down" ] forState:UIControlStateNormal];
    [_weekBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [_monthBtn setBackgroundImage:nil forState:UIControlStateNormal];
    
    [self getDataFromCloud];
    [self updateListViewData];
}

-(void)weekBtnPressed
{
    _nowTimeType = @"week";
    [_dayBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [_weekBtn setBackgroundImage:[UIImage imageNamed:@"TM_tab_nianyueri_item_down" ] forState:UIControlStateNormal];
    [_monthBtn setBackgroundImage:nil forState:UIControlStateNormal];
    
    [self getDataFromCloud];
    [self updateListViewData];
}

-(void)monthBtnPressed
{
    _nowTimeType = @"month";
    [_dayBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [_weekBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [_monthBtn setBackgroundImage:[UIImage imageNamed:@"TM_tab_nianyueri_item_down" ] forState:UIControlStateNormal];
    
    [self getDataFromCloud];
    [self updateListViewData];
}

-(IBAction)weightBtnPressed:(id)sender
{
    _nowDataType = @"weight";
    [self updateListViewData];
    
    [_weightBtn setBackgroundImage:[UIImage imageNamed:@"TM_history_btn_select"] forState:UIControlStateNormal];
    [_bloodpressBtn setBackgroundImage:[UIImage imageNamed:@"TM_history_btn_normal"] forState:UIControlStateNormal];
    [_bodyfatBtn setBackgroundImage:[UIImage imageNamed:@"TM_history_btn_normal"] forState:UIControlStateNormal];
    [_temperatureBtn setBackgroundImage:[UIImage imageNamed:@"TM_history_btn_normal"] forState:UIControlStateNormal];
}

-(IBAction)bodyfatBtnPressed:(id)sender
{
    _nowDataType = @"bodyfat";
    [self updateListViewData];
    
    [_weightBtn setBackgroundImage:[UIImage imageNamed:@"TM_history_btn_normal"] forState:UIControlStateNormal];
    [_bloodpressBtn setBackgroundImage:[UIImage imageNamed:@"TM_history_btn_normal"] forState:UIControlStateNormal];
    [_bodyfatBtn setBackgroundImage:[UIImage imageNamed:@"TM_history_btn_select"] forState:UIControlStateNormal];
    [_temperatureBtn setBackgroundImage:[UIImage imageNamed:@"TM_history_btn_normal"] forState:UIControlStateNormal];
}

-(IBAction)bloodpressBtnPressed:(id)sender
{
    _nowDataType = @"bloodpress";
    [self updateListViewData];
    
    [_weightBtn setBackgroundImage:[UIImage imageNamed:@"TM_history_btn_normal"] forState:UIControlStateNormal];
    [_bloodpressBtn setBackgroundImage:[UIImage imageNamed:@"TM_history_btn_select"] forState:UIControlStateNormal];
    [_bodyfatBtn setBackgroundImage:[UIImage imageNamed:@"TM_history_btn_normal"] forState:UIControlStateNormal];
    [_temperatureBtn setBackgroundImage:[UIImage imageNamed:@"TM_history_btn_normal"] forState:UIControlStateNormal];
}

-(IBAction)temperatureBtnPressed:(id)sender
{
    _nowDataType = @"temperature";
    [self updateListViewData];
    
    [_weightBtn setBackgroundImage:[UIImage imageNamed:@"TM_history_btn_normal"] forState:UIControlStateNormal];
    [_bloodpressBtn setBackgroundImage:[UIImage imageNamed:@"TM_history_btn_normal"] forState:UIControlStateNormal];
    [_bodyfatBtn setBackgroundImage:[UIImage imageNamed:@"TM_history_btn_normal"] forState:UIControlStateNormal];
    [_temperatureBtn setBackgroundImage:[UIImage imageNamed:@"TM_history_btn_select"] forState:UIControlStateNormal];
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
    
    [myTableView reloadData];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        myTableView.separatorInset = UIEdgeInsetsZero;
    }
}

-(void)getDataFromCloud
{
    
    NSDate *date = [NSDate date];
    
    if([_nowTimeType isEqualToString:@"day"])
    {
        date = [date dateByAddingDays:-1];
    }
    else if ([_nowTimeType isEqualToString:@"week"])
    {
        date = [date dateByAddingDays:-7];
    }
    else if([_nowTimeType isEqualToString:@"month"])
    {
        date = [date dateByAddingDays:-30];
    }
    
    _weightDataArray = [self getArrayBetweenFromArray:[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"UserWeightDataArray"] begintime:date endtime:[NSDate date]];
    _bodyfatDataArray = [self getArrayBetweenFromArray:[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"UserBodyFatDataArray"] begintime:date endtime:[NSDate date]];
    _bloodpressDataArray = [self getArrayBetweenFromArray:[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"UserBloodpressDataArray"] begintime:date endtime:[NSDate date]];
    _temperatrueDataArray = [self getArrayBetweenFromArray:[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"UserTemperatureDataArray"] begintime:date endtime:[NSDate date]];
    
//    [self getWeightDataFromCloud:date];
//    [self getTemperatureDataFromCloud:date];
//    [self getBloodPressureDataFromCloud:date];
//    [self getFatDataFromCloud:date];
}


-(void)getWeightDataFromCloud:(NSDate *)starttime
{
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    [fomatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timestr = [fomatter stringFromDate:starttime];
    //体重获取数据
    //http://www.ebelter.com/service/ehealth_getAllWeightData?authkey=NzQ0MzQ4ODAxNzdjNGRiYWFmNWRiMGUyNDk4YmE1NGMjMjAxMy0wNy0wMSAwOToyNTozNyMxOCN6%0AaF9DTg%3D%3D&startdate=2013-06-01%2000:00:00
    NSString *authkey = [[MySingleton sharedSingleton].nowuserinfo valueForKey:@"AuthKey"];
    NSString *url = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_getAllWeightData?authkey=%@&startdate=%@",authkey,timestr];
    NSDictionary *dic = [ServerConnect getDictionaryByUrl:url];
    //    NSArray *weightdataArray = [[NSArray alloc]init];
    if([[dic valueForKey:@"weightdata"] isKindOfClass:[NSArray class]])
    {
        _weightDataArray = (NSMutableArray *)[dic valueForKey:@"weightdata"];
        
        if(_weightDataArray != nil){
            [[MySingleton sharedSingleton].nowuserinfo setObject:_weightDataArray forKey:@"UserWeightDataArray"];
        }
        
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


-(void)getFatDataFromCloud:(NSDate *)starttime
{
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    [fomatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timestr = [fomatter stringFromDate:starttime];
    //脂肪秤获取数据
    //http://www.ebelter.com/service/ehealth_getAllBodyCompositionData?authkey=NzQ0MzQ4ODAxNzdjNGRiYWFmNWRiMGUyNDk4YmE1NGMjMjAxMy0wNi0yOCAxNjo1OTowNSMxOCN6%0AaF9DTg%3D%3D&startdate=2012-02-11%2001:52:00
    
    NSString *authkey = [[MySingleton sharedSingleton].nowuserinfo valueForKey:@"AuthKey"];
    NSString *url = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_getAllBodyCompositionData?authkey=%@&startdate=%@",authkey,timestr];
    NSDictionary *dic = [ServerConnect getLastData:url];
    //    NSArray *bodyFatDataArray = [[NSArray alloc]init];
    if([[dic valueForKey:@"bodyCompositondata"] isKindOfClass:[NSArray class]])
    {
        _bodyfatDataArray = (NSMutableArray *)[dic valueForKey:@"bodyCompositondata"];
        
        if(_bodyfatDataArray != nil){
            [[MySingleton sharedSingleton].nowuserinfo setObject:_bodyfatDataArray forKey:@"UserBodyFatDataArray"];
        }
        
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

-(void)getBloodPressureDataFromCloud:(NSDate *)starttime
{
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    [fomatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timestr = [fomatter stringFromDate:starttime];
    
    //血压计获取数据
    //http://www.ebelter.com/service/ehealth_getAllBloodPressureData?authkey=NzQ0MzQ4ODAxNzdjNGRiYWFmNWRiMGUyNDk4YmE1NGMjMjAxMy0wNi0yOCAxNjo1OTowNSMxOCN6%0AaF9DTg%3D%3D&startdate=2013-06-01%2000:00:00
    
    NSString *authkey = [[MySingleton sharedSingleton].nowuserinfo valueForKey:@"AuthKey"];
    NSString *url = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_getAllBloodPressureData?authkey=%@&startdate=%@",authkey,timestr];
    NSDictionary *dic = [ServerConnect getLastData:url];
    
    //    NSArray *bloodPressureDataArray = [[NSArray alloc]init];
    if([[dic valueForKey:@"bloodPressData"] isKindOfClass:[NSArray class]])
    {
        _bloodpressDataArray = (NSMutableArray *)[dic valueForKey:@"bloodPressData"];
        
        if(_bloodpressDataArray != nil){
            [[MySingleton sharedSingleton].nowuserinfo setObject:_bloodpressDataArray forKey:@"UserBloodpressDataArray"];
        }
        
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

-(void)getTemperatureDataFromCloud:(NSDate *)starttime
{
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    [fomatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timestr = [fomatter stringFromDate:starttime];
    //体温获取数据 (异常 ，有返回，无数据)
    //http://www.ebelter.com/service/ehealth_getAllTempretureData?authkey=ZWUxYWQ0YzJmZWEyNDAwYWI5N2FlYmMyNzRkOWVlYmEjMjAxNC0wNC0yOCAxNzowMDowMiMzMCN6%0D%0AaF9DTg%3D%3D&startdate=2013-06-01%2000:00:00
    
    NSString *authkey = [[MySingleton sharedSingleton].nowuserinfo valueForKey:@"AuthKey"];
    NSString *url = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_getAllTempretureData?authkey=%@&startdate=%@",authkey,timestr];
    NSDictionary *dic = [ServerConnect getLastData:url];
    
    //    NSArray *temperatureDataArray = [[NSArray alloc]init];
    if([[dic valueForKey:@"temperaturedata"] isKindOfClass:[NSArray class]])
    {
        _temperatrueDataArray = (NSMutableArray *)[dic valueForKey:@"temperaturedata"];
        
        if(_temperatrueDataArray != nil){
            [[MySingleton sharedSingleton].nowuserinfo setObject:_temperatrueDataArray forKey:@"UserTemperatureDataArray"];
        }
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






//@program tableview delegate

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
        cell.dataLabel.text = [[NSString alloc] initWithFormat:@"%.1f",[[rowData objectForKey:@"temperature"] floatValue]];
        
        
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
        
        cell.weightDataLabel.text = [[NSString alloc] initWithFormat:@"%.1f",[[rowData objectForKey:@"weight"] floatValue]];
        
        
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
        
        cell.weightDataLabel.text = [[NSString alloc] initWithFormat:@"%.1fkg",[[rowData objectForKey:@"weight"] floatValue]];
        cell.bodyfatDataLabel.text = [[NSString alloc] initWithFormat:@"%.1f%%",[[rowData objectForKey:@"adiposerate"] floatValue]];
        cell.muscleDataLabel.text = [[NSString alloc] initWithFormat:@"%.1f%%",[[rowData objectForKey:@"muscle"] floatValue]];
        cell.waterDataLabel.text = [[NSString alloc] initWithFormat:@"%.1f%%",[[rowData objectForKey:@"moisture"] floatValue]];
        cell.boneDataLabel.text = [[NSString alloc] initWithFormat:@"%.1fkg",[[rowData objectForKey:@"bone"] floatValue]];
        cell.visfatDataLabel.text = [[NSString alloc] initWithFormat:@"%d",[[rowData objectForKey:@"visceralfat"] intValue]];
        cell.bmiDataLabel.text = [[NSString alloc] initWithFormat:@"%.1f",[[rowData objectForKey:@"bmi"] floatValue]];
        if([rowData objectForKey:@"thermal"] != nil){
            cell.kcalDataLabel.text = [[NSString alloc] initWithFormat:@"%dkcal",[[rowData objectForKey:@"thermal"] intValue]];
        }
        else
        {
            cell.kcalDataLabel.text = [[NSString alloc] initWithFormat:@"%@kcal",@"0"];
        }
        
        
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
        
        cell.sysDataLabel.text = [[NSString alloc] initWithFormat:@"%d mmHg",[[rowData objectForKey:@"systolic"] intValue]];
        cell.diaDataLabel.text = [[NSString alloc] initWithFormat:@"%d mmHg",[[rowData objectForKey:@"diastolic"] intValue]];
        cell.pulseDataLabel.text = [[NSString alloc] initWithFormat:@"%d",[[rowData objectForKey:@"pulse"] intValue]];
        
        
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
        result = 110.0f;
    }
    else if([_nowDataType isEqualToString:@"bloodpress"])
    {
        result = 82.0f;
    }
    
    return result;
    //    return roundf(50);
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
        for(int i = 0; i<array.count; i++)
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

@end
