//
//  NewPasswordViewController.m
//  HealthABC
//
//  Created by 夏 伟 on 14-4-2.
//  Copyright (c) 2014年 夏 伟. All rights reserved.
//

#import "NewPasswordViewController.h"
#import "ServerConnect.h"
#import "Regex.h"
#import "SVProgressHUD.h"
#import "NewPasswordViewController.h"
#import "MySingleton.h"
#import "LoginViewControllerTM.h"

@interface NewPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *repasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;

@end

@implementation NewPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"NEW_PASSWORD", nil);
//        self.title = @"新密码";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initMyView];
    
    //添加单击手势，隐藏软键盘
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(View_TouchDown:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    [_okBtn addTarget:self action:@selector(okBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self initMyView];
}

- (IBAction)View_TouchDown:(id)sender {
    // 发送resignFirstResponder.
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)okBtnPressed:(id)sender
{
    NSString *password = @"";
    if([_passwordTextField.text isEqualToString:@""]||[_repasswordTextField.text isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"INPUT_CANNOT_EMPTY", nil)];
//        [SVProgressHUD showErrorWithStatus:@"输入不能为空"];
        return;
    }
    else if(![_passwordTextField.text isEqualToString:_repasswordTextField.text])
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"PASSWPRD_MUST_SAME", nil)];
//        [SVProgressHUD showErrorWithStatus:@"两次密码必须相同"];
        return;
    }
    else
    {
        password = _passwordTextField.text;
    }
    
    NSDictionary *dic = [ServerConnect resetPasswordByEmail:[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"UserName"] newpassword:password];
    
    if([[dic valueForKey:@"success"] intValue] == 1)
    {
//        [SVProgressHUD showSuccessWithStatus:@"密码设置成功"];
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"SET_PASSWORD_SUCCESSED", nil)];
        
        LoginViewControllerTM *loginViewController = [[LoginViewControllerTM alloc] initWithNibName:@"LoginViewControllerTM" bundle:nil];
        [self presentViewController:loginViewController animated:YES completion:nil];
    }
    
    
}

-(void)initMyView
{
    _passwordTextField.placeholder = NSLocalizedString(@"PLEASE_INPUT_PASSWORD", nil);
    _repasswordTextField.placeholder = NSLocalizedString(@"REPEAT_PASSWORD", nil);
    [_okBtn setTitle:NSLocalizedString(@"OK", nil) forState:UIControlStateNormal];
    
    [_okBtn setBackgroundImage:[UIImage imageNamed:@"TM_按钮按下"] forState:UIControlStateHighlighted];
}
@end
