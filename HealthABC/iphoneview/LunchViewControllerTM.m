//
//  LunchViewControllerTM.m
//  HealthABC
//
//  Created by 夏 伟 on 14-4-25.
//  Copyright (c) 2014年 夏 伟. All rights reserved.
//

#import "LunchViewControllerTM.h"
#import "LoginViewControllerTM.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define Screen_height   [[UIScreen mainScreen] bounds].size.height
#define Screen_width    [[UIScreen mainScreen] bounds].size.width

@interface LunchViewControllerTM ()
@property (weak, nonatomic) IBOutlet UIButton *skipBtn;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) IBOutlet UIImageView *launchImageView;

@end

@implementation LunchViewControllerTM

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initMyView];
//    [self showAllFonts];
    [_testLabel setFont:[UIFont fontWithName:@"FZNBSJW--GB1-0" size:36]];
    
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(launchImageViewFunc) object:nil];
    [thread start];
}

-(void)launchImageViewFunc
{
    sleep(3);
    _launchImageView.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAllFonts
{
    //显示系统中所有的字体
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    for (int indFamily=0; indFamily<[familyNames count]; ++indFamily) {
        NSMutableString *string = [NSMutableString stringWithFormat:@"Family name:%@ (Font name:", [familyNames objectAtIndex:indFamily]];
        NSArray *fontNames = [[NSArray alloc] initWithArray: [UIFont fontNamesForFamilyName:[familyNames objectAtIndex:indFamily]]];
        for (int indFont=0; indFont<[fontNames count]; ++indFont) {
            [string appendFormat:@"%@, ", [fontNames objectAtIndex:indFont]];
        }
        [string appendFormat:@")"];
        NSLog(@"%@",string);
        
    }
}

-(void)initMyView
{
    //初始化skipBtn
    [_skipBtn addTarget:self action:@selector(skipBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    _skipBtn.layer.cornerRadius = 6.0;
    [_skipBtn setBackgroundImage:[UIImage imageNamed:@"launchBtn_down"] forState:UIControlStateHighlighted];
    
    //初始化pageControl
    _pageControl.currentPage = 0;
    
    //初始化scrollView
    NSArray *imageArray = [[NSArray alloc]init];
    if (iPhone5) {
        imageArray = [NSArray arrayWithObjects:
                      [UIImage imageNamed:@"TM_launch1_4Inch"],
                      [UIImage imageNamed:@"TM_launch2_4Inch"],
                      [UIImage imageNamed:@"TM_launch3_4Inch"], nil];
    }
    else{
        imageArray = [NSArray arrayWithObjects:
                      [UIImage imageNamed:@"TM_launch1"],
                      [UIImage imageNamed:@"TM_launch2"],
                      [UIImage imageNamed:@"TM_launch3"], nil];
    }
    
    int pageNum = (int)[imageArray count];
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * pageNum, _scrollView.frame.size.height);
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;//是否反弹
    _scrollView.alwaysBounceHorizontal = NO;
    _scrollView.alwaysBounceVertical = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    [_pageControl setNumberOfPages:pageNum];
    for (int i = 0; i < pageNum; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(_scrollView.frame.size.width * i, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        [imageView setImage:imageArray[i]];
        [_scrollView addSubview:imageView];
    }
}

-(void)skipBtnPressed
{
    if(iPhone5){
        LoginViewControllerTM *loginViewControllerTM = [[LoginViewControllerTM alloc]initWithNibName:@"LoginViewControllerTM_4Inch" bundle:nil];
        [self presentViewController:loginViewControllerTM animated:NO completion:^{
            NSLog(@"show loginViewControllerTM");
        }];
    }
    else
    {
        LoginViewControllerTM *loginViewControllerTM = [[LoginViewControllerTM alloc]initWithNibName:@"LoginViewControllerTM" bundle:nil];
        [self presentViewController:loginViewControllerTM animated:NO completion:^{
            NSLog(@"show loginViewControllerTM");
        }];
    }
}

#pragma mark - scrollViewDelegate Methods
/*
 // 返回一个放大或者缩小的视图
 - (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
 {
 
 }
 // 开始放大或者缩小
 - (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
 {
 }
 // 缩放结束时
 - (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
 {
 }
 // 视图已经放大或缩小
 - (void)scrollViewDidZoom:(UIScrollView *)scrollView
 {
 NSLog(@"scrollViewDidScrollToTop");
 }
 */

// 是否支持滑动至顶部
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return NO;
}
// 滑动到顶部时调用该方法
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScrollToTop");
}
// scrollView 已经滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidScroll");
}
// scrollView 开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewWillBeginDragging");
}
// scrollView 结束拖动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"scrollViewDidEndDragging");
}
// scrollView 开始减速（以下两个方法注意与以上两个方法加以区别）
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewWillBeginDecelerating");
}
// scrollview 减速停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
    NSLog(@"scrollViewDidEndDecelerating");
}



@end
