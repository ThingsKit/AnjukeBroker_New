//
//  PublishFeatureViewController.h
//  AnjukeBroker_New
//
//  Created by paper on 14-4-21.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RTViewController.h"

@protocol PublishFeatureDelegate <NSObject>

- (void)didPropertyFeatureSelectWithIsFiveYear:(BOOL)isFiveYear isOnlyHouse:(BOOL)isOnlyHouse;

@end

@interface PublishFeatureViewController : RTViewController <UITableViewDataSource, UITableViewDelegate>

@property BOOL isFiveYear;
@property BOOL isOnlyHouse;
@property id <PublishFeatureDelegate> featureDelegate;

@end
