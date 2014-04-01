//
//  LocationManager.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 3/31/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import "LocationManager.h"
#import "RTRequestProxy.h"
#import "AXMappedMessage.h"
#import "AXNetWorkResponse.h"

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

- (void)cancellRequest {
    [[RTRequestProxy sharedInstance] cancelRequestsWithTarget:self];
}

- (void)geoWithLatAndLng:(NSString *)lat lng:(NSString *)lng target:(id)target action:(SEL)action {
    _target = target;
    _action = action;
    
  int i = [[RTRequestProxy sharedInstance] geoWithLat:lat lng:lng target:self action:@selector(geoDidFinishGetAddress:)];
    AXNetWorkResponse *response = [[AXNetWorkResponse alloc] init];
    response.identify = @"";
    response.requestID = i;
    response.sendStatus = 1;
    [self callBack:response];
}

- (void)locationByMessage:(AXMappedMessage *)message target:(id)target action:(SEL)action {
    _target = target;
    _action = action;
    
    CGFloat locallat = [[message.content JSONValue][@"google_lat"] floatValue];
    CGFloat locallng = [[message.content JSONValue][@"google_lng"] floatValue];

    int i = [[RTRequestProxy sharedInstance] geoWithLat:[NSString stringWithFormat:@"%f", locallat] lng:[NSString stringWithFormat:@"%f", locallng] target:self action:@selector(geoDidFinishGetAddress:)];
    
    AXNetWorkResponse *response = [[AXNetWorkResponse alloc] init];
    response.identify = message.identifier;
    response.requestID = i;
    response.message = message;
    response.sendStatus = 1;
    [self callBack:response];
}
- (void)callBack:(AXNetWorkResponse *) response {
    if (_target && [_target respondsToSelector:_action]) {
        [_target performSelectorOnMainThread:_action withObject:response waitUntilDone:NO];
    }
}

- (void)geoDidFinishGetAddress:(RTNetworkResponse *) response {
    AXNetWorkResponse *axresponse = [[AXNetWorkResponse alloc] init];
    axresponse.response = response;
    axresponse.sendStatus = 2;
    NSLog(@"%@",response.content);
    [self callBack:axresponse];
}

@end
