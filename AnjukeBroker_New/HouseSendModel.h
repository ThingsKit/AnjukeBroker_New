//
//  HouseSendModel.h
//  AnjukeBroker_New
//
//  Created by anjuke on 14-6-25.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "BaseModel.h"

@interface HouseSendModel : BaseModel

@property (nonatomic, strong)NSString *price;
@property (nonatomic, strong)NSString *img;
@property (nonatomic, strong)NSString *id;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *tradeType;
@property (nonatomic, strong)NSString *des;
@property (nonatomic, strong)NSString *url;


- (NSDictionary *)objToDict;
@end
