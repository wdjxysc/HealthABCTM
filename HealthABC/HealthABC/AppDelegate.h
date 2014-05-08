//
//  AppDelegate.h
//  HealthABC
//
//  Created by 夏 伟 on 13-11-21.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewControllerTM.h"
#import "LunchViewControllerTM.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) LoginViewControllerTM *loginViewControllerTM;
@property (strong, nonatomic) LunchViewControllerTM *lunchViewControllerTM;

@end
