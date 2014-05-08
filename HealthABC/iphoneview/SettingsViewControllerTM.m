//
//  SettingsViewControllerTM.m
//  HealthABC
//
//  Created by 夏 伟 on 14-4-25.
//  Copyright (c) 2014年 夏 伟. All rights reserved.
//

#import "SettingsViewControllerTM.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define Screen_height   [[UIScreen mainScreen] bounds].size.height
#define Screen_width    [[UIScreen mainScreen] bounds].size.width

@interface SettingsViewControllerTM ()

@end

@implementation SettingsViewControllerTM

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.title = NSLocalizedString(@"SETTINGS", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"TM_settings"];
        
        self.navigationItem.title = NSLocalizedString(@"SETTINGS", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
