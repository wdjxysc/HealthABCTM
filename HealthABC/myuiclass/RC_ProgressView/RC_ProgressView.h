//
//  RC_ProgressView.h
//  drawtest
//
//  Created by 夏 伟 on 14-3-10.
//  Copyright (c) 2014年 夏 伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RC_ProgressView : UIView

enum
{
    xValue,
    yValue
};

typedef NSUInteger ValueType;
@property NSUInteger valueType;
@property(nonatomic,retain)UIImageView *mainImageView;
@property float oldValue;

-(void)setMainColor : (UIColor *)maincolor;

-(void)doSomething;

-(void)setProgressValue:(float)value;

-(void)setValueType:(ValueType)type;
@end
