//
//  AXPublicSubMenu.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-13.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AXPublicMenuButton.h"

typedef NS_ENUM(NSInteger, AXPublicSubMenuType) {
//    AXPublicSubMenuTypeSubMenu = 0,
    AXPublicSubMenuTypeAPI = 0,
    AXPublicSubMenuTypeWebView = 1
};

@protocol AXPublicSubMenuDelegate <NSObject>
@optional
- (void)publicSubMenuWithAPI:(NSString *)actionStr;
- (void)publicSubMenuWithURL:(NSString *)webURL;
@end


@interface AXPublicSubMenu : UIView
@property(nonatomic, assign) id<AXPublicSubMenuDelegate> publicSubMenuDelegate;

- (void)configPublicSubMenu:(AXPublicMenuButton *)button menu:(NSArray *)menus;

@end
