//
//  LocationManager.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 3/31/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import "LocationManager.h"
#import "RTRequestProxy.h"

@implementation LocationManager
+(instancetype)defaultLocationManager {
    static LocationManager *location = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (location == nil) {
            location = [[LocationManager alloc] init];
        }
    });
    return location;
}

- (void)geoWithLatAndLng:(NSString *)lat lng:(NSString *)lng target:(id)target action:(SEL)action {
    _target = target;
    _action = action;
    
    [[RTRequestProxy sharedInstance] geoWithLat:lat lng:lng target:self action:@selector(geoDidFinishGetAddress:)];
}

- (void)callBack:(RTNetworkResponse *) response {
    if (_target && [_target respondsToSelector:_action]) {
        [_target performSelectorOnMainThread:_action withObject:response waitUntilDone:NO];
    }
}

- (void)geoDidFinishGetAddress:(RTNetworkResponse *) response {
    NSLog(@"%@",response.content);
    [self callBack:response];
}

@end
