//
//  houseSelectCommunityCell.h
//  AnjukeBroker_New
//
//  Created by shan xu on 14-2-26.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RTListCell.h"
#import "Util_UI.h"

@interface HouseSelectCommunityCell : RTListCell

@property(nonatomic,strong) UILabel *communityNameLab;
@property(nonatomic,strong) UILabel *detailLab;

-(void)insertCellWithDic:(NSDictionary *)dic;

@end
