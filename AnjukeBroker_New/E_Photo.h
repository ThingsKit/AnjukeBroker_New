//
//  E_Photo.h
//  AnjukeBroker_New
//
//  Created by paper on 14-1-25.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface E_Photo : NSManagedObject

@property (nonatomic, retain) NSDate * addTime;
@property (nonatomic, retain) NSString * errorMessage;
@property (nonatomic, retain) NSNumber * flag;
@property (nonatomic, retain) id imageDic;
@property (nonatomic, retain) NSString * imageJson;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lng;
@property (nonatomic, retain) NSString * photoURL;
@property (nonatomic, retain) NSString * smallPhotoUrl;
@property (nonatomic, retain) NSNumber * style;

@end
