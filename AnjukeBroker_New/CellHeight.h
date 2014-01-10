//
//  CellHeight.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 12/26/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CellHeight : NSObject
+ (CGFloat)getBidCellHeight:(NSString *) title;
+ (CGFloat)getFixedCellHeight:(NSString *) title;
+ (CGFloat)getNoPlanCellHeight:(NSString *) title;

@end
