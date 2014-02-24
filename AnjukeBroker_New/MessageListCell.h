//
//  MessageListCell.h
//  AnjukeBroker_New
//
//  Created by paper on 14-2-18.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RTListCell.h"
#import "WebImageView.h"

#define MESSAGE_LIST_HEIGHT 60

#define IMG_ICON_H 40

@interface MessageListCell : RTListCell

@property (nonatomic, strong) WebImageView *imageIcon;
@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *messageLb;
@property (nonatomic, strong) UILabel *timeLb;
@property (nonatomic, strong) UILabel *iconNumLb;

@end
