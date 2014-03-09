//
//  AJKChatMessageBaseCell.h
//  X
//
//  Created by 杨 志豪 on 2/13/14.
//  Copyright (c) 2014 williamYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AXChatBaseCell.h"
#import "AXChatDataCenter.h"
#import "UIView+AXChatMessage.h"
#import "UIColor+AXChatMessage.h"
#import "UIImage+AXChatMessage.h"
#import "UIFont+AXChatMessage.h"

extern NSInteger const kAttributedLabelTag;
extern NSInteger const kRetryTag;

extern NSString * const AXCellIdentifyTag;
extern CGFloat const axTagMarginTop;
extern CGFloat const kJSAvatarSize;
extern CGFloat const kAvatarMargin;

@interface AXChatMessageRootCell : AXChatBaseCell

@property (nonatomic, readonly) AXMessageType messageType;
@property (nonatomic, strong) NSString *identifyString;
@property (nonatomic, strong) UIImageView *userImage;
@property (strong, nonatomic) UIImageView *bubbleIMG;

// config的数据
@property (nonatomic, strong) NSDictionary *rowData;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UIButton *errorButton;
@property (nonatomic, strong) AXMappedPerson *person;
@property (nonatomic, strong) NSString *phoneNum;
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UIButton *avatarButton;

- (void)initUI;
- (void)configWithStatus;
- (void)cellHighlighted:(BOOL)highlighted;
- (void)axDelete:(id)sender;
- (void)axCopy:(id)sender;
- (void)showMenu;

@end
