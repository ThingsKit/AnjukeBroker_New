//
//  CustomerListModel.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-6-17.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "BaseModel.h"

@interface CustomerListModel : BaseModel

@property (nonatomic, copy) NSString* count;
@property (nonatomic, copy) NSString* is_next_page;
@property (nonatomic, copy) NSString* broker_rush_count;
@property (nonatomic, strong) NSMutableArray* list;

@end
