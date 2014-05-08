//
//  UISwitch_Text.h
//  BTLE
//
//  Created by 夏 伟 on 13-12-31.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UISwitch(Text)

+ (UISwitch *) switchWithLeftText: (NSString *) tag1 andRight: (NSString *) tag2;
@property (nonatomic, readonly) UILabel *label1;
@property (nonatomic, readonly) UILabel *label2;

@end