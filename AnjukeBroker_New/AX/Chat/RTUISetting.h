//
//  RTUISetting.h
//  UIComponents
//
//  Created by liu lh on 13-6-6.
//  Copyright (c) 2013年 anjuke inc. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIColor+RT.h"
#import "UIImage+RTStyle.h"

typedef NS_ENUM(NSInteger, UIStyle) {
    NoneStyle = 0,
    AnjukeStyle,
    HaozuStyle,
    JinpuStyle,
    AifangStyle,
};

@interface RTUISetting : NSObject

+ (void)setUIStyle:(UIStyle)style;
+ (UIStyle)getUIStyle;

@end


@interface UIFont (RTUI)

+ (UIFont *)huge1Font;
+ (UIFont *)huge2Font;
+ (UIFont *)largeFont;
+ (UIFont *)medium1Font;
+ (UIFont *)medium2Font;
+ (UIFont *)small1Font;
+ (UIFont *)small2Font;
+ (UIFont *)microFont;

@end

@interface UIColor (RTUI)

+ (UIColor *)appDarkColor;
+ (UIColor *)appLightColor;

+ (UIColor *)mainBackgroundColor;
+ (UIColor *)mainSelectedBackgroundColor;
+ (UIColor *)filterBackgroundColor;
+ (UIColor *)filterBackgroundSelectedColor;
+ (UIColor *)nickLineColor1;
+ (UIColor *)nickLineColor2;
+ (UIColor *)filterLineColor1;
+ (UIColor *)filterLineColor2;
+ (UIColor *)navigationTitleColor;
+ (UIColor *)majorTitleColor;
+ (UIColor *)minorTitleColor;
+ (UIColor *)filterMajorTitleColor;
+ (UIColor *)filterMinorTitleColor;
+ (UIColor *)priceTitleColor;
+ (UIColor *)tabSelectionIndicatorColor;
+ (UIColor *)grayLineColor;

@end

@interface UIImage (RTIcon)

+ (UIImage *)iconForBuilding;
+ (UIImage *)iconForBuildingSelected;

+ (UIImage *)iconForCheckIn;
+ (UIImage *)iconForCheckInSelected;

+ (UIImage *)iconForBuy;
+ (UIImage *)iconForBuySelected;

+ (UIImage *)iconForPPC;
+ (UIImage *)iconForPPCSelected;

+ (UIImage *)iconForHouse;
+ (UIImage *)iconForHouseSelected;

+ (UIImage *)iconForInfo;
+ (UIImage *)iconForInfoSelected;

+ (UIImage *)iconForMore;
+ (UIImage *)iconForMoreSelected;

+ (UIImage *)iconForAdd;
+ (UIImage *)iconForAddSelected;

+ (UIImage *)iconForUser;
+ (UIImage *)iconForUserSelected;

+ (UIImage *)iconForArea;
+ (UIImage *)iconForAreaSelected;
+ (UIImage *)iconForNearBy;
+ (UIImage *)iconForNearBySelected;
+ (UIImage *)iconForMap;
+ (UIImage *)iconForMapSelected;

+ (UIImage *)iconForTriangleUp;
+ (UIImage *)iconForTriangleDown;

+ (UIImage *)iconForArrowDown;
+ (UIImage *)iconForArrowRight;

+ (UIImage *)iconForCellError;
+ (UIImage *)iconForNavBack;
+ (UIImage *)iconForNavBackSelected;

+ (UIImage *)iconForTuangou;
+ (UIImage *)iconForDiscount;

+ (UIImage *)imageForBtn;
+ (UIImage *)imageForBtnHighlighted;

@end

@interface UIImage (RTTabIcon)

+ (UIImage *)tabImage;
+ (UIImage *)tabSelectedImage;

@end

@interface UIImage (RTFunctionSwitch)

+ (UIImage *)functionSwitchBackground;
+ (UIImage *)functionSwitchBackgroundSelected;
+ (UIImage *)functionSwitchLine;
+ (UIImage *)functionSwitchTitle;

@end

@interface UIImage (RTFilter)

+ (UIImage *)filterBackground;
+ (UIImage *)filterBackgroundSelected;
+ (UIImage *)filterSelectedIndicator;
+ (UIImage *)filterLine;
+ (UIImage *)filterCellLineSelected;


@end

@interface UIImage (RTNavgation)

+ (UIImage *)navBgImage;
+ (UIImage *)navBarItemImage;
+ (UIImage *)navBackBarItemImage;

@end

@interface UIImage (RTResult)

+ (UIImage *)noImageForList;
+ (UIImage *)noImageForDetail;
+ (UIImage *)noDataForList;
+ (UIImage *)noCityForApp;
+ (UIImage *)noNetwork;
+ (UIImage *)noResultForHouse;
+ (UIImage *)noResultForBuilding;
+ (UIImage *)noResultForRecord;
+ (UIImage *)noResultForBuy;
+ (UIImage *)noResultForSaearchAndReion;

@end

@interface NSArray (RTUIStyle)

+ (NSArray *)tabTitles;
+ (NSArray *)tabIcons;
+ (NSArray *)tabSelectedIcons;
+ (NSArray *)nickColors;
+ (NSArray *)detailPageTopLineColors;
+ (NSArray *)detailPageBottomLineColors;

@end
