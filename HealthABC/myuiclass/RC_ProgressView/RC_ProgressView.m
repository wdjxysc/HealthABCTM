//
//  RC_ProgressView.m
//  drawtest
//
//  Created by 夏 伟 on 14-3-10.
//  Copyright (c) 2014年 夏 伟. All rights reserved.
//

#import "RC_ProgressView.h"

@implementation RC_ProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.oldValue = 0;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setMainColor:(UIColor *)maincolor
{
    if(self.mainImageView == nil)
    {
        self.mainImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.valueType = yValue;
    }
    self.mainImageView.backgroundColor = maincolor;
    [self addSubview:self.mainImageView];
}

-(void)doSomething
{
    NSLog(@"fasdfsafsadf");
}

-(void)setProgressValue:(float)value
{
    if(self.valueType == yValue){
    [self.mainImageView setFrame:CGRectMake(0, self.frame.size.height*(1-self.oldValue), self.frame.size.width, self.frame.size.height*self.oldValue)];
    
    [UIView beginAnimations:@"myImageViewAnimation" context:(__bridge void *)self.mainImageView];
    
    [UIView setAnimationDuration:0.5f];
    
    [UIView setAnimationDelegate:self];
    //延迟动画时间
//    [UIView setAnimationDelay:3.0f];
    //重复动画次数
//    [UIView setAnimationRepeatCount:4.0f];
    
    [UIView setAnimationDidStopSelector:@selector(imageViewDidStop:finished:context:)];
    
    [self.mainImageView setFrame:CGRectMake(0, self.frame.size.height*(1-value), self.frame.size.width, self.frame.size.height*value)];
    
    [UIView commitAnimations];
    }
    else if(self.valueType == xValue)
    {
        [self.mainImageView setFrame:CGRectMake(0, 0, self.frame.size.width*self.oldValue, self.frame.size.height)];
        
        [UIView beginAnimations:@"myImageViewAnimation" context:(__bridge void *)self.mainImageView];
        
        [UIView setAnimationDuration:0.5f];
        
        [UIView setAnimationDelegate:self];
        //延迟动画时间
        //    [UIView setAnimationDelay:3.0f];
        //重复动画次数
        //    [UIView setAnimationRepeatCount:4.0f];
        
        [UIView setAnimationDidStopSelector:@selector(imageViewDidStop:finished:context:)];
        
        [self.mainImageView setFrame:CGRectMake(0, 0, self.frame.size.width*value, self.frame.size.height)];
        
        [UIView commitAnimations];
    }
    self.oldValue = value;
}

-(void)imageViewDidStop:(NSString *)paramAnimationID finished:(NSString *)paramFinished context:(void *)paramContext
{
//    UIImageView *contextImageView = (__bridge UIImageView *)paramContext;
//    [contextImageView removeFromSuperview];
}

@end
