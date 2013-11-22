//
//  PropertyObject.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 房源对象
 
 房源编号:    propertyId
 备案号:   cpip
 图片:   photos
 默认图: defaultImgUrl
 小区名:   communityName
  小区编号:    communityID
 房屋价格:   price  (单位：元， 未带）
 价格单位:   priceUnit
 户型:   type
 房子面积:   area
 物业类型:    tenement
 楼层:       floor
 小区标签:   communityTag
 房源标签:   propertyTag
 房屋类型:    propertyType
 房屋朝向:   orientation
 标题:   title
 描述:   description (单位：元， 未带）
 备注:    mark

 */

@interface BasePropertyObject : NSObject
@property (strong, nonatomic) NSString *propertyId;
@property (strong, nonatomic) NSString *cpip;
@property (strong, nonatomic) NSArray *photos;
@property (strong, nonatomic) NSString *defaultImgUrl;
@property (strong, nonatomic) NSString *communityName;
@property (strong, nonatomic) NSString *communityId;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *priceUnit;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *area;
@property (strong, nonatomic) NSString *tenement;
@property (strong, nonatomic) NSString *floor;
@property (strong, nonatomic) NSString *communityTag;
@property (strong, nonatomic) NSString *propertyTag;
@property (strong, nonatomic) NSString *propertyType;
@property (strong, nonatomic) NSString *orientation;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *mark;
@property (strong, nonatomic) NSString *hallNum;
@property (strong, nonatomic) NSString *roomNum;
@property (strong, nonatomic) NSString *toiletNum;
@property (strong, nonatomic) NSString *isMoreImg;
@property (strong, nonatomic) NSString *isVisible;

- (id)setValueFromDictionary:(NSDictionary *)dic;

@end
