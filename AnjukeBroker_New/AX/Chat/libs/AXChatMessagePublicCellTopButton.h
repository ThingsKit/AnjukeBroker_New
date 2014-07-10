//
//  AXChatMessagePublicCellTopButton.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-17.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AXChatMessagePublicCellTopButton : UIButton
@property(nonatomic, strong) NSDictionary *data;

- (instancetype)initWithData:(NSDictionary *)dic;


@end
