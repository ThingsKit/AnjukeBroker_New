//
//  PropertyModel.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-13.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "BaseModel.h"
#import "CommunityModel.h"

@interface PropertyModel : BaseModel

@property (nonatomic, copy) NSString* status;
@property (nonatomic, retain) CommunityModel* community;

@end
