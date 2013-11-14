//
//  Property.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-14.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Property : NSManagedObject

@property (nonatomic, retain) NSString * fileNo;
@property (nonatomic, retain) NSString * comm_id;
@property (nonatomic, retain) NSString * rooms;
@property (nonatomic, retain) NSString * area;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * fitment;
@property (nonatomic, retain) NSString * exposure;
@property (nonatomic, retain) NSString * floor;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * imageJson;
@property (nonatomic, retain) NSString * rentType;

@end
