//
//  AXChatMessagePublicCard2Cell.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-17.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "AXChatBaseCell.h"
#import "AXChatMessageRootCell.h"

@class AXChatMessagePublicCard3Cell;
@protocol AXChatMessagePublicCard3CellDelegate <AXChatBaseCellDelegate>
@optional
- (void)didOpenPublicCard3:(AXChatMessagePublicCard3Cell *)cell senderInfo:(NSDictionary *)senderInfo;
@end

@interface AXChatMessagePublicCard3Cell : AXChatMessageRootCell

@property(nonatomic, assign) id<AXChatMessagePublicCard3CellDelegate> delegate;

- (void)configWithData:(NSDictionary *)data;
@end
