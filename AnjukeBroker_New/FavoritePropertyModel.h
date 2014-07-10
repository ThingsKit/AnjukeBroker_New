//
//  FavoritePropertyModel.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-6-11.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "BaseModel.h"

@interface FavoritePropertyModel : BaseModel

@property (nonatomic, copy) NSString* title;  //房源标题
@property (nonatomic, copy) NSString* pic; //房源图片
@property (nonatomic, copy) NSString* block;   //房源所属板块
@property (nonatomic, copy) NSString* community; //房源所属小区
@property (nonatomic, copy) NSString* type; //室
@property (nonatomic, copy) NSString* area;   //面积
@property (nonatomic, copy) NSString* price;  //价格或租金

@end
