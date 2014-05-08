//
//  HistoryViewController.h
//  HealthABC
//
//  Created by 夏 伟 on 14-3-24.
//  Copyright (c) 2014年 夏 伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain)NSMutableArray *dataArray;
@property (nonatomic,retain)NSString *nowDataType;

@property (nonatomic,retain)NSMutableArray *weightDataArray;
@property (nonatomic,retain)NSMutableArray *bodyfatDataArray;
@property (nonatomic,retain)NSMutableArray *bloodpressDataArray;
@property (nonatomic,retain)NSMutableArray *temperatrueDataArray;
@end
