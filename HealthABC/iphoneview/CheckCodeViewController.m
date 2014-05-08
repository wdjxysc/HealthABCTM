//
//  CheckCodeViewController.m
//  HealthABC
//
//  Created by 夏 伟 on 14-4-2.
//  Copyright (c) 2014年 夏 伟. All rights reserved.
//

#import "CheckCodeViewController.h"
#import "ServerConnect.h"
#import "Regex.h"
#import "SVProgressHUD.h"
#import "NewPasswordViewController.h"
#import "MySingleton.h"

@interface CheckCodeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *checkcodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation CheckCodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"PLEASE_INPUT_CHECKCODE", nil);
//        self.title = @"输入邮箱";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_nextBtn addTarget:self action:@selector(nextBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //添加单击手势，隐藏软键盘
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(View_TouchDown:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    [self initMyView];
}

-(void)initMyView
{
    _checkcodeTextField.placeholder = NSLocalizedString(@"PLEASE_INPUT_CHECKCODE", nil);
    [_nextBtn setTitle:NSLocalizedString(@"NEXT", nil) forState:UIControlStateNormal];
    
//    _checkcodeTextField.placeholder = @"输入邮箱";
//    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    
    [_nextBtn setBackgroundImage:[UIImage imageNamed:@"TM_按钮按下"] forState:UIControlStateHighlighted];
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

-(IBAction)nextBtnPressed:(id)sender
{
    //验证验证码
    NSString *checkcodestr = @"";
    if(![_checkcodeTextField.text isEqualToString:@""])
    {
        checkcodestr = _checkcodeTextField.text;
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"INPUT_CHECKCODE", nil)];/*@"请输入验证码"*/
        return;
    }
    
    NSDictionary *dic = [ServerConnect checkCheckCode:[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"UserName"] checkcode:checkcodestr];
    
    if([[dic valueForKey:@"success"] intValue] == 1){
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"CHECK_SUCCESS", nil)];/*@"验证成功"*/
    
        //跳转页面
        NewPasswordViewController *newPasswordViewController = [[NewPasswordViewController alloc]initWithNibName:@"NewPasswordViewController" bundle:nil];
        [self.navigationController pushViewController:newPasswordViewController animated:YES];
        
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"CHECK_FAILED", nil)];/*验证失败*/
    }
    
}

@end
