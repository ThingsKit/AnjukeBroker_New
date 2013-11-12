//
//  E_Photo.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-12.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface E_Photo : NSManagedObject

@property (nonatomic, retain) NSDate * addTime;
@property (nonatomic, retain) NSString * assetURL;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * entry;
@property (nonatomic, retain) NSString * errorMessage;
@property (nonatomic, retain) NSNumber * flag;
@property (nonatomic, retain) NSString * imageJson;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lng;
@property (nonatomic, retain) NSString * photoID;
@property (nonatomic, retain) NSString * photoURL;
@property (nonatomic, retain) NSNumber * style;

@end
