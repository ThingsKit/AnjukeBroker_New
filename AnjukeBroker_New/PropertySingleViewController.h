//
//  PricePromotionPropertySingleViewController.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-7-1.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RTViewController.h"
#import "PropertyEditViewController.h"

typedef enum {
    PAGE_TYPE_NOT_DEFINED = 0, //未定义
    PAGE_TYPE_FIX,     //从定价列表过来
    PAGE_TYPE_CHOICE,  //从精选列表过来
    PAGE_TYPE_NO_PLAN  //从待推广列表过来
} PageType;

@interface PropertySingleViewController : RTViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, PropertyEditDelegate>

//BOOL isHaozu  区分是二手房还是租房, 1 表示租房, 0表示二手房, 默认二手房
//PageType pageType 用来区分从哪个列表过来
//NSString* propId   房源id
//NSString* cityId   城市id
@property (nonatomic, assign) BOOL isHaozu; //区分是二手房还是租房, 1 表示租房, 0表示二手房, 默认二手房
@property (nonatomic, assign) PageType pageType; //用来标记从那种类型的列表过来
@property (nonatomic, copy) NSString* propId;
@property (nonatomic, assign) NSString* pageId;

@property (nonatomic, assign) id <PropertyEditDelegate> propertyDelegate; //删除房源的回调

//@property(nonatomic, strong) NSMutableDictionary* params; //@"isHaozu", @"pageType", @"propId"

@end
