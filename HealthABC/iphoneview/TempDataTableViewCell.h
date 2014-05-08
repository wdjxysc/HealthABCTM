//
//  TempDataTableViewCell.h
//  Thermometer
//
//  Created by 夏 伟 on 14-3-14.
//  Copyright (c) 2014年 夏 伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TempDataTableViewCell : UITableViewCell
{
    IBOutlet UILabel *dataLabel;
    IBOutlet UILabel *testTimeLabel;
    IBOutlet UILabel *unitLabel;
    IBOutlet UIButton *statusBtn;
    IBOutlet UILabel *tempLabel;
}

@property(nonatomic,retain)UILabel *dataLabel;
@property(nonatomic,retain)UILabel *testTimeLabel;
@property(nonatomic,retain)UILabel *unitLabel;
@property(nonatomic,retain)UIButton *statusBtn;
@property(nonatomic,retain)UILabel *tempLabel;
@end
