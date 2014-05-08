//
//  SetUserInfoViewController.m
//  HealthABC
//
//  Created by 夏 伟 on 13-12-11.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import "SetUserInfoViewController.h"
#import "DEMOMenuViewController.h"
#import "DEMONavigationController.h"
#import "ChooseItemViewController.h"
#import "MySingleton.h"
#import "ServerConnect.h"
#import "SVProgressHUD.h"

@interface SetUserInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *accountLabel_1;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel_1;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel_1;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel_1;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel_1;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel_1;
@property (weak, nonatomic) IBOutlet UILabel *professionLabel_1;
@property (weak, nonatomic) IBOutlet UIButton *savebtn;

@end

@implementation SetUserInfoViewController
@synthesize heightPickerView;
@synthesize weightPickerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.navigationItem.title = NSLocalizedString(@"SETTINGS", nil);
        self.tabBarItem.title = NSLocalizedString(@"SETTINGS", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"TM_settings"];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"SAVE", nil)
                                                                                style:UIBarButtonItemStyleBordered
                                                                               target:self
                                                                               action:@selector(saveBtnPressed:)];
        
        //添加单击手势，隐藏软键盘
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(View_TouchDown:)];
        tapGr.cancelsTouchesInView = NO;
        [self.view addGestureRecognizer:tapGr];
        
    }
    return self;
}
- (IBAction)View_TouchDown:(id)sender {
    // 发送resignFirstResponder.
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initMyView];
}

-(void)viewWillAppear:(BOOL)animated
{
    genderTextField.enabled = NO;
    profesionTextField.enabled = NO;
    
    birthdayTextField.inputView = birthdayDatePicker;
    birthdayTextField.inputAccessoryView = birthdayNavigationBar;
    
    //初始化picker值
    weightPickerView = [[UIPickerView alloc]init];
    weightPickerView.dataSource = self;
    weightPickerView.delegate = self;
    weightPickerView.showsSelectionIndicator = YES;
    [weightPickerView selectRow:59 inComponent:0 animated:YES];  //设置pickerview初始值
    weightTextField.inputView = weightPickerView;
    weightTextField.inputAccessoryView = weightNavigationBar;
    
    //初始化picker值
    heightPickerView.dataSource = self;
    heightPickerView.delegate = self;
    heightPickerView.showsSelectionIndicator = YES;
    [heightPickerView selectRow:171 inComponent:0 animated:YES]; //设置pickerview初始值
    heightTextField.inputView = heightPickerView;
    heightTextField.inputAccessoryView = heightNavigationBar;
}

-(void)initMyView
{
    _accountLabel_1.text = NSLocalizedString(@"LOGINLABEL_USERNAME", nil);
    _passwordLabel_1.text = NSLocalizedString(@"LOGINLABEL_PASSWORD", nil);
    
    _genderLabel_1.text = [[NSString alloc] initWithFormat:@"%@:",NSLocalizedString(@"USER_GENDER", nil)];
    _birthdayLabel_1.text = [[NSString alloc] initWithFormat:@"%@:",NSLocalizedString(@"USER_BIRTHDAY", nil)];
    _heightLabel_1.text = [[NSString alloc] initWithFormat:@"%@:",NSLocalizedString(@"USER_HEIGHT", nil)];
    _weightLabel_1.text = [[NSString alloc] initWithFormat:@"%@:",NSLocalizedString(@"USER_WEIGHT", nil)];
    _professionLabel_1.text = [[NSString alloc] initWithFormat:@"%@:",NSLocalizedString(@"USERINFO_ATHLETICTYPE", nil)];
    [_savebtn setTitle:NSLocalizedString(@"SAVE", nil) forState:UIControlStateNormal];
    [birthdayNavigationItem setTitle:NSLocalizedString(@"USER_BIRTHDAY", nil)];
    [birthdayNavigationItem.leftBarButtonItem setTitle:NSLocalizedString(@"CANCEL", nil)];
    [birthdayNavigationItem.rightBarButtonItem setTitle:NSLocalizedString(@"DONE", nil)];
    
    [heightNavigationItem setTitle:NSLocalizedString(@"USERINFO_HEIGHT", nil)];
    [heightNavigationItem.leftBarButtonItem setTitle:NSLocalizedString(@"CANCEL", nil)];
    [heightNavigationItem.rightBarButtonItem setTitle:NSLocalizedString(@"DONE", nil)];
    
    [weightNavigationItem setTitle:NSLocalizedString(@"USERINFO_WEIGHT", nil)];
    [weightNavigationItem.leftBarButtonItem setTitle:NSLocalizedString(@"CANCEL", nil)];
    [weightNavigationItem.rightBarButtonItem setTitle:NSLocalizedString(@"DONE", nil)];
    
    
    accountLabel.text = [[MySingleton sharedSingleton].nowuserinfo valueForKey:@"UserName"];
//    NSString *s = [[MySingleton sharedSingleton].nowuserinfo valueForKey:@"UserName"];
    NSLog(@"%@",[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"UserName"]);
    
    if([[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"Gender"] isEqualToString:@"0"]){
        genderTextField.text = NSLocalizedString(@"GENDER_MALE", nil);
    }
    else{genderTextField.text = NSLocalizedString(@"GENDER_FEMALE", nil);}
    birthdayTextField.text = [[MySingleton sharedSingleton].nowuserinfo valueForKey:@"Birthday"];
    heightTextField.text = [[NSString alloc]initWithFormat:@"%d(cm)",[[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"Height"] intValue]];
    weightTextField.text = [[NSString alloc]initWithFormat:@"%@(kg)",[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"Weight"]];
    if([[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"Profession"] isEqualToString:@"0"])
    {
        profesionTextField.text = NSLocalizedString(@"ATHLETICTYPE_NON_ATHLETE", Nil);
    }
    else if ([[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"Profession"] isEqualToString:@"1"])
    {
        profesionTextField.text = NSLocalizedString(@"ATHLETICTYPE_AMATEUR_ATHLETE", Nil);
    }
    else if ([[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"Profession"] isEqualToString:@"2"])
    {
        profesionTextField.text = NSLocalizedString(@"ATHLETICTYPE_PROFEESSIONAL_ATHLETE", Nil);
    }
}

-(IBAction)inputGenderBtnPressed:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"USER_GENDER", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"CANCEL", nil)
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"GENDER_MALE", nil), NSLocalizedString(@"GENDER_FEMALE", nil), nil];
    [sheet showInView:self.view];
}

-(IBAction)inputProfesionBtnPressed:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"USERINFO_ATHLETICTYPE", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"CANCEL", nil)
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"ATHLETICTYPE_NON_ATHLETE", nil), NSLocalizedString(@"ATHLETICTYPE_AMATEUR_ATHLETE", nil), NSLocalizedString(@"ATHLETICTYPE_PROFEESSIONAL_ATHLETE", nil), nil];
    [sheet showInView:self.view];
}

//sheet选中事件
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //    for (UIView *view in carousel.visibleItemViews)
    //    {
    //        view.alpha = 1.0;
    //    }
    //
    //    [UIView beginAnimations:nil context:nil];
    //    carousel.type = buttonIndex;
    //    [UIView commitAnimations];
    //
    //    navItem.title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if([actionSheet.title isEqualToString:NSLocalizedString(@"USER_GENDER", nil)])
    {
        if(buttonIndex != 2)
        genderTextField.text = [actionSheet buttonTitleAtIndex:buttonIndex];
        if([genderTextField.text isEqualToString:NSLocalizedString(@"GENDER_MALE", nil)])
        {
//            [genderImageView setImage:[UIImage imageNamed:@"男"]];
        }
        else
        {
//            [genderImageView setImage:[UIImage imageNamed:@"女"]];
        }
    }
    else if ([actionSheet.title isEqualToString:NSLocalizedString(@"USERINFO_ATHLETICTYPE", nil)])
    {
        if(buttonIndex != 3)
        profesionTextField.text = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickRightButon
{
    
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

-(IBAction)editCancle:(id)sender
{
    [birthdayTextField resignFirstResponder];
    [genderTextField resignFirstResponder];
    [heightTextField resignFirstResponder];
    [weightTextField resignFirstResponder];
    [profesionTextField resignFirstResponder];
}

-(IBAction)inputHeightDone:(id)sender
{
    if([heightTextField isFirstResponder])
    {
        [heightTextField resignFirstResponder];
    }
    NSInteger row = [heightPickerView selectedRowInComponent:0];
    int height = (int)row + 1;
    heightTextField.text = [[NSString alloc]initWithFormat:@"%d(cm)",height];
}

-(IBAction)inputWeightDone:(id)sender
{
    if([weightTextField isFirstResponder])
    {
        [weightTextField resignFirstResponder];
    }
    NSInteger row1 = [weightPickerView selectedRowInComponent:0]; //体重整数部分
    NSInteger row2 = [weightPickerView selectedRowInComponent:1]; //体重小数部分
    weightTextField.text = [[NSString alloc]initWithFormat:@"%d.%d(kg)",(int)row1,(int)row2];
}

-(IBAction)inputBirthdayDone:(id)sender
{
    if([birthdayTextField isFirstResponder])
    {
        [birthdayTextField resignFirstResponder];
    }
    NSDateFormatter *dateFormatter= [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    birthdayTextField.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:birthdayDatePicker.date]];
}


-(IBAction)saveBtnPressed:(id)sender
{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"SAVE", nil)];
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(uploadUserInfoToCloud) object:nil];
    [thread start];
}

-(void)uploadUserInfoToCloud
{
    //保存用户信息，同步到服务器
    NSString *gender = genderTextField.text;
    NSString *account = accountLabel.text;
    NSString *brithday = birthdayTextField.text;
    NSString *height = heightTextField.text;
    NSString *weight = weightTextField.text;
    NSString *profession = profesionTextField.text;
    NSString *stepSize = @"65";
    
    
    NSLog(@"%@%@",account,brithday);
    
    NSLog(@"%@",NSLocalizedString(@"GENDER_MALE", nil));
    
    if([gender isEqualToString:NSLocalizedString(@"GENDER_MALE", nil)])
    {
        gender = @"0";
    }
    else if([gender isEqualToString:NSLocalizedString(@"GENDER_FEMALE", nil)])
    {
        gender = @"1";
    }
    
    NSRange range = [height rangeOfString:@"("];
    height = [[NSString alloc]initWithFormat:@"%@.0",[height substringWithRange:NSMakeRange(0, range.location)]];
    
    range = [weight rangeOfString:@"("];
    weight = [weight substringWithRange:NSMakeRange(0, range.location)];
    
    if([profession isEqualToString:NSLocalizedString(@"ATHLETICTYPE_NON_ATHLETE", Nil)])
    {
        profession = @"0";
    }
    else if([profession isEqualToString:NSLocalizedString(@"ATHLETICTYPE_AMATEUR_ATHLETE", Nil)])
    {
        profession = @"1";
    }
    else if([profession isEqualToString:NSLocalizedString(@"ATHLETICTYPE_PROFEESSIONAL_ATHLETE", Nil)])
    {
        profession = @"2";
    }
    
    
    NSDateFormatter *fomatter = [[NSDateFormatter alloc]init];
    [fomatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *birthdate = [fomatter dateFromString:brithday];
    int age = [self GetAgeByBrithday:birthdate];
    
    
    
    bool b = true;//是否同步成功
    //http://www.ebelter.com/service/ehealth_uploaduserInfo?authkey=MjUzODUxMzM3YTRmNDQ2YmIzODBlNTU0YWJlNmU3ZjEjMjAxMy0xMi0xNiAxMDowMjowNiMwOSN6%0AaF9DTg%3D%3D&sex=1&age=29&height=170.0&weight=65.9&stepSize=65.0&profession=0
    
    NSString *uploaduserinfourl = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_uploaduserInfo?authkey=%@&sex=%@&age=%d&height=%@&weight=%@&stepSize=%@.0&profession=%@",[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"AuthKey"],gender,age,height,weight,stepSize,profession];
    
    [[MySingleton sharedSingleton].nowuserinfo setValue:gender forKey:@"Gender"];
    [[MySingleton sharedSingleton].nowuserinfo setValue:[[NSString alloc] initWithFormat:@"%d",age] forKey:@"Age"];
    [[MySingleton sharedSingleton].nowuserinfo setValue:height forKey:@"Height"];
    [[MySingleton sharedSingleton].nowuserinfo setValue:weight forKey:@"Weight"];
    [[MySingleton sharedSingleton].nowuserinfo setValue:profession forKey:@"Profession"];
    
    NSDictionary *dic = [ServerConnect getDictionaryByUrl:uploaduserinfourl];
    
    if(dic!=nil)
    {
        NSLog(@"%@",dic);
        if([[dic valueForKey:@"success"] intValue]==1)
        {
            NSLog(@"更新成功");
            //            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NOTICE", nil) message:NSLocalizedString(@"SAVE_SUCCESS", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
            //            [alertView show];
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"SAVE_SUCCESSED", nil)];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"SAVE_FAILED", nil)];
        }
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"SAVE_FAILED", nil)];
    }
}

-(void)uploadUserInfo
{
    bool b = true;//是否同步成功
    
    if(b)
    {
        [MySingleton sharedSingleton].isLogined = YES;
        
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
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSInteger result = 0;
    if (pickerView == heightPickerView)
    {
        result = 2;
    }
    else if (pickerView == weightPickerView)
    {
        result = 3;
    }
    return result;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger result = 0;
    if (pickerView == heightPickerView)
    {
        switch (component) {
            case 0:
                result = 250;
                break;
            case 1:
                result = 1;
                break;
            default:
                break;
        }
    }
    else if(pickerView == weightPickerView)
    {
        switch (component) {
            case 0:
                result = 150;
                break;
            case 1:
                result = 10;
                break;
            case 2:
                result = 1;
                break;
            default:
                break;
        }
    }
    return result;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *result = nil;
    if (pickerView == heightPickerView)
    {
        /* Row is zero-based and we want the first row (with index 0) to be rendered as Row 1 so we have to +1 every row index */
        switch (component) {
            case 0:
                result = [NSString stringWithFormat:@"%ld", (long)row +1];
                break;
            case 1:
                result = @"cm";
                break;
            default:
                break;
        }
    }
    else if (pickerView == weightPickerView)
    {
        switch (component) {
            case 0:
                result = [NSString stringWithFormat:@"%ld",(long)row];
                break;
            case 1:
                result = [NSString stringWithFormat:@"%ld",(long)row];
                break;
            case 2:
                result = @"kg";
                break;
            default:
                break;
        }
    }
    //设置初始值
    //    [pickerView selectRow:169 inComponent:0 animated:NO];
    return result;
}


-(int)GetAgeByBrithday:(NSDate *)brithday
{
    int age = 0;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    NSDateComponents *brithdaycomps = [[NSDateComponents alloc] init];
    NSDateComponents *nowcomps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;//这句我也不明白具体时用来做什么。。。
    brithdaycomps = [calendar components:unitFlags fromDate:brithday];
    nowcomps = [calendar components:unitFlags fromDate:NSDate.date];
    //    long brithdayweekNumber = [brithdaycomps weekday]; //获取星期对应的长整形字符串
    long brithdayday=[brithdaycomps day];//获取日期对应的长整形字符串
    long brithdayyear=[brithdaycomps year];//获取年对应的长整形字符串
    long brithdaymonth=[brithdaycomps month];//获取月对应的长整形字符串
    //    long brithdayhour=[brithdaycomps hour];//获取小时对应的长整形字符串
    //    long brithdayminute=[brithdaycomps minute];//获取月对应的长整形字符串
    //    long brithdaysecond=[brithdaycomps second];//获取秒对应的长整形字符串
    //    long nowweekNumber = [nowcomps weekday]; //获取星期对应的长整形字符串
    long nowday=[nowcomps day];//获取日期对应的长整形字符串
    long nowyear=[nowcomps year];//获取年对应的长整形字符串
    long nowmonth=[nowcomps month];//获取月对应的长整形字符串
    //    long nowhour=[nowcomps hour];//获取小时对应的长整形字符串
    //    long nowminute=[nowcomps minute];//获取月对应的长整形字符串
    //    long nowsecond=[nowcomps second];//获取秒对应的长整形字符串
    
    if(nowyear>brithdayyear)
    {
        if(nowmonth>brithdaymonth)
        {
            age = nowyear - brithdayyear;
        }
        else if(nowmonth == brithdaymonth)
        {
            if(nowday>=brithdayday)
            {
                age = nowyear - brithdayyear;
            }
            else
            {
                age = nowyear - brithdayyear - 1;
            }
        }
        else
        {
            age = nowyear - brithdayyear - 1;
        }
        
    }
    else
    {
        age = 0;
    }
    return age;
}


@end
