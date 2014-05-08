//
//  RegistViewController.m
//  HealthABC
//
//  Created by 夏 伟 on 13-11-22.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import "RegistViewController.h"
#import "SetUserInfoViewController.h"
#import "ServerConnect.h"
#import "Regex.h"
#import "SVProgressHUD.h"
#import "MySingleton.h"

@interface RegistViewController ()

@end

@implementation RegistViewController
@synthesize backCheckCode;

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
    self.title = @"注册";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(backToLoginView:)];
    headLabel1.hidden = false;
    headLabel2.hidden = false;
    headLabel3.hidden = false;
    inputImage1.hidden = false;
    phoneImage1.hidden = false;
    phoneNumberTextField1.hidden = false;
    getCheckCodeButton1.hidden = false;
    
    inputImage2.hidden = true;
    messageImage2.hidden = true;
    checkCodeTextField2.hidden = true;
    nextButton2.hidden = true;
    reGetCkeckCodeButton2.hidden = true;
    backButton2.hidden = true;
    phoneTextLabel2.hidden = true;
    phoneNumLabel2.hidden = true;
    
    inputImage3_1.hidden = true;
    inputImage3_2.hidden = true;
    clockImage3_1.hidden = true;
    clockImage3_2.hidden = true;
    passwordTextField3.hidden = true;
    repasswordTextField3.hidden = true;
    donebutton.hidden = true;
    backButton3.hidden = true;
}

-(IBAction)DidEndOnExit:(id)sender
{
    [sender resignFirstResponder];
}


-(IBAction)backToLoginView:(id)sender
{
    //返回上一视图
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)getCheckCodeBtn1Pressed:(id)sender
{
    if(![Regex validateMobile:phoneNumberTextField1.text])
    {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    else if(![ServerConnect isConnectionAvailable])
    {
        
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    else
    {
        getCheckCodeButton1.enabled = false;
        [SVProgressHUD showWithStatus:@"请稍候..."];
        phoneNumLabel2.text = phoneNumberTextField1.text;
        NSThread* myThread1 = [[NSThread alloc] initWithTarget:self selector:@selector(requestCheckCode)object:nil];
        [myThread1 start];
    }
}

//再次获取验证码
-(IBAction)reGetCheckCodeBtn2Pressed:(id)sender
{
    if(![ServerConnect isConnectionAvailable])
    {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    else
    {
        getCheckCodeButton1.enabled = false;
        [SVProgressHUD showWithStatus:@"请稍候..."];
        NSThread* myThread1 = [[NSThread alloc] initWithTarget:self selector:@selector(requestCheckCode)object:nil];
        [myThread1 start];
    }
}


-(IBAction)nextBtn2Pressed:(id)sender
{
    if([checkCodeTextField2.text isEqualToString:@""])
    {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入验证码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    else
    {
        backButton2.enabled = false;
        nextButton2.enabled = false;
        [SVProgressHUD showWithStatus:@"请稍候..."];
        NSThread* myThread1 = [[NSThread alloc] initWithTarget:self selector:@selector(feedBackCheckCode)object:nil];
        [myThread1 start];
    }
}


-(IBAction)backBtn2Pressed:(id)sender
{
    headLabel1.hidden = false;
    headLabel1.textColor = [UIColor colorWithRed:254.0/255.0 green:155.0/255.0 blue:31.0/255.0 alpha:1.0];
    headLabel2.hidden = false;
    headLabel2.textColor = [UIColor blackColor];
    headLabel3.hidden = false;
    headLabel3.textColor = [UIColor blackColor];
    inputImage1.hidden = false;
    phoneImage1.hidden = false;
    phoneNumberTextField1.hidden = false;
    getCheckCodeButton1.hidden = false;
    
    inputImage2.hidden = true;
    messageImage2.hidden = true;
    checkCodeTextField2.hidden = true;
    nextButton2.hidden = true;
    reGetCkeckCodeButton2.hidden = true;
    backButton2.hidden = true;
    phoneTextLabel2.hidden = true;
    phoneNumLabel2.hidden = true;
    
    inputImage3_1.hidden = true;
    inputImage3_2.hidden = true;
    clockImage3_1.hidden = true;
    clockImage3_2.hidden = true;
    passwordTextField3.hidden = true;
    repasswordTextField3.hidden = true;
    donebutton.hidden = true;
    backButton3.hidden = true;
}

//完成注册跳转到完善用户信息界面
-(IBAction)doneBtn3Pressed:(id)sender
{
    if([passwordTextField3.text isEqualToString:@""]||[repasswordTextField3.text isEqualToString:@""])
    {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    else if (![passwordTextField3.text isEqualToString:repasswordTextField3.text])
    {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"两次输入的密码必须相同" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    else if ([passwordTextField3.text isEqualToString:repasswordTextField3.text])
    {
        //开启设置密码线程
        donebutton.enabled = false;
        [SVProgressHUD showWithStatus:@"请稍候..."];
        NSThread* myThread1 = [[NSThread alloc] initWithTarget:self selector:@selector(thrSetPassword)object:nil];
        [myThread1 start];
    }
}


-(IBAction)backBtn3Pressed:(id)sender
{
    headLabel1.hidden = false;
    headLabel1.textColor = [UIColor blackColor];
    headLabel2.hidden = false;
    headLabel2.textColor = [UIColor colorWithRed:254.0/255.0 green:155.0/255.0 blue:31.0/255.0 alpha:1.0];
    headLabel3.hidden = false;
    headLabel3.textColor = [UIColor blackColor];
    inputImage1.hidden = true;
    phoneImage1.hidden = true;
    phoneNumberTextField1.hidden = true;
    getCheckCodeButton1.hidden = true;
    
    inputImage2.hidden = false;
    messageImage2.hidden = false;
    checkCodeTextField2.hidden = false;
    nextButton2.hidden = false;
    reGetCkeckCodeButton2.hidden = false;
    backButton2.hidden = false;
    phoneTextLabel2.hidden = false;
    phoneNumLabel2.hidden = false;
    
    inputImage3_1.hidden = true;
    inputImage3_2.hidden = true;
    clockImage3_1.hidden = true;
    clockImage3_2.hidden = true;
    passwordTextField3.hidden = true;
    repasswordTextField3.hidden = true;
    donebutton.hidden = true;
    backButton3.hidden = true;
}

-(void)requestCheckCode
{
    
    NSString *phoneNumber = phoneNumberTextField1.text;
    NSString *url = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_checkTelphone?telphone=%@&dtype=30",phoneNumber];
    NSDictionary *dic = [ServerConnect requestCheckCode:url];
    NSString *success = [[NSString alloc]initWithFormat:@"%@",[dic valueForKey:@"success"]];
    if([success isEqualToString:@"0"])
    {
//        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"获取验证码失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        NSString *errormessage = [[NSString alloc]initWithFormat:@"%@",[dic valueForKey:@"errormessage"]];
        [SVProgressHUD dismissWithError:errormessage];
    }
    else if([success isEqualToString:@"1"])
    {
        [SVProgressHUD dismissWithSuccess:@"获取成功!"];
        headLabel1.hidden = false;
        headLabel1.textColor = [UIColor blackColor];
        headLabel2.hidden = false;
        headLabel2.textColor = [UIColor colorWithRed:254.0/255.0 green:155.0/255.0 blue:31.0/255.0 alpha:1.0];
        headLabel3.hidden = false;
        headLabel3.textColor = [UIColor blackColor];
        inputImage1.hidden = true;
        phoneImage1.hidden = true;
        phoneNumberTextField1.hidden = true;
        getCheckCodeButton1.hidden = true;
        
        inputImage2.hidden = false;
        messageImage2.hidden = false;
        checkCodeTextField2.hidden = false;
        nextButton2.hidden = false;
        reGetCkeckCodeButton2.hidden = false;
        backButton2.hidden = false;
        phoneTextLabel2.hidden = false;
        phoneNumLabel2.hidden = false;
        
        inputImage3_1.hidden = true;
        inputImage3_2.hidden = true;
        clockImage3_1.hidden = true;
        clockImage3_2.hidden = true;
        passwordTextField3.hidden = true;
        repasswordTextField3.hidden = true;
        donebutton.hidden = true;
        backButton3.hidden = true;
    }
    else
    {
        [SVProgressHUD dismissWithError:@"请求超时!"];
    }
    getCheckCodeButton1.enabled = true;
}

-(void)feedBackCheckCode
{
    NSString *checkCode = checkCodeTextField2.text;
    NSString *phoneNumber = phoneNumberTextField1.text;
    NSString *url = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_checkTelphone?telphone=%@&check_code=%@&dtype=30",phoneNumber,checkCode];
    BOOL b = [ServerConnect backCheckCode:url];
    if(b == true)
    {
        [SVProgressHUD dismissWithSuccess:@"验证成功!"];
        headLabel1.hidden = false;
        headLabel1.textColor = [UIColor blackColor];
        headLabel2.hidden = false;
        headLabel2.textColor = [UIColor blackColor];
        headLabel3.hidden = false;
        headLabel3.textColor = [UIColor colorWithRed:254.0/255.0 green:155.0/255.0 blue:31.0/255.0 alpha:1.0];
        inputImage1.hidden = true;
        phoneImage1.hidden = true;
        phoneNumberTextField1.hidden = true;
        getCheckCodeButton1.hidden = true;
        
        inputImage2.hidden = true;
        messageImage2.hidden = true;
        checkCodeTextField2.hidden = true;
        nextButton2.hidden = true;
        reGetCkeckCodeButton2.hidden = true;
        backButton2.hidden = true;
        phoneTextLabel2.hidden = true;
        phoneNumLabel2.hidden = true;
        
        inputImage3_1.hidden = false;
        inputImage3_2.hidden = false;
        clockImage3_1.hidden = false;
        clockImage3_2.hidden = false;
        passwordTextField3.hidden = false;
        repasswordTextField3.hidden = false;
        donebutton.hidden = false;
        backButton3.hidden = false;
    }
    else
    {
        [SVProgressHUD dismissWithError:@"验证失败!"];
    }
    
    backButton2.enabled = true;
    nextButton2.enabled = true;
}

-(void)thrSetPassword
{
    NSString *phoneNumber = phoneNumberTextField1.text;
    NSLog(@"%@",phoneNumber);
    
    if(true)
    {
        [SVProgressHUD dismissWithSuccess:@"注册成功！"];
        
        [[MySingleton sharedSingleton].nowuserinfo setValue:phoneNumberTextField1.text forKey:@"UserName"];
        [[MySingleton sharedSingleton].nowuserinfo setValue:passwordTextField3.text forKey:@"PassWord"];
        
        NSLog(@"%@",[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"UserName"]);
        NSLog(@"%@",[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"PassWord"]);
        
        SetUserInfoViewController *setUserInfoViewController = [[SetUserInfoViewController alloc]initWithNibName:@"SetUserInfoViewController" bundle:nil];
        
        [self.navigationController pushViewController:setUserInfoViewController animated:YES];
    }
    
    donebutton.enabled = true;
}

@end
