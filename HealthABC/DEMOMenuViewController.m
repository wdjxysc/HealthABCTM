//
//  DEMOMenuViewController.m
//  REFrostedViewControllerExample
//
//  Created by Roman Efimov on 9/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOMenuViewController.h"
#import "ChooseItemViewController.h"
#import "DEMOSecondViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "SetUserInfoViewController.h"
#import "DeviceViewController.h"
#import "HistoryViewController.h"
#import "AboutViewController.h"
#import "AppDelegate.h"

@implementation DEMOMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 56.0f)];
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
//        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//        imageView.image = [UIImage imageNamed:@"avatar.jpg"];
//        imageView.layer.masksToBounds = YES;
//        imageView.layer.cornerRadius = 50.0;
//        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
//        imageView.layer.borderWidth = 3.0f;
//        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
//        imageView.layer.shouldRasterize = YES;
//        imageView.clipsToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 0, 24)];
        label.text = NSLocalizedString(@"MENU", nil);/*@"菜单"*/
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
//        [view addSubview:imageView];
        [view addSubview:label];
        view;
    });
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    label.text = @"Friends Online";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 0;
    
    return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        SetUserInfoViewController *setUserInfoViewController = [[SetUserInfoViewController alloc] init];
        navigationController.viewControllers = @[setUserInfoViewController];
    }
    else if (indexPath.section == 0 && indexPath.row == 1) {
        ChooseItemViewController *homeViewController = [[ChooseItemViewController alloc] init];
        navigationController.viewControllers = @[homeViewController];
    }
//    else if (indexPath.section == 0 && indexPath.row == 2) {
//        DeviceViewController *deviceViewController = [[DeviceViewController alloc] init];
//        navigationController.viewControllers = @[deviceViewController];
//    }
    else if (indexPath.section == 0 && indexPath.row == 2) {
        HistoryViewController *historyViewController = [[HistoryViewController alloc] init];
        navigationController.viewControllers = @[historyViewController];
    }
//    else if (indexPath.section == 0 && indexPath.row == 4) {
//        AboutViewController *aboutViewController = [[AboutViewController alloc] init];
//        navigationController.viewControllers = @[aboutViewController];
//    }
    else {
        [self exitApplication];
    }
    
    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0) {
        NSArray *titles = @[NSLocalizedString(@"MY_ACCOUNT", nil),
                            NSLocalizedString(@"MEASUREMENT", nil),
                            NSLocalizedString(@"MY_HISTORY", nil),
                            NSLocalizedString(@"EXIT", nil)];
//        NSArray *titles = @[@"我的账号",
//                            @"开始测量",
//                            @"我的记录",
//                            @"退出"];
//        NSArray *images =
        cell.textLabel.text = titles[indexPath.row];
//        cell.imageView.image = 
    } else if (indexPath.section == 1){
        NSArray *titles = @[@"John Appleseed", @"John Doe", @"Test User"];
        cell.textLabel.text = titles[indexPath.row];
    }
    
    return cell;
}

- (void)exitApplication {
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    UIWindow *window = app.window;
    
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
}
@end
