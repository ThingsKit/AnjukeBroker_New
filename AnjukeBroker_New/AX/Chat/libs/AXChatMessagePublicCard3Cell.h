//
//  AXChatMessagePublicCard2Cell.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-17.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "AXChatBaseCell.h"

@class AXChatMessagePublicCard3Cell;
@protocol AXChatMessagePublicCard3CellDelegate <AXChatBaseCellDelegate>
@optional
- (void)didOpenPublicCard3:(AXChatMessagePublicCard3Cell *)cell senderInfo:(NSDictionary *)senderInfo;
@end

@interface AXChatMessagePublicCard3Cell : AXChatBaseCell

@property(nonatomic, assign) id<AXChatMessagePublicCard3CellDelegate> pcCardCell3Delegate;

- (void)configWithData:(NSDictionary *)data;
@end
