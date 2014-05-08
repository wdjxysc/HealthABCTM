//
//  ChartViewController.h
//  HealthABC
//
//  Created by 夏 伟 on 14-4-9.
//  Copyright (c) 2014年 夏 伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineChartView.h"

@interface ChartViewController : UIViewController
@property(nonatomic,retain)NSString *nowDataType;

@property(nonatomic,retain)LineChartView *myLineChartView;

@property(nonatomic,retain)NSDate *nowBeginTime;
@property(nonatomic,retain)NSDate *nowEndTime;

@property(nonatomic,retain)UILabel *nowBeginTimeLabel;
@property(nonatomic,retain)UILabel *nowEndTimeLabel;
@property(nonatomic,retain)UIButton *previousBtn;
@property(nonatomic,retain)UIButton *nextBtn;

@end
