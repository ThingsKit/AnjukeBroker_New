//
//  AXChatMessagePublicCard2Cell.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-17.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "AXChatMessageRootCell.h"

@class AXChatMessagePublicCard2Cell;
@protocol AXChatMessagePublicCard2CellDelegate <NSObject>
@optional
- (void)didOpenPublicCard2:(AXChatMessagePublicCard2Cell *)cell senderInfo:(NSDictionary *)senderInfo;
@end

@interface AXChatMessagePublicCard2Cell : AXChatMessageRootCell

@property(nonatomic, assign) id<AXChatMessagePublicCard2CellDelegate> pcCardCell2Delegate;

@end
