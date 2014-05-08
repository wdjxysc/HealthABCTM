//
//  WeightTableViewCell.h
//  HealthABC
//
//  Created by 夏 伟 on 14-3-26.
//  Copyright (c) 2014年 夏 伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeightTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *weightDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *testTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;


@end
