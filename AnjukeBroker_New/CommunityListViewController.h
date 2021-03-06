//
//  CommunityListViewController.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-5.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "RTViewController.h"

typedef enum {
    DataTypeKeywords = 0, //关键词数据
    DataTypeHistory, //历史小区列表
    DataTypeNearby //附近小区列表
} ListDataType;

@protocol CommunitySelectDelegate <NSObject>

- (void)communityDidSelect:(NSDictionary *)commDic;

@end

@interface CommunityListViewController : RTViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) ListDataType listType;
@property (nonatomic, assign) id <CommunitySelectDelegate> communityDelegate;
@property BOOL isHaouzu; //区分二手房、租房的历史、附近数据
@property BOOL isFirstShow; //是否是首次选择小区，否则点击小区后进行回调，是则点击后push进发房页

@end
