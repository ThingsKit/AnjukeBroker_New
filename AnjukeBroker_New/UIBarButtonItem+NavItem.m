//
//  UIBarButtonItem+NavItem.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-4-22.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "UIBarButtonItem+NavItem.h"
#import "Util_UI.h"

@implementation UIBarButtonItem (NavItem)
+ (UIBarButtonItem *)getBackBarButtonItemForNormal:(id)taget action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 48, 24);
    [btn setBackgroundImage:[UIImage imageNamed:@"anjuke_icon_back"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"anjuke_icon_back_press"] forState:UIControlStateHighlighted];
    [btn addTarget:taget action:action forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    buttonItem.target = self;
    return buttonItem;
}
+ (UIBarButtonItem *)getBackBarButtonItemForPresent:(id)taget action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 48, 24);
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitle:@"取消" forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btn addTarget:taget action:action forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    buttonItem.target = self;
    return buttonItem;
}
+ (UIBarButtonItem *)getBarButtonItemWithString:(NSString *)titleStr taget:(id)taget action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 48, 24);
    [btn setTitle:titleStr forState:UIControlStateNormal];
    [btn setTitle:titleStr forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[Util_UI colorWithHexString:@"515762"] forState:UIControlStateHighlighted];
    [btn addTarget:taget action:action forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return buttonItem;
}
+ (UIBarButtonItem *)getBarButtonItemWithImage:(UIImage *)normalImg highLihtedImg:(UIImage *)highLihtedImg taget:(id)taget action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 58, 44);
    [btn setBackgroundImage:normalImg forState:UIControlStateNormal];
    [btn setBackgroundImage:highLihtedImg forState:UIControlStateHighlighted];
    [btn addTarget:taget action:action forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    buttonItem.target = self;
    return buttonItem;
}
+ (UIBarButtonItem *)getBarSpace{
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = -10.0f;
    
    return spacer;
}

@end
