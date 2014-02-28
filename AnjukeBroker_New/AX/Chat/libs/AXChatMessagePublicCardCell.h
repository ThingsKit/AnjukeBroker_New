//
//  AJKChatMessagePublicCardCell.h
//  X
//
//  Created by 杨 志豪 on 2/13/14.
//  Copyright (c) 2014 williamYang. All rights reserved.
//

#import "AXChatMessageRootCell.h"

@protocol AXChatMessagePublicCardCellDelegate <NSObject>

@optional
- (void)didOpenPublicCard:(NSString *)url;

@end

@interface AXChatMessagePublicCardCell : AXChatMessageRootCell

@property (nonatomic, weak) id<AXChatMessagePublicCardCellDelegate> pcDelegate;
@property (nonatomic, strong) UIView *cardBgView;

@end
