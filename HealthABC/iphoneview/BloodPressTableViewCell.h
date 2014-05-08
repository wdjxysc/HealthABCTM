//
//  BloodPressTableViewCell.h
//  HealthABC
//
//  Created by 夏 伟 on 14-3-26.
//  Copyright (c) 2014年 夏 伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BloodPressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sysDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *diaDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *pulseDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *testtimeDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *sysLabel;
@property (weak, nonatomic) IBOutlet UILabel *diaLabel;
@property (weak, nonatomic) IBOutlet UILabel *pulseLabel;

@end
