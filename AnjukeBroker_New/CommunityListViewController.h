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

@interface CommunityListViewController : RTViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) ListDataType listType;

@end
