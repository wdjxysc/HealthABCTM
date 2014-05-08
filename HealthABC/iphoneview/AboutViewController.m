//
//  AboutViewController.m
//  HealthABC
//
//  Created by 夏 伟 on 14-3-24.
//  Copyright (c) 2014年 夏 伟. All rights reserved.
//

#import "AboutViewController.h"
#import "DEMONavigationController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"关于产品";
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"菜单"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:(DEMONavigationController *)self.navigationController
                                                                                action:@selector(showMenu)];
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
