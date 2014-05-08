//
//  ChooseItemViewController.h
//  HealthABC
//
//  Created by 夏 伟 on 13-11-22.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BloodPressureMeasureViewController.h"
#import "BodyFatMeasureViewController.h"
#import "WeightMeasureViewController.h"

@interface ChooseItemViewController : UIViewController
{
    IBOutlet UIButton *genderButton;
    IBOutlet UILabel *kcalDataLabel;
    IBOutlet UILabel *distanceDataLabel;
    IBOutlet UILabel *weightDataLabel;
    IBOutlet UILabel *weightResultLabel;
    IBOutlet UILabel *bloodPressDataLabel;
    IBOutlet UILabel *bloodPressResultLabel;
    IBOutlet UILabel *bodyFatDataLabel;
    IBOutlet UILabel *bodyFatResultLabel;
    IBOutlet UILabel *userNameLabel;
    IBOutlet UIButton *weightMeasureButton;
}
@property (weak, nonatomic) IBOutlet UIButton *temperatureBtn;
@property (weak, nonatomic) IBOutlet UIButton *bodyFatBtn;
@property (weak, nonatomic) IBOutlet UIButton *bloodpressBtn;
@property (weak, nonatomic) IBOutlet UIButton *weightBtn;

@property(nonatomic,retain) UILabel *weightDataLabel;
@property(nonatomic,retain) UILabel *bloodPressDataLabel;
@property(nonatomic,retain) UILabel *bodyFatDataLabel;
@property(nonatomic,retain) UILabel *userNameLabel;

@property(nonatomic,strong) BodyFatMeasureViewController *bodyFatMeasureViewController;
@property(nonatomic,strong)WeightMeasureViewController *weightMeasureViewController;
@property(nonatomic,strong)BloodPressureMeasureViewController *bloodPressureMeasureViewController;

-(IBAction)showWeightMeasureView:(id)sender;
-(IBAction)showBodyFatMeasureView:(id)sender;
-(IBAction)showBloodPressMeasureView:(id)sender;
-(IBAction)showPedometerMeasureView:(id)sender;
-(IBAction)showTuBuMeasureView:(id)sender;
-(IBAction)showManPaoMeasureView:(id)sender;
-(IBAction)showQiXingMeasureView:(id)sender;
-(IBAction)showPanDengMeasureView:(id)sender;

@end