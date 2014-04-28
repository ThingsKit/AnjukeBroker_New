//
//  LocationManager.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 3/31/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AXMappedMessage.h"

@interface LocationManager : NSObject
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, strong) void(^resultBlock)(RTNetworkResponse *);
+(instancetype)defaultLocationManager;
- (void)cancellRequest;
- (void)geoWithLatAndLng:(NSString *)lat lng:(NSString *)lng target:(id)target action:(SEL)action;
- (void)locationByMessage:(AXMappedMessage *)message target:(id)target action:(SEL)action;
- (void)dowloadIMGWithURL:(NSURL *)url target:(id)target action:(SEL)action;
- (void)dowloadIMGWithURL:(NSURL *)url resultBlock:(void(^)(RTNetworkResponse *))resultBlock;
@end
