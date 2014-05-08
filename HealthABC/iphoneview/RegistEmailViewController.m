//
//  RegistEmailViewController.m
//  HealthABC
//
//  Created by 夏 伟 on 14-3-24.
//  Copyright (c) 2014年 夏 伟. All rights reserved.
//

#import "RegistEmailViewController.h"
#import "SetUserInfoViewController.h"
#import "LoginViewController.h"
#import "Regex.h"
#import "SVProgressHUD.h"
#import "ServerConnect.h"

@interface RegistEmailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *rePasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;

@end

@implementation RegistEmailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"REGIST", nil);
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BACK", nil) style:UIBarButtonItemStylePlain target:self action:@selector(backLoginView:)];
        [_registBtn addTarget:self action:@selector(registBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)backLoginView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)registBtnPressed:(id)sender
{
    BOOL success = false;
    if([_emailTextField.text isEqualToString:@""]||
       [_passwordTextField.text isEqualToString:@""]||
       [_rePasswordTextField.text isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"INPUT_CANNOT_EMPTY", nil)];
//        [SVProgressHUD showErrorWithStatus:@"输入不能为空"];
        return;
    }
    if(![Regex validateEmail:_emailTextField.text])
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Please input the correct format mailbox", nil)];
//        [SVProgressHUD showErrorWithStatus:@"请输入可用的邮箱"];
        return;
    }
    if(![_passwordTextField.text isEqualToString:_rePasswordTextField.text])
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"PASSWPRD_MUST_SAME", nil)];
//        [SVProgressHUD showErrorWithStatus:@"两次输入密码须相同"];
        return;
    }
    
    NSString *s = [ServerConnect registByEmail:_emailTextField.text password:_passwordTextField.text];
    if([s isEqualToString:@"0"])
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"REGIST_SUCCESS", nil)];
//        [SVProgressHUD showErrorWithStatus:@"注册成功"];
        success = true;
    }
    else if ([s isEqualToString:@"1"])
    {
//        [SVProgressHUD showErrorWithStatus:@"注册失败"];
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"REGIST_FAILED", nil)];
    }
    else if ([s isEqualToString:@"2"])
    {
//        [SVProgressHUD showErrorWithStatus:@"邮箱已被注册"];
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"EMAIL_HAS_REGISTED", nil)];
    }
    else if ([s isEqualToString:@"3"])
    {
//        [SVProgressHUD showErrorWithStatus:@"邮箱或密码为空"];
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"", nil)];
    }
    else if ([s isEqualToString:@"4"])
    {
    }
    else if ([s isEqualToString:@"5"])
    {
    }
    
    if(success == true){
        SetUserInfoViewController *setUserInfoViewController = [[SetUserInfoViewController alloc]initWithNibName:@"SetUserInfoViewController" bundle:nil];
        [self.navigationController pushViewController:setUserInfoViewController animated:YES];
    }
}

-(void)initMyView
{
    _emailTextField.delegate = self;
    _passwordTextField.delegate = self;
    _rePasswordTextField.delegate = self;
    
    _emailTextField.placeholder = NSLocalizedString(@"PLEASE_INPUT_EMAIL", nil);
    _passwordTextField.placeholder = NSLocalizedString(@"PLEASE_INPUT_PASSWORD", nil);
    _rePasswordTextField.placeholder = NSLocalizedString(@"REPEAT_PASSWORD", nil);
    [_registBtn setTitle:NSLocalizedString(@"NEXT", nil) forState:UIControlStateNormal];
}
@end
