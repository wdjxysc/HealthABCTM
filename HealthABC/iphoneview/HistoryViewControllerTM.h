//
//  HistoryViewControllerTM.h
//  HealthABC
//
//  Created by 夏 伟 on 14-4-25.
//  Copyright (c) 2014年 夏 伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewControllerTM : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *myTableView;
}

@property (nonatomic,retain)NSMutableArray *dataArray;
@property (nonatomic,retain)NSString *nowDataType;
@property (nonatomic,retain)NSString *nowTimeType;

@property (nonatomic,retain)NSMutableArray *weightDataArray;
@property (nonatomic,retain)NSMutableArray *bodyfatDataArray;
@property (nonatomic,retain)NSMutableArray *bloodpressDataArray;
@property (nonatomic,retain)NSMutableArray *temperatrueDataArray;

@property (nonatomic,retain)UITableView *myTableView;

@end
