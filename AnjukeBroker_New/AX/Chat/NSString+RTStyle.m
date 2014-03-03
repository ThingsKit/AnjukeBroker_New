//
//  NSString+RTStyle.m
//  UIComponents
//
//  Created by liu lh on 13-6-21.
//  Copyright (c) 2013年 anjuke inc. All rights reserved.
//

#import "NSString+RTStyle.h"
#import "RTUISetting.h"

@implementation NSString (RTStyle)

+ (NSString *)getCommonBundlePath:(NSString *)fileName{
    NSString *main_images_dir_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"RTCommonImages.bundle"];
    NSAssert(main_images_dir_path, @"main_images_dir_path is null");
    return [main_images_dir_path stringByAppendingPathComponent:fileName];
}

+ (NSString *)getStyleBundlePath:(NSString *)fileName{
    NSString *bundleName = @"";
    switch ([RTUISetting getUIStyle]) {
//        case AnjukeStyle:
//            bundleName = @"AnjukeStyle.bundle";
//            break;
//        case HaozuStyle:
//            bundleName = @"HaozuStyle.bundle";
//            break;
//        case JinpuStyle:
//            bundleName = @"JinpuStyle.bundle";
//            break;
        default:
            bundleName = @"AnjukeStyle.bundle";
            break;
    }
    NSString *main_images_dir_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:bundleName];
    NSAssert(main_images_dir_path, @"main_images_dir_path is null");
    return [main_images_dir_path stringByAppendingPathComponent:fileName];
}

@end
