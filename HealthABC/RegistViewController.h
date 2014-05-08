//
//  RegistViewController.h
//  HealthABC
//
//  Created by 夏 伟 on 13-11-22.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistViewController : UIViewController
{
    IBOutlet UILabel *headLabel1;
    IBOutlet UILabel *headLabel2;
    IBOutlet UILabel *headLabel3;
    IBOutlet UIImageView *inputImage1;
    IBOutlet UIImageView *phoneImage1;
    IBOutlet UITextField *phoneNumberTextField1;
    IBOutlet UIButton *getCheckCodeButton1;
    
    IBOutlet UIImageView *inputImage2;
    IBOutlet UIImageView *messageImage2;
    IBOutlet UITextField *checkCodeTextField2;
    IBOutlet UIButton *nextButton2;
    IBOutlet UIButton *reGetCkeckCodeButton2;
    IBOutlet UIButton *backButton2;
    IBOutlet UILabel *phoneTextLabel2;
    IBOutlet UILabel *phoneNumLabel2;
    
    IBOutlet UIImageView *inputImage3_1;
    IBOutlet UIImageView *inputImage3_2;
    IBOutlet UIImageView *clockImage3_1;
    IBOutlet UIImageView *clockImage3_2;
    IBOutlet UITextField *passwordTextField3;
    IBOutlet UITextField *repasswordTextField3;
    IBOutlet UIButton *donebutton;
    IBOutlet UIButton *backButton3;
}

@property(retain,nonatomic)NSString *backCheckCode;

-(IBAction)getCheckCodeBtn1Pressed:(id)sender;
-(IBAction)reGetCheckCodeBtn2Pressed:(id)sender;

-(IBAction)nextBtn2Pressed:(id)sender;
-(IBAction)backBtn2Pressed:(id)sender;

-(IBAction)doneBtn3Pressed:(id)sender;
-(IBAction)backBtn3Pressed:(id)sender;


@end
