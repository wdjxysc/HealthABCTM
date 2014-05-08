//
//  UISwitch_Text.m
//  BTLE
//
//  Created by 夏 伟 on 13-12-31.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import "UISwitch+Text.h"

#define TAG_OFFSET      900

@implementation UISwitch(Text)
- (void) locateAndTagAndTag: (UIView *) aView withCount:(int *) count
{
    for (UIView *subview in [aView subviews])
    {
        if ([subview isKindOfClass:[UILabel class]])
        {
            *count += 1;
            [subview setTag:(TAG_OFFSET + *count)];
        }
        else
            [self locateAndTagAndTag:subview withCount:count];
    }
}

- (UILabel *) label1
{
    return (UILabel *) [self viewWithTag:TAG_OFFSET + 1];
}

- (UILabel *) label2
{
    return (UILabel *) [self viewWithTag:TAG_OFFSET + 2];
}

+ (UISwitch *) switchWithLeftText: (NSString *) tag1 andRight: (NSString *) tag2
{
    UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
    int labelCount = 0;
//    UILabel *mylabel = [[UILabel alloc]init];
    [switchView locateAndTagAndTag:switchView withCount:&labelCount];
    if (labelCount == 2)
    {
        [switchView.label1 setText:tag1];
        [switchView.label2 setText:tag2];
    }
    return switchView;
}
@end
