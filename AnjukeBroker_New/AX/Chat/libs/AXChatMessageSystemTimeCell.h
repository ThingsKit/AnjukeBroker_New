//
//  AJKChatMessageTimeCell.h
//  X
//
//  Created by jianzhongliu on 2/19/14.
//  Copyright (c) 2014 williamYang. All rights reserved.
//

#import "AXChatMessageRootCell.h"
#import "AXChatBaseCell.h"
#import "UIColor+AXChatMessage.h"
#import "UIFont+AXChatMessage.h"
#import "UIImage+AXChatMessage.h"

@protocol AXChatMessageSystemCellDelegate <NSObject>


@end

@interface AXChatMessageSystemTimeCell : AXChatBaseCell
{

}

@property (nonatomic, strong) UILabel *systemLab;
@property (nonatomic, strong) UIButton *systemBut;
@property (nonatomic, strong) UIView *systemBgView;

- (CGSize)sizeOfString:(NSString *)string maxWidth:(float)width withFontSize:(UIFont *)fontSize;

@end
