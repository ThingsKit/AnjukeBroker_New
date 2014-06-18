//
//  AXPublicMenu.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-13.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AXPublicMenuButton.h"

typedef NS_ENUM(NSInteger, AXPublicInputType) {
    AXPublicInputTypeNormal = 1,
    AXPublicInputTypePublicMenu = 2,
    AXPublicInputTypeNormalAndPublicMenu = 3
};


typedef NS_ENUM(NSInteger, AXPublicMenuType) {
    AXPublicMenuTypeSubMenu = 1,
    AXPublicMenuTypeAPI = 2,
    AXPublicMenuTypeWebView = 3
};


@protocol AXPublicMenuDelegate <NSObject>
@optional
- (void)publicMenuShowSubMenu:(AXPublicMenuButton *)button menus:(NSArray *)menus;
- (void)publicMenuWithAPI:(NSString *)actionStr;
- (void)publicMenuWithURL:(NSString *)webURL;
- (void)publicMenuSwich;
@end

@interface AXPublicMenu : UIView

@property(nonatomic, assign) id<AXPublicMenuDelegate> publicMenuDelegate;

- (void)configPublicMenuView:(NSArray *)menus inputType:(AXPublicInputType)inputType;

@end
