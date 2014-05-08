//
//  TempDataTableViewCell.m
//  Thermometer
//
//  Created by 夏 伟 on 14-3-14.
//  Copyright (c) 2014年 夏 伟. All rights reserved.
//

#import "TempDataTableViewCell.h"

@implementation TempDataTableViewCell
@synthesize dataLabel;
@synthesize testTimeLabel;
@synthesize unitLabel;
@synthesize statusBtn;
@synthesize tempLabel;

- (void)awakeFromNib
{
    // Initialization code
    tempLabel.text = NSLocalizedString(@"MEASURE_TYPE_TEMPERATURE", nil);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
