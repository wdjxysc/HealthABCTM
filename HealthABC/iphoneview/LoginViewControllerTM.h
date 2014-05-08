//
//  LoginViewController.h
//  HealthABC
//
//  Created by 夏 伟 on 13-11-21.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewControllerTM : UIViewController <UITextFieldDelegate,UITabBarControllerDelegate>
{
    IBOutlet UITextField *usernameLoginTextField;
    IBOutlet UITextField *passwordLoginTextField;
    IBOutlet UIButton *loginBtn;
}

@property(retain,nonatomic)UITabBarController *tabBarController;


-(IBAction)textFieldDidBeginEditing:(id)sender;
-(IBAction)textFieldDidEndEditing:(id)sender;
-(IBAction)LoginBtnPressed:(id)sender;
-(IBAction)DidEndOnExit:(id)sender;
-(IBAction)testBtnPressed:(id)sender;



@end
