//
//  ClientListCell.h
//  AnjukeBroker_New
//
//  Created by paper on 14-2-19.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "SWTableViewCell.h"
#import "WebImageView.h"
#import "BrokerLineView.h"

#define CLIENT_LIST_HEIGHT 60
#define IMG_ICON_H 40

@interface ClientListCell : SWTableViewCell
@property (nonatomic, strong) WebImageView *imageIcon;
@property (nonatomic, strong) UILabel *nameLb;
@property (strong, nonatomic) BrokerLineView *lineView;

- (BOOL)configureCellWithData:(id)data;
- (void)showBottonLineWithCellHeight:(CGFloat)cellH andOffsetX:(CGFloat)offsetX;

@end
