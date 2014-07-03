//
//  FirstViewController.h
//  Tel
//
//  Created by xubing on 13-12-20.
//  Copyright (c) 2013年 xubing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+AIFFrame.h"
#import "RTViewController.h"

@protocol WorkPropertyDelegate <NSObject>
- (void)processWorkPropertyNameWithDic:(NSDictionary *)dic;
- (void)processWorkPropertyNameDirectBackWithDic:(NSDictionary *)dic;
@end

@interface WorkPropertyViewController : RTViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSIndexPath *currentIndex;
@property (nonatomic, strong) id <WorkPropertyDelegate> delegate;
@property (nonatomic, strong) NSDictionary *selectCellInfo;
@property (nonatomic) int tag;

@end
