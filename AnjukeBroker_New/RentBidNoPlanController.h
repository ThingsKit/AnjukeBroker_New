//
//  RentBidNoPlanController.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/19/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "BaseNoPlanController.h"
#import "FixedObject.h"

@interface RentBidNoPlanController : BaseNoPlanController
@property (strong,nonatomic) NSDictionary *tempDic;
@property (strong, nonatomic) FixedObject *fixedObj;
@end
