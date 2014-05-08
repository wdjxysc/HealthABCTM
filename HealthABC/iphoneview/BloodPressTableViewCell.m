//
//  BloodPressTableViewCell.m
//  HealthABC
//
//  Created by 夏 伟 on 14-3-26.
//  Copyright (c) 2014年 夏 伟. All rights reserved.
//

#import "BloodPressTableViewCell.h"

@implementation BloodPressTableViewCell

- (void)awakeFromNib
{
    // Initialization code
//    [_sysBtn setTitle:NSLocalizedString(@"USER_SYS", nil) forState:UIControlStateNormal];
//    [_diaBtn setTitle:NSLocalizedString(@"USER_DIA", nil) forState:UIControlStateNormal];
//    [_pulseBtn setTitle:NSLocalizedString(@"USER_PULSE", nil) forState:UIControlStateNormal];
    
    _sysLabel.text = NSLocalizedString(@"USER_SYS", nil);
    _diaLabel.text = NSLocalizedString(@"USER_DIA", nil);
    _pulseLabel.text = NSLocalizedString(@"USER_PULSE", nil);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
