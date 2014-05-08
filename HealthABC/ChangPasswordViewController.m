//
//  ChangPasswordViewController.m
//  HealthABC
//
//  Created by 夏 伟 on 13-11-22.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import "ChangPasswordViewController.h"
#import "LoginViewController.h"
#import "CheckCodeViewController.h"
#import "ServerConnect.h"
#import "Regex.h"
#import "SVProgressHUD.h"
#import "MySingleton.h"

@interface ChangPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCheckCodeBtn;

@end

@implementation ChangPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
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
	// Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"CHANGE_PASSWORD", nil);/*@"修改密码"*/
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BACK", nil) /*@"返回"*/
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(backToLoginView:)];
    
    [_getCheckCodeBtn addTarget:self action:@selector(nextBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //添加单击手势，隐藏软键盘
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(View_TouchDown:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    
    [self initMyView];
}

-(void)initMyView
{
    _emailTextField.placeholder = NSLocalizedString(@"PLEASE_INPUT_EMAIL", nil);
    [_getCheckCodeBtn setTitle:NSLocalizedString(@"GET_CHECKCODE", nil) forState:UIControlStateNormal];
//    _emailTextField.placeholder = @"输入邮箱";
//    [_getCheckCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    [_getCheckCodeBtn setBackgroundImage:[UIImage imageNamed:@"TM_按钮按下"] forState:UIControlStateHighlighted];
}

-(IBAction)backToLoginView:(id)sender
{
//    LoginViewController *loginViewController = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
//    loginViewController.modalPresentationStyle = UIModalPresentationPageSheet;
//    [self presentViewController:loginViewController animated:YES completion:^{//备注2
//        NSLog(@"show LoginView!");
//    }];
    
    //返回上一视图
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)nextBtnPressed:(id)sender
{
    //请求验证码
    NSString *emailstr;
    if([Regex validateEmail:_emailTextField.text]){
        emailstr = _emailTextField.text;
    }
    else if([_emailTextField.text isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"PLEASE_INPUT_EMAIL", nil) ];/*@"请输入正确格式的邮箱"*/
        return;
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Please input the correct format mailbox", nil) ];/*@"请输入正确格式的邮箱"*/
        return;
    }
    
    NSDictionary *dic = [ServerConnect getCheckCodeByEmail:emailstr];
    if([[dic valueForKey:@"success"] intValue] == 1)
    {
        [[MySingleton sharedSingleton].nowuserinfo setObject:emailstr forKey:@"UserName"];
        //跳转页面
        CheckCodeViewController *checkCodeViewController = [[CheckCodeViewController alloc] initWithNibName:@"CheckCodeViewController" bundle:nil];
        [self.navigationController pushViewController:checkCodeViewController animated:YES];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"GET_FAILED", nil)];/*@"获取失败"*/
    }
}
@end
