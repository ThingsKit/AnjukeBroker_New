//
//  SendPropModel.h
//  AnjukeBroker_New
//
//  Created by anjuke on 14-6-25.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "BaseModel.h"

@interface SendPropModel : BaseModel

@property (nonatomic, strong)NSString *description;
@property (nonatomic, strong)NSDictionary *house;
@property (nonatomic, strong)NSDictionary *model;
@property (nonatomic, strong)NSString *status;

@property (nonatomic, strong)NSString *unid;
@end
