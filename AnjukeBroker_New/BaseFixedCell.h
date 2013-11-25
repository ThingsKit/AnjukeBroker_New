//
//  BaseFixedCell.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/4/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "RTListCell.h"

@interface BaseFixedCell : RTListCell
{
    
}
@property (strong, nonatomic) UILabel *tapNum;
@property (strong, nonatomic) UILabel *totalCost;
@property (strong, nonatomic) UILabel *topCost;
@property (strong, nonatomic) UILabel *tapNumStr;
@property (strong, nonatomic) UILabel *totalCostStr;
@property (strong, nonatomic) UILabel *topCostStr;
@property (strong, nonatomic) UIImageView *statusimg;

-(BOOL)configureCell:(id)dataModel isAJK:(BOOL) isAJK;

@end
