//
//  AJKChatMessageBaseCell.m
//  X
//
//  Created by 杨 志豪 on 2/13/14.
//  Copyright (c) 2014 williamYang. All rights reserved.
//

#import "AXChatMessageRootCell.h"
#import "UIImage+AXChatMessage.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

NSString *const AXCellIdentifyTag = @"identifier";
CGFloat const axTagMarginTop = 10.0f;
CGFloat const kJSAvatarSize = 40.0f;
CGFloat const kAvatarMargin = 12.0f;

NSInteger const kAttributedLabelTag = 100;
NSInteger const kRetryTag = 101;

@interface AXChatMessageRootCell () <UIAlertViewDelegate>

@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UIButton *avatarButton;

@end

@implementation AXChatMessageRootCell
@synthesize bubbleIMG;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.isBroker = NO;
        // Initialization code
        [self initUI];
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                 action:@selector(handleLongPressGesture:)];
        [recognizer setMinimumPressDuration:0.4f];
        [self addGestureRecognizer:recognizer];
    }
    return self;
}

- (void)configAvatar:(AXMappedPerson *)person;
{
    self.person = person;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initUI {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.bubbleIMG = [[UIImageView alloc] init];
    self.bubbleIMG.frame = CGRectZero;
    [self.contentView addSubview:self.bubbleIMG];
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicatorView.hidden = YES;
    self.activityIndicatorView.frame = CGRectMake(0, 0, 25, 25);
//    [self.activityIndicatorView startAnimating];
    [self.contentView addSubview:self.activityIndicatorView];
    
    self.errorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.errorButton.imageView.image = [UIImage imageNamed:@"anjuke_icon_attention.png"];
    [self.errorButton addTarget:self action:@selector(didRetry) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *errorImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"anjuke_icon_attention.png"]];
    [self.errorButton addSubview:errorImg];
    self.errorButton.hidden = YES;
    [self.contentView addSubview:self.errorButton];
    
    _avatar = [[UIImageView alloc] init];
    _avatar.layer.masksToBounds = YES;
    _avatar.layer.cornerRadius = 4;
    _avatar.contentMode = UIViewContentModeScaleToFill;
    
    _avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _avatarButton.backgroundColor = [UIColor clearColor];
    [_avatarButton addTarget:self action:@selector(clickAvatar:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_avatar];
    [self.contentView addSubview:_avatarButton];
    [self.contentView sendSubviewToBack:self.bubbleIMG];

}

#pragma mark -

- (void)setBubbleIMGOutcomeIncome {
    if (self.messageSource == AXChatMessageSourceDestinationIncoming) {
        self.bubbleIMG.image = [[UIImage axInChatBubbleBg:self.isBroker highlighted:NO] stretchableImageWithLeftCapWidth:40/2 topCapHeight:30/2];
    } else {
        self.bubbleIMG.image = [[UIImage axOutChatBubbleBg:self.isBroker highlighted:NO] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
    }
}

- (void)configWithData:(NSDictionary *)data
{
    [self setBubbleIMGOutcomeIncome];
    self.identifyString = data[AXCellIdentifyTag];
    self.rowData = data;
    
    if (self.messageSource == AXChatMessageSourceDestinationIncoming) {
        self.avatar.frame = CGRectMake(kAvatarMargin, axTagMarginTop, kJSAvatarSize , kJSAvatarSize);
    } else {
        self.avatar.frame = CGRectMake(320 - kJSAvatarSize - kAvatarMargin, axTagMarginTop, kJSAvatarSize , kJSAvatarSize);
    }
    self.avatarButton.frame = self.avatar.frame;
#warning 竟然isIconDownloaded是YES 0.0
    if (self.person.isIconDownloaded == NO || YES) {
        [self.avatar setImageWithURL:[NSURL URLWithString:self.person.iconUrl] placeholderImage:[UIImage axChatDefaultAvatar:NO]];
    } else {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
        self.avatar.image = [[UIImage alloc] initWithContentsOfFile:[libraryPath stringByAppendingPathComponent:self.person.iconPath]];
    }
}

- (void)configWithIndexPath:(NSIndexPath *)indexPath {
    self.currentIndexPath = indexPath;
}

- (void)configWithStatus
{
    if (self.rowData[@"status"]) {
        if ([self.rowData[@"status"] isEqualToNumber:@(AXMessageCenterSendMessageStatusSending)]) {
            self.activityIndicatorView.hidden = NO;
            self.activityIndicatorView.frame = [self statusIconRect];
            [self.activityIndicatorView startAnimating];
            self.errorButton.hidden = YES;
        } else if ([self.rowData[@"status"] isEqualToNumber:@(AXMessageCenterSendMessageStatusFailed)]) {
            self.errorButton.frame = [self statusIconRect];
            self.errorButton.hidden = NO;
            self.activityIndicatorView.hidden = YES;
            [self.activityIndicatorView stopAnimating];
        } if ([self.rowData[@"status"] isEqualToNumber:@(AXMessageCenterSendMessageStatusSuccessful)]) {
            self.errorButton.hidden = YES;
            self.activityIndicatorView.hidden = YES;
            [self.activityIndicatorView stopAnimating];
        }
    }
    [self setNeedsDisplay];
}

- (CGRect)statusIconRect
{
    if (self.messageSource == AXChatMessageSourceDestinationIncoming) {
        return CGRectMake(self.bubbleIMG.frame.origin.x + self.bubbleIMG.frame.size.width + 25, self.bubbleIMG.frame.size.height - 17 - 14, 25, 25);
    } else {
        return CGRectMake(self.bubbleIMG.frame.origin.x - 26, self.bubbleIMG.frame.size.height - 5 - 13, 25, 25);
    }
}

- (void)cellHighlighted:(BOOL)highlighted
{
    if (self.messageSource == AXChatMessageSourceDestinationIncoming) {
        self.bubbleIMG.image = [[UIImage axInChatBubbleBg:self.isBroker highlighted:highlighted] stretchableImageWithLeftCapWidth:40/2 topCapHeight:30.0f / 2.0f];
    } else {
        self.bubbleIMG.image = [[UIImage axOutChatBubbleBg:self.isBroker highlighted:highlighted] stretchableImageWithLeftCapWidth:40/2 topCapHeight:30.0f / 2.0f];
    }
}

#pragma mark - 重载canBecomeFirstResponder
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    return [super becomeFirstResponder];
}

#pragma mark - Gestures
- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state != UIGestureRecognizerStateBegan || ![self becomeFirstResponder]) {
        return;
    }
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setTargetRect:self.bubbleIMG.frame inView:self];
    UIMenuItem *delete = [[UIMenuItem alloc] initWithTitle:@"删除"action:@selector(axDelete:)];
    UIMenuItem *copy = [[UIMenuItem alloc] initWithTitle:@"复制"action:@selector(axCopy:)];
    [menu setMenuItems:@[copy, delete]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillShowNotification:)
                                                 name:UIMenuControllerWillShowMenuNotification
                                               object:nil];
    [menu setMenuVisible:YES animated:YES];
}

#pragma mark - Notifications

- (void)handleMenuWillHideNotification:(NSNotification *)notification
{
    DLog(@"handleMenuWillHideNotification");
    [self cellHighlighted:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillHideMenuNotification
                                                  object:nil];
}

- (void)handleMenuWillShowNotification:(NSNotification *)notification
{
    DLog(@"handleMenuWillShowNotification");
    [self cellHighlighted:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillHideNotification:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return (action == @selector(axDelete:));
}
#pragma mark - Action
- (void)didRetry
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didMessageRetry:)]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否重发该消息？" message:nil delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        alertView.tag = AXChatCellViewTypeRetry;
        [alertView show];
    }
}

- (void)axDelete:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteAXCell:)]) {
        [self.delegate deleteAXCell:self];
    }
}

- (void)axCopy:(id)sender
{
    
}

- (void)clickAvatar:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickAvatar:)]) {
        BOOL flag = (self.messageSource == AXChatMessageSourceDestinationIncoming)? NO:YES;
        [self.delegate didClickAvatar:flag];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == AXChatCellViewTypePhoneAlert) {
        if (buttonIndex == 1) {
            // 打电话
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.phoneNum]];
        }
    } else if (alertView.tag == AXChatCellViewTypeRetry) {
        if (buttonIndex == 1) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didMessageRetry:)]) {
                [self.delegate didMessageRetry:self];
            }
        }
    }
}

@end
