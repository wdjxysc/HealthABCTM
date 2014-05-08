//
//  SetUserInfoViewController.h
//  HealthABC
//
//  Created by 夏 伟 on 13-12-11.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetUserInfoViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    IBOutlet UINavigationBar *birthdayNavigationBar;
    IBOutlet UINavigationItem *birthdayNavigationItem;
    IBOutlet UIDatePicker *birthdayDatePicker;
    
    IBOutlet UINavigationBar *heightNavigationBar;
    IBOutlet UINavigationItem *heightNavigationItem;
    IBOutlet UIPickerView *heightPickerView;
    
    IBOutlet UINavigationBar *weightNavigationBar;
    IBOutlet UINavigationItem *weightNavigationItem;
    IBOutlet UIPickerView *weightPickerView;
    
    
    IBOutlet UIImageView *genderImageView;
    IBOutlet UILabel *accountLabel;
    IBOutlet UILabel *passwordLabel;
    IBOutlet UITextField *birthdayTextField;
    IBOutlet UITextField *genderTextField;
    IBOutlet UITextField *heightTextField;
    IBOutlet UITextField *weightTextField;
    IBOutlet UITextField *profesionTextField;
}


@property(nonatomic,retain) UIPickerView *heightPickerView;
@property(nonatomic,retain) UIPickerView *weightPickerView;


-(IBAction)textFieldDidBeginEditing:(id)sender;
-(IBAction)textFieldDidEndEditing:(id)sender;
-(IBAction)saveBtnPressed:(id)sender;
-(IBAction)editCancle:(id)sender;
-(IBAction)inputWeightDone:(id)sender;
-(IBAction)inputHeightDone:(id)sender;
-(IBAction)inputBirthdayDone:(id)sender;
-(IBAction)inputGenderBtnPressed:(id)sender;
-(IBAction)inputProfesionBtnPressed:(id)sender;

@end
