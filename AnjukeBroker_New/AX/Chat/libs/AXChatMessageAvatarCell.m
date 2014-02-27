//
//  AJKChatMessageAvatarCell.m
//  X
//
//  Created by 杨 志豪 on 14-2-14.
//  Copyright (c) 2014年 williamYang. All rights reserved.
//

CGFloat const kJSAvatarSize = 40.0f;
CGFloat const kAvatarMargin = 12.0f;

#import "AXChatMessageAvatarCell.h"
#import "UIImage+AXChatMessage.h"

@interface AXChatMessageAvatarCell ()

@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UIButton *avatarButton;

@end

@implementation AXChatMessageAvatarCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}
- (void)initUI {
    [super initUI];
    
    _avatar = [[UIImageView alloc] init];
    _avatar.contentMode = UIViewContentModeScaleToFill;
    
    _avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _avatarButton.backgroundColor = [UIColor clearColor];
    [_avatarButton addTarget:self action:@selector(clickAvatar:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_avatar];
    [self.contentView addSubview:_avatarButton];
}

- (void)configWithData:(NSDictionary *)data
{
    [super configWithData:data];
    
    if (self.messageSource == AXChatMessageSourceDestinationIncoming) {
        self.avatar.frame = CGRectMake(kAvatarMargin, 20,kJSAvatarSize , kJSAvatarSize);
    } else {
        self.avatar.frame = CGRectMake(320 - kJSAvatarSize - kAvatarMargin, 20 ,kJSAvatarSize , kJSAvatarSize);
    }
    self.avatarButton.frame = self.avatar.frame;
    self.avatar.image = [UIImage axChatDefaultAvatar:self.isBroker];
    
}

- (void)clickAvatar:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickAvatar:)]) {
        BOOL flag = (self.messageSource == AXChatMessageSourceDestinationIncoming)? NO:YES;
        [self.delegate didClickAvatar:flag];
    }
}

@end
