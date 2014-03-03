//
//  RTUISetting.m
//  UIComponents
//
//  Created by liu lh on 13-6-6.
//  Copyright (c) 2013年 anjuke inc. All rights reserved.
//

#import "RTUISetting.h"
#import "RTTabBarItem.h"

#define UIStyle_Key @"anjuke_UIStyle"

@implementation RTUISetting


+ (void)setUIStyle:(UIStyle)style{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:style] forKey:UIStyle_Key];
    [self setNavigationBar];
}

+ (UIStyle)getUIStyle{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:UIStyle_Key] integerValue];
}

+ (void)setNavigationBar{
    UIImage *navBackgroundImage;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        navBackgroundImage = [UIImage getStyleBundleImage:@"anjuke_navbar_ios7.png"];
    } else {
        navBackgroundImage = [UIImage navBgImage];
    }
    [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
    [[UILabel appearance] setBackgroundColor:[UIColor clearColor]];
    
    [[UISearchBar appearance] setSearchFieldBackgroundImage:[[UIImage getStyleBundleImage:@"anjuke_50bg_04.png"] autoResizableImage] forState:UIControlStateDisabled];
    [[UISearchBar appearance] setSearchFieldBackgroundImage:[[UIImage getStyleBundleImage:@"anjuke_50bg_03.png"] autoResizableImage] forState:UIControlStateNormal];
}

@end


@implementation UIFont (RTUI)

+ (UIFont *)huge1Font{
    return [UIFont systemFontOfSize:18];
}

+ (UIFont *)huge2Font{
    return [UIFont systemFontOfSize:17];
}

+ (UIFont *)largeFont{
    return [UIFont systemFontOfSize:14];
}

+ (UIFont *)medium1Font{
    return [UIFont systemFontOfSize:13];
}

+ (UIFont *)medium2Font{
    return [UIFont systemFontOfSize:12];
}

+ (UIFont *)small1Font{
    return [UIFont systemFontOfSize:11];
}

+ (UIFont *)small2Font{
    return [UIFont systemFontOfSize:10];
}

+ (UIFont *)microFont{
    return [UIFont systemFontOfSize:9];
}

@end

@implementation UIColor (RTUI)

+ (UIColor *)anjukeDarkGreen{
    return [UIColor colorWithHex:0x77B400 alpha:1];
}

+ (UIColor *)anjukeLightGreen{
    return [UIColor colorWithHex:0x4A9200 alpha:1];
}

+ (UIColor *)haozuDarkBlue{
    return [UIColor colorWithHex:0x0B6ABF alpha:1];
}

+ (UIColor *)haozuLightBlue{
    return [UIColor colorWithHex:0x0D99E3 alpha:1];
}

+ (UIColor *)jinpuDarkOrange{
    return [UIColor colorWithHex:0xFF7721 alpha:1];
}

+ (UIColor *)jinpuLightOrange{
    return [UIColor colorWithHex:0xFF923B alpha:1];
}

+ (UIColor *)appDarkColor{
    switch ([RTUISetting getUIStyle]) {
        case AnjukeStyle:
            return [self anjukeDarkGreen];
            break;
        case HaozuStyle:
            return [self haozuDarkBlue];
            break;
        case JinpuStyle:
            return [self jinpuDarkOrange];
            break;
        case AifangStyle:
            return [self anjukeDarkGreen];
            break;
        default:
            return nil;
            break;
    }
}

+ (UIColor *)appLightColor{
    switch ([RTUISetting getUIStyle]) {
        case AnjukeStyle:
            return [self anjukeLightGreen];
            break;
        case HaozuStyle:
            return [self haozuLightBlue];
            break;
        case JinpuStyle:
            return [self jinpuLightOrange];
            break;
        case AifangStyle:
            return [self anjukeLightGreen];
            break;
        default:
            return nil;
            break;
    }
}

+ (UIColor *)mainBackgroundColor{
    return [UIColor colorWithHex:0xF8F8F8 alpha:1];
}

+ (UIColor *)mainSelectedBackgroundColor{
    return [UIColor colorWithHex:0xEAEAEA alpha:1];
}

+ (UIColor *)filterBackgroundColor{
    return [UIColor colorWithHex:0xFCFCFC alpha:1];
}

+ (UIColor *)filterBackgroundSelectedColor{
    return [UIColor colorWithHex:0xF1F1F1 alpha:1];
}

+ (UIColor *)nickLineColor1{
    return [UIColor colorWithHex:0xC0C0C0 alpha:1];
}

+ (UIColor *)nickLineColor2{
    return [UIColor colorWithHex:0xFFFFFF alpha:1];
}

+ (UIColor *)filterLineColor1{
    return [UIColor colorWithHex:0xE6E6E6 alpha:1];
}

+ (UIColor *)filterLineColor2{
    return [UIColor colorWithHex:0xFFFFFF alpha:1];
}

+ (UIColor *)navigationTitleColor{
    return [UIColor colorWithHex:0xFFFFFF alpha:1];
}

+ (UIColor *)majorTitleColor{
    return [UIColor colorWithHex:0x222222 alpha:1];
}

+ (UIColor *)minorTitleColor{
    return [UIColor colorWithHex:0x333333 alpha:1];
}

+ (UIColor *)filterMajorTitleColor{
    return [UIColor colorWithHex:0x666666 alpha:1];
}

+ (UIColor *)filterMinorTitleColor{
    return [UIColor colorWithHex:0x949494 alpha:1];
}

+ (UIColor *)priceTitleColor{
    return [UIColor colorWithHex:0xFF6600 alpha:1];
}

+ (UIColor *)grayLineColor{
    return [UIColor colorWithHex:0xC0C0C0 alpha:1];
}

+ (UIColor *)tabSelectionIndicatorColor{
    switch ([RTUISetting getUIStyle]) {
        case AnjukeStyle:
            return [self anjukeLightGreen];
            break;
        case HaozuStyle:
            return [self haozuLightBlue];
            break;
        case JinpuStyle:
            return [self jinpuLightOrange];
            break;
        case AifangStyle:
            return [self anjukeLightGreen];
            break;
        default:
            return nil;
            break;
    }
}

@end


@implementation UIImage (RTIcon)


+ (UIImage *)iconForBuilding{
    return [self getStyleBundleImage:@"rt_icon_tab_building.png"];
}

+ (UIImage *)iconForBuildingSelected{
    return [self getStyleBundleImage:@"rt_icon_tab_building_press.png"];
}

+ (UIImage *)iconForCheckIn{
    return [self getStyleBundleImage:@"rt_icon_tab_checkin.png"];
}

+ (UIImage *)iconForCheckInSelected{
    return [self getStyleBundleImage:@"rt_icon_tab_checkin_press.png"];
}


+ (UIImage *)iconForBuy{
    return [self getStyleBundleImage:@"rt_icon_tab_groupbuying.png"];
}

+ (UIImage *)iconForBuySelected{
    return [self getStyleBundleImage:@"rt_icon_tab_groupbuying_press.png"];
}


+ (UIImage *)iconForPPC{
    return [self getStyleBundleImage:@"rt_icon_tab_haopan.png"];
}

+ (UIImage *)iconForPPCSelected{
    return [self getStyleBundleImage:@"rt_icon_tab_haopan_press.png"];
}


+ (UIImage *)iconForHouse{
    return [self getStyleBundleImage:@"rt_icon_tab_house.png"];
}

+ (UIImage *)iconForHouseSelected{
    return [self getStyleBundleImage:@"rt_icon_tab_house_press.png"];
}


+ (UIImage *)iconForInfo{
    return [self getStyleBundleImage:@"rt_icon_tab_info.png"];
}

+ (UIImage *)iconForInfoSelected{
    return [self getStyleBundleImage:@"rt_icon_tab_info_press.png"];
}


+ (UIImage *)iconForMore{
    return [self getStyleBundleImage:@"rt_icon_tab_more.png"];
}

+ (UIImage *)iconForMoreSelected{
    return [self getStyleBundleImage:@"rt_icon_tab_more_press.png"];
}


+ (UIImage *)iconForAdd{
    return [self getStyleBundleImage:@"rt_icon_tab_publish.png"];
}

+ (UIImage *)iconForAddSelected{
    return [self getStyleBundleImage:@"rt_icon_tab_publish_press.png"];
}


+ (UIImage *)iconForUser{
    return [self getStyleBundleImage:@"rt_icon_tab_user.png"];
}

+ (UIImage *)iconForUserSelected{
    return [self getStyleBundleImage:@"rt_icon_tab_user_press.png"];
}


+ (UIImage *)iconForArea{
    return [self getStyleBundleImage:@"rt_icon_area.png"];
}

+ (UIImage *)iconForAreaSelected{
     return [self getStyleBundleImage:@"rt_icon_area.png"];
}

+ (UIImage *)iconForNearBy{
    return [self getStyleBundleImage:@"rt_icon_nearby.png"];
}

+ (UIImage *)iconForNearBySelected{
     return [self getStyleBundleImage:@"rt_icon_nearby.png"];   
}

+ (UIImage *)iconForMap{
    return [self getStyleBundleImage:@"rt_icon_map.png"];
}

+ (UIImage *)iconForMapSelected{
    return [self getStyleBundleImage:@"rt_icon_map.png"];
}

+ (UIImage *)iconForTriangleUp{
    return [self getStyleBundleImage:@"rt_triangle_up.png"];    
}

+ (UIImage *)iconForTriangleDown{
    return [self getStyleBundleImage:@"rt_triangle_down.png"];    
}

+ (UIImage *)iconForArrowDown{
    return [self getStyleBundleImage:@"rt_arrow_down.png"];    
}

+ (UIImage *)iconForArrowRight{
    return [self getStyleBundleImage:@"rt_arrows_right.png"];    
}

+ (UIImage *)iconForCellError{
    return [self getStyleBundleImage:@"rt_icon_cell_failed.png"];    
}

+ (UIImage *)iconForNavBack{
    return [self getStyleBundleImage:@"anjuke_50icon06_normal.png"];  
}

+ (UIImage *)iconForNavBackSelected{
    return [self getStyleBundleImage:@"anjuke_50icon06_selected.png"];   
}

+ (UIImage *)iconForTuangou{
    return [self getStyleBundleImage:@"icon_tuangou_in_list.png"];
}

+ (UIImage *)iconForDiscount{
    return [self getStyleBundleImage:@"details_icon4_1008.png"];    
}

+ (UIImage *)imageForBtn{
    return [self getStyleBundleImage:@"anjuke_btn_normal.png"];    
}

+ (UIImage *)imageForBtnHighlighted{
    return [self getStyleBundleImage:@"anjuke_btn_selected.png"];
}
@end

@implementation UIImage (RTTabIcon)

+ (UIImage *)tabImage{
    return [self getStyleBundleImage:@"rt_tab_bg.png"];
}

+ (UIImage *)tabSelectedImage{
    return [self getStyleBundleImage:@"rt_tab_press.png"];
}

@end

@implementation UIImage (RTFunctionSwitch)


+ (UIImage *)functionSwitchBackground{
    return [self getStyleBundleImage:@"rt_function_switch_bg.png"];
}

+ (UIImage *)functionSwitchBackgroundSelected{
    return [self getStyleBundleImage:@"rt_function_switch_bg_press.png"];
}

+ (UIImage *)functionSwitchLine{
    return [self getStyleBundleImage:@"rt_function_switch_line.png"];
}

+ (UIImage *)functionSwitchTitle{
    return [self getStyleBundleImage:@"rt_function_switch_title_bg.png"];
}

@end

@implementation UIImage (RTFilter)

+ (UIImage *)filterBackground{
    return [self getStyleBundleImage:@"rt_filter_bg.png"];
}

+ (UIImage *)filterBackgroundSelected{
    return [self getStyleBundleImage:@"rt_filter_bg_press.png"];
}

+ (UIImage *)filterSelectedIndicator{
    return [self getStyleBundleImage:@"rt_filter_selectedindicator.png"];
}

+ (UIImage *)filterLine{
    return [self getStyleBundleImage:@"rt_filter_line.png"];
}

+ (UIImage *)filterCellLineSelected{
    return [self getStyleBundleImage:@"rt_filter_cell_selectedline.png"];
}



@end

@implementation UIImage (RTNavgation)

+ (UIImage *)navBgImage{
    return [UIImage createImageWithColor:[UIColor colorWithHex:0x60a410 alpha:1]];
}

+ (UIImage *)navBarItemImage{
    return [self getStyleBundleImage:@"rt_nav_item.png"];
}

+ (UIImage *)navBackBarItemImage{
    return [self getStyleBundleImage:@"rt_nav_backitem.png"];
}

@end

@implementation UIImage (RTResult)

+ (UIImage *)noImageForList{
    return [self getStyleBundleImage:@"rt_nopic_list.png"];  
}

+ (UIImage *)noImageForDetail{
    return [self getStyleBundleImage:@"rt_nopic_prop.png"];
}

+ (UIImage *)noDataForList{
    return [self getStyleBundleImage:@"rt_nodata.png"];
}

+ (UIImage *)noCityForApp{
    return [self getStyleBundleImage:@"rt_nocity.png"];
}

+ (UIImage *)noNetwork{
    return [self getStyleBundleImage:@"anjuke52_nosignal.png"];
}

+ (UIImage *)noResultForHouse{
    return [self getStyleBundleImage:@"rt_nodata.png"];
}

+ (UIImage *)noResultForBuilding{
    return [self getStyleBundleImage:@"rt_nodata.png"];
}

+ (UIImage *)noResultForRecord{
    return [self getStyleBundleImage:@"rt_nodata.png"];
}

+ (UIImage *)noResultForBuy{
    return [self getStyleBundleImage:@"rt_nodata.png"];
}

+ (UIImage *)noResultForSaearchAndReion{
    return [self getStyleBundleImage:@"anjuke52_noresult.png"];
}
@end


@implementation NSArray (RTUIStyle)

+ (NSArray *)tabTitles{
    switch ([RTUISetting getUIStyle]) {
        case AnjukeStyle:
            return @[@"二手房", @"我的", @"更多"];
            break;
        case HaozuStyle:
            return @[@"二手房", @"我的", @"更多"];
            break;
        case JinpuStyle:
            return @[@"二手房", @"我的", @"更多"];
            break;
        case AifangStyle:
            return @[@"楼盘", @"新房", @"团购", @"我的"];
            break;
        default:
            return nil;
            break;
    }
}

+ (NSArray *)tabIcons{
    switch ([RTUISetting getUIStyle]) {
        case AnjukeStyle:
            return @[[UIImage iconForHouse], [UIImage iconForUser], [UIImage iconForMore]];
            break;
        case HaozuStyle:
            return @[[UIImage iconForBuilding], [UIImage iconForAdd], [UIImage iconForUser]];
            break;
        case AifangStyle:
            return @[[UIImage iconForBuilding], [UIImage iconForHouse], [UIImage iconForBuy], [UIImage iconForUser]];
            break;
        default:
            return nil;
            break;
    }
}

+ (NSArray *)tabSelectedIcons{
    switch ([RTUISetting getUIStyle]) {
        case AnjukeStyle:
            return @[[UIImage iconForHouseSelected], [UIImage iconForUserSelected], [UIImage iconForMoreSelected]];
            break;
        case HaozuStyle:
            return @[[UIImage iconForBuildingSelected], [UIImage iconForAddSelected], [UIImage iconForUserSelected]];
            break;
        case AifangStyle:
            return @[[UIImage iconForBuildingSelected], [UIImage iconForHouseSelected], [UIImage iconForBuySelected], [UIImage iconForUserSelected]];
            break;
        default:
            return nil;
            break;
    }
}

+ (NSArray *)nickColors{
    return @[[UIColor nickLineColor1], [UIColor nickLineColor2]];
}

+ (NSArray *)detailPageTopLineColors {
    return @[[UIColor ajkLineColor], [UIColor nickLineColor2]];
}

+ (NSArray *)detailPageBottomLineColors {
    return @[[UIColor nickLineColor2], [UIColor ajkLineColor]];
}

@end

