//
//  AJK_HomeViewController.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-21.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "RTViewController.h"
#import "IMGDowloaderManager.h"
#import "SelectionToolView.h"
#import "SegmentView.h"

@interface HomeViewController : RTViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, SelectionToolViewDelegate, SegmentViewDelegate>

- (void)doRequest;

@property BOOL hasLongLinked;
@property (nonatomic, strong) IMGDowloaderManager *img;


@end
