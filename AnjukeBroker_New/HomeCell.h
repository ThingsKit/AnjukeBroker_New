//
//  HomeCell.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-9.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "RTListCell.h"

@interface HomeCell : RTListCell
@property(nonatomic, strong) UILabel *cellTit;
@property(nonatomic, strong) UILabel *cellDes;
@property(nonatomic, strong) UIView *dotView;
@property(nonatomic, strong) UIImageView *dotImg;
@property(nonatomic, strong) UILabel *dotLab;


- (void)configWithModel:(id)model indexPath:(NSIndexPath *)indexPath;
- (void)showDot:(BOOL)showDot dotNum:(NSInteger)dotNum offsetX:(float)offsetX;

@end
