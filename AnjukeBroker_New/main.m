//
//  main.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-15.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char * argv[])
{
    @try {
        @autoreleasepool {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
    }
    @catch (NSException *exception) {
        
        [CrashLogUtil saveCrash:exception];
        
        @throw exception;
    }
}
