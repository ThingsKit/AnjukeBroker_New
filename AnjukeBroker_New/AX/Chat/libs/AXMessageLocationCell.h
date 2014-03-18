//
//  AXMessageLocationCell.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 3/18/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AXChatMessageRootCell.h"

@interface AXMessageLocationCell : AXChatMessageRootCell
@property (nonatomic, strong) UIImageView *mapIMGView;
@property (nonatomic, strong) UILabel *locationLabel;
@end
