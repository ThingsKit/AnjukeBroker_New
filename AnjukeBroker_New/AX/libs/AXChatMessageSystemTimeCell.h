//
//  AJKChatMessageTimeCell.h
//  X
//
//  Created by jianzhongliu on 2/19/14.
//  Copyright (c) 2014 williamYang. All rights reserved.
//

#import "AXChatMessageAvatarCell.h"
#import "UIColor+AXChatMessage.h"
#import "UIFont+AXChatMessage.h"
#import "UIImage+AXChatMessage.h"

@protocol AXChatMessageSystemCellDelegate <NSObject>

- (void)didClickSystemButton:(AXMessageType)messageType;

@end

@interface AXChatMessageSystemTimeCell : UITableViewCell
{

}

@property (nonatomic) BOOL isBroker;
@property (nonatomic, strong) UILabel *systemLab;
@property (nonatomic, strong) UIButton *systemBut;
@property (nonatomic, strong) UIView *systemBgView;
@property (nonatomic, strong) id<AXChatMessageSystemCellDelegate> systemCellDelegate;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

- (CGRect)sizeOfString:(NSString *)string maxWidth:(float)width withFontSize:(UIFont *)fontSize;
- (void)configWithData:(NSDictionary *)data;
- (void)configWithIndexPath:(NSIndexPath *)indexPath;
@end
