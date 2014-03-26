//
//  ClientDetailCell.h
//  AnjukeBroker_New
//
//  Created by paper on 14-2-20.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RTListCell.h"

#define CLIENT_DETAIL_TEL_HEIGHT 45
#define CLIENT_DETAIL_MESSAGE_HEIGHT 90

@interface ClientDetailCell : RTListCell

@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UILabel *detailLb;

- (BOOL)configureCell:(id)dataModel withIndex:(int)index isBlankStyle:(BOOL)isBlankStyle;

@end
