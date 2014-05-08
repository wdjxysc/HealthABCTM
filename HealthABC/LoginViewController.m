//
//  LoginViewController.m
//  HealthABC
//
//  Created by 夏 伟 on 13-11-21.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import "LoginViewController.h"
#import "REFrostedViewController.h"
#import "DEMONavigationController.h"
#import "ChooseItemViewController.h"
#import "DEMOMenuViewController.h"
#import "MySingleton.h"
#import "ServerConnect.h"
#import "RegistEmailViewController.h"
#import "ChangPasswordViewController.h"
#import "SVProgressHUD.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPassword;

@end

@implementation LoginViewController

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
    [MySingleton sharedSingleton].serverDomain = @"www.ebelter.com"; //设置服务器地址
    [self initApp];
    [self initMyView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
    
    [textField resignFirstResponder];
}

-(IBAction)DidEndOnExit:(id)sender
{
    [sender resignFirstResponder];
}

//滑动  textfield 不让软键盘盖住
- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    int movementDistance = 80; // tweak as needed
//    int mo = textField.bounds.origin.y;
//    int mi = textField.bounds.size.height;
//    int me = textField.frame.origin.y;
    
    int screenheight = self.view.frame.size.height;
    int tobottom = screenheight - textField.frame.origin.y - textField.frame.size.height;
    movementDistance = 300-tobottom + 10;
    const float movementDuration = 0.3f; // tweak as needed
    
    if(movementDistance>0){
    
        int movement = (up ? -movementDistance : movementDistance);
    
        [UIView beginAnimations: @"anim" context: nil];
    
        [UIView setAnimationBeginsFromCurrentState: YES];
    
        [UIView setAnimationDuration: movementDuration];
    
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    
        [UIView commitAnimations];
    }
}

-(IBAction)LoginBtnPressed:(id)sender
{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"PLEASE_WAITTING", nil)];
//    [SVProgressHUD showWithStatus:@"请稍候..."];
    
    NSString *username = usernameLoginTextField.text;
    NSString *password = passwordLoginTextField.text;
    NSString *urlLogin = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_userLogin?username=%@&pwd=%@&dtype=30",username,password];
    
    NSString *res = [ServerConnect Login:urlLogin];
    if([res isEqualToString:@"0"])
    {
        //登陆成功
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"LOGIN_SUCCESS", nil)];
//        [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        [[MySingleton sharedSingleton].nowuserinfo setValue:username forKey:@"UserName"];
        //获取用户信息
        NSString *urlGetUserInfo = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_getUserInfo?authkey=%@&time=2013-11-26 15:53:30",[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"AuthKey"]];
        
        NSDictionary *dic = [ServerConnect getUserInfo:urlGetUserInfo];
        NSLog(@"dic = %@",dic);
        
        [MySingleton sharedSingleton].isLogined = YES;
        //跳转界面
        DEMONavigationController *navigationController = [[DEMONavigationController alloc] initWithRootViewController:[[ChooseItemViewController alloc] init]];
        
        UIImage *navBarImage = [UIImage imageNamed:@"ui_top.jpg"];
        UIView *navigationbaritembackgroundView=[[UIImageView alloc] initWithImage:navBarImage];
        [self.navigationController.navigationBar insertSubview:navigationbaritembackgroundView atIndex:1];//
        
        //    navigationController.navigationBar insertSubview:navigationbaritembackgroundView aboveSubview:<#(UIView *)#>
        
        //    navigationController.navigationBar.barTintColor = [UIColor colorWithRed:99.0f green:228.0f blue:97.0f alpha:0.5f];
        DEMOMenuViewController *menuController = [[DEMOMenuViewController alloc] initWithStyle:UITableViewStylePlain];
        
        REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
        frostedViewController.direction = REFrostedViewControllerDirectionLeft;
        frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
        [self presentViewController:frostedViewController animated:YES completion:^{//备注2
            NSLog(@"show InfoView!");
        }];
    }
    else
    {
//        [SVProgressHUD showErrorWithStatus:@"登录失败"];
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"LOGIN_FAILED", nil)];
    }
}

-(IBAction)goregistBtnPressed:(id)sender
{
    RegistEmailViewController *registEmailViewController = [[RegistEmailViewController alloc]initWithNibName:@"RegistEmailViewController" bundle:nil];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:registEmailViewController];
    [self presentViewController:navi animated:YES completion:nil];
}

-(IBAction)fogetBtnPressed:(id)sender
{
    ChangPasswordViewController *changPasswordViewController = [[ChangPasswordViewController alloc]initWithNibName:@"ChangPasswordViewController" bundle:nil];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:changPasswordViewController];
    [self presentViewController:navi animated:YES completion:nil];
}

-(IBAction)testBtnPressed:(id)sender
{
    NSMutableDictionary *datadic = [[NSMutableDictionary alloc] init];
    [datadic setObject:@"2014-03-06 12:25:56" forKey:@"TestTime"];
    [datadic setObject:@"56.1" forKey:@"Weight"];
    [datadic setObject:@"37.1" forKey:@"temperature"];
    [datadic setObject:@"152" forKey:@"SYS"];
    [datadic setObject:@"89" forKey:@"DIA"];
    [datadic setObject:@"76" forKey:@"Pulse"];
    [datadic setObject:@"56.1" forKey:@"Fat"];
    [datadic setObject:@"65.1" forKey:@"Water"];
    [datadic setObject:@"36.1" forKey:@"Muscle"];
    [datadic setObject:@"10" forKey:@"VisceralFat"];
    [datadic setObject:@"3.1" forKey:@"Bone"];
    [datadic setObject:@"1456" forKey:@"BMR"];
    [datadic setObject:@"23.5" forKey:@"BMI"];
    [datadic setObject:@"56.1" forKey:@"temperature"];
    
    NSDictionary *resultdic = [ServerConnect uploadWeightData:datadic authkey:@"NjU1YjNlNjNjMTVjNDliZWJhNzc4ZDBmNzdkMGY3YjUjMjAxNC0wMy0zMSAxMTowNzozMyMzMCN6%0AaF9DTg%3D%3D"];
    NSLog(@"%@",resultdic);
    
    NSDictionary *bodyfatresultdic = [ServerConnect uploadBodyFatData:datadic authkey:@"NjU1YjNlNjNjMTVjNDliZWJhNzc4ZDBmNzdkMGY3YjUjMjAxNC0wMy0zMSAxMTowNzozMyMzMCN6%0AaF9DTg%3D%3D"];
    NSLog(@"%@",bodyfatresultdic);
    
    NSDictionary *bloodpressresultdic = [ServerConnect uploadBloodPressureData:datadic authkey:@"NjU1YjNlNjNjMTVjNDliZWJhNzc4ZDBmNzdkMGY3YjUjMjAxNC0wMy0zMSAxMTowNzozMyMzMCN6%0AaF9DTg%3D%3D"];
    NSLog(@"%@",bloodpressresultdic);
    
    NSDictionary *temperatureresultdic = [ServerConnect uploadTemperatureData:datadic authkey:@"NjU1YjNlNjNjMTVjNDliZWJhNzc4ZDBmNzdkMGY3YjUjMjAxNC0wMy0zMSAxMTowNzozMyMzMCN6%0AaF9DTg%3D%3D"];
    NSLog(@"%@",temperatureresultdic);
    
    
    NSString *url = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_getLatelyBodyCompositionData?authkey=NjU1YjNlNjNjMTVjNDliZWJhNzc4ZDBmNzdkMGY3YjUjMjAxMy0xMi0xNiAxODowMzoxNSMzMCN6%%0AaF9DTg%%3D%%3D&requestnum=1&dtype=30"];
    
    //{"bloodpressuredata":[{"date":"2013-11-05 06:16:42","systolic":"109","diastolic":"66","pulse":"71","result":"理想血压","advice":{"foodSuggestion":"营养要均衡，多进食一些高蛋白食品，如鱼、鸡蛋、牛奶等。","sportSuggestion":"将有氧运动与力量练习结合起来，每周做力量练习3次，每次30分钟，有氧运动控制在1个小时左右。","doctorSuggestion":"可选择疏肝健脾的食疗养生方，如芹菜粥，即取芹菜连根120g，粳米250g，先将芹菜洗净，切成六分长的段，粳米淘净，芹菜，粳米放入锅内，加清水适量，用武火烧沸后转","commSuggestion":"注意劳逸结合，及时补充足够的水。"},"shareid":"null"}],"arraylength":1}
    NSDictionary *dic = [ServerConnect getLastData:url];
    NSArray *bodyFatDataArray = [[NSArray alloc]init];
    if([[dic valueForKey:@"bodycompositiondata"] isKindOfClass:[NSArray class]])
    {
        bodyFatDataArray = (NSArray *)[dic valueForKey:@"bodycompositiondata"];
        
        NSLog(@"%@",bodyFatDataArray);
        
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
    }

    
    
    
    /*获取血压最近一次数据
    NSString *url = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_getLatelyBloodPressureData?authkey=NjU1YjNlNjNjMTVjNDliZWJhNzc4ZDBmNzdkMGY3YjUjMjAxMy0xMi0xNiAxODowMzoxNSMzMCN6%%0AaF9DTg%%3D%%3D&requestnum=1&dtype=30"];
    
    //{"bloodpressuredata":[{"date":"2013-11-05 06:16:42","systolic":"109","diastolic":"66","pulse":"71","result":"理想血压","advice":{"foodSuggestion":"营养要均衡，多进食一些高蛋白食品，如鱼、鸡蛋、牛奶等。","sportSuggestion":"将有氧运动与力量练习结合起来，每周做力量练习3次，每次30分钟，有氧运动控制在1个小时左右。","doctorSuggestion":"可选择疏肝健脾的食疗养生方，如芹菜粥，即取芹菜连根120g，粳米250g，先将芹菜洗净，切成六分长的段，粳米淘净，芹菜，粳米放入锅内，加清水适量，用武火烧沸后转","commSuggestion":"注意劳逸结合，及时补充足够的水。"},"shareid":"null"}],"arraylength":1}
    NSDictionary *dic = [ServerConnect getLastData:url];
    NSArray *bloodPressureDataArray = [[NSArray alloc]init];
    if([[dic valueForKey:@"bloodpressuredata"] isKindOfClass:[NSArray class]])
    {
        bloodPressureDataArray = (NSArray *)[dic valueForKey:@"bloodpressuredata"];
        
        NSLog(@"%@",bloodPressureDataArray);
        
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
    }
     */
    
    
    /* 获取体重最近一次记录 并解析数据
    NSString *url = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_getLatelyWeightData?authkey=NjU1YjNlNjNjMTVjNDliZWJhNzc4ZDBmNzdkMGY3YjUjMjAxMy0xMi0xNiAxODowMzoxNSMzMCN6%%0AaF9DTg%%3D%%3D&requestnum=1&dtype=30"];
     //{"weightdata":[{"date":"2013-11-23 10:47:43","value":"68.2","result":"标准体重","advice":{"foodSuggestion":"合理规划三餐，早吃好，午吃饱，晚吃少，应特别注重早餐质量，一定要有蛋白质食物，可每天使用煮鸡蛋1枚，每100g含优质蛋白14.7g","sportSuggestion":"每日步行1小时左右，速度应力求达到每分钟100步左右，一天总量达6000步左右","doctorSuggestion":"可每天按摩三阴交穴2次，每次按摩5分钟。","commSuggestion":"尽量少吃夜宵，宵夜过量会促使胃液大量分泌,刺激胃黏膜，损害正常胃肠功能，影响营养物质的吸收"},"shareid":"null"}],"arraylength":1}
    NSDictionary *dic = [ServerConnect getLastData:url];
    NSArray *weightdataArray = [[NSArray alloc]init];
    if([[dic valueForKey:@"weightdata"] isKindOfClass:[NSArray class]])
    {
        weightdataArray = (NSArray *)[dic valueForKey:@"weightdata"];
        
        NSLog(@"%@",weightdataArray);
        
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
    }
     */
    
    
    
    
    
    NSString *urlLogin = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_userLogin?username=%@&pwd=%@&dtype=30",@"15817407047",@"123456"];
    
    NSString *res = [ServerConnect Login:urlLogin]; 
    if([res isEqualToString:@"0"])  //登陆成功
    {
        //获取用户信息
        NSString *urlGetUserInfo = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_getUserInfo?authkey=%@&time=2013-11-26 15:53:30",[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"AuthKey"]];
        
        NSDictionary *dic = [ServerConnect getUserInfo:urlGetUserInfo];
        NSLog(@"dic = %@",dic);
    }
    else  //登陆失败
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:res delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
}

-(void)initMyView
{
    [loginBtn setTitle:NSLocalizedString(@"LOGIN", nil) forState:UIControlStateNormal];
    
    usernameLoginTextField.placeholder = NSLocalizedString(@"PLEASE_INPUT_ACCOUNT", nil);
    passwordLoginTextField.placeholder = NSLocalizedString(@"PLEASE_INPUT_PASSWORD", nil);
    
    [_registBtn setTitle:NSLocalizedString(@"REGIST", nil) forState:UIControlStateNormal];
    [_forgetPassword setTitle:NSLocalizedString(@"FOGET_PASSWORD", nil) forState:UIControlStateNormal]; /*@"忘记密码"*/
    
//    [loginBtn setTitle:NSLocalizedString(@"登录", nil) forState:UIControlStateNormal];
//    
//    usernameLoginTextField.placeholder = NSLocalizedString(@"请输入账号(邮箱)", nil);
//    passwordLoginTextField.placeholder = NSLocalizedString(@"请输入密码", nil);
//    
//    [_registBtn setTitle:NSLocalizedString(@"没有账号？立即注册", nil) forState:UIControlStateNormal];
//    [_forgetPassword setTitle:@"忘记密码" forState:UIControlStateNormal];
}


-(void)initApp
{
    [MySingleton sharedSingleton].serverDomain = @"www.ebelter.com"; //设置服务器地址
    [MySingleton sharedSingleton].nowuserinfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                 [[NSString alloc] initWithFormat:@""],@"Userid",
                                                 [[NSString alloc] initWithFormat:@""],@"UserNumber",
                                                 [[NSString alloc] initWithFormat:@""],@"UserName",
                                                 [[NSString alloc] initWithFormat:@""],@"PassWord",
                                                 [[NSString alloc] initWithFormat:@"65.0"],@"Weight",
                                                 [[NSString alloc] initWithFormat:@"1992-05-12"],@"Birthday",
                                                 [[NSString alloc] initWithFormat:@"0"],@"Gender",
                                                 [[NSString alloc] initWithFormat:@"172"],@"Height",
                                                 [[NSString alloc] initWithFormat:@"0"],@"Profession",
                                                 [[NSString alloc] initWithFormat:@""],@"AuthKey",
                                                 [[NSString alloc] initWithFormat:@"32"],@"Age",
                                                 [[NSString alloc] initWithFormat:@"75"],@"StepSize",
                                                 nil];
    
    NSLog(@"MySingleton AuthKey = %@", [[MySingleton sharedSingleton].nowuserinfo valueForKey:@"AuthKey"]);
}
@end
