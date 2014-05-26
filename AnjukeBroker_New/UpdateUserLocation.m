//
//  UpdateUserLocation.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-26.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "UpdateUserLocation.h"
#import "RTLocationManager.h"
#import "LoginManager.h"

@implementation UpdateUserLocation
@synthesize complecation;
@synthesize isRequestIng;

static UpdateUserLocation *defaultUpdateUserLocation;

- (id)init{
    self = [super init];
    if (self) {
        self.isRequestIng = NO;
    }
    return self;
}

+ (UpdateUserLocation *)shareUpdateUserLocation{
    @synchronized(self){
        if (defaultUpdateUserLocation == nil) {
            defaultUpdateUserLocation = [[UpdateUserLocation alloc] init];
        }
        return defaultUpdateUserLocation;
    }
}

- (void)fetchUserLocationWithComeletionBlock:(void(^)(BOOL updateLocationIsOk))completionBlock{
    self.complecation = completionBlock;
    CLLocationCoordinate2D coordinate = [[RTLocationManager sharedInstance] userLocation].coordinate;
 
    if (self.isRequestIng) {
        return;
    }
    
    self.isRequestIng = YES;
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken], @"token",[LoginManager getUserID],@"brokerId",[NSString stringWithFormat:@"%f",coordinate.latitude],@"lat",[NSString stringWithFormat:@"%f",coordinate.longitude],@"lng", nil];
    
    method = [NSString stringWithFormat:@"broker/updateLocation/"];
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestFinished:)];
}
#pragma mark - request method

- (void)onRequestFinished:(RTNetworkResponse *)response{
    self.isRequestIng = NO;
    
    if([[response content] count] == 0){
        self.complecation(NO);
        return ;
    }
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        self.complecation(NO);
        return;
    }
    if ([[[response content] objectForKey:@"status"] isEqualToString:@"ok"]) {
        self.complecation(YES);
    }else{
        self.complecation(NO);
    }
}

@end

