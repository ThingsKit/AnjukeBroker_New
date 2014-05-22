//
//  UILabel+TitleView.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-4-22.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "UILabel+TitleView.h"
#import "Util_UI.h"

@implementation UILabel (TitleView)
+ (UILabel *)getTitleView:(NSString *)titleStr{
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 31)];
    lb.backgroundColor = [UIColor clearColor];
    lb.font = [UIFont ajkH1Font];
    lb.text = titleStr;
    lb.textColor = [UIColor whiteColor];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.textColor = SYSTEM_NAVIBAR_COLOR;

    return lb;
}

@end
