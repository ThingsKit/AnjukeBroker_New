//
//  HomeCell.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-9.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RTListCell.h"

@interface HomeCell : RTListCell
@property(nonatomic, strong) UILabel *cellTit;
@property(nonatomic, strong) UILabel *cellDes;


- (void)configWithModel:(id)model indexPath:(NSIndexPath *)indexPath;
@end
