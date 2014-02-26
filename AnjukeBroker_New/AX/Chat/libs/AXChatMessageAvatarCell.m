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
}
- (void)configWithData:(NSDictionary *)data
{
    [super configWithData:data];
    if (self.messageSource == AXChatMessageSourceDestinationIncoming) {
        self.avatar.frame = CGRectMake(kAvatarMargin, 20,kJSAvatarSize , kJSAvatarSize);
    } else {
        self.avatar.frame = CGRectMake(320 - kJSAvatarSize - kAvatarMargin, 20 ,kJSAvatarSize , kJSAvatarSize);
    }
    self.avatar.image = [UIImage axChatDefaultAvatar:self.isBroker];
    [self.contentView addSubview:self.avatar];
}

@end
