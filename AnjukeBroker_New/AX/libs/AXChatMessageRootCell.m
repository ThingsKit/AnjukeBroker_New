//
//  AJKChatMessageBaseCell.m
//  X
//
//  Created by 杨 志豪 on 2/13/14.
//  Copyright (c) 2014 williamYang. All rights reserved.
//

#import "AXChatMessageRootCell.h"
#import "UIImage+AXChatMessage.h"

NSString *const AXCellIdentifyTag = @"identifier";

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
    self.errorButton.frame = CGRectMake(0, 0, 25, 25);
    self.errorButton.titleLabel.text = @"abcde";
    self.errorButton.imageView.image = [UIImage imageNamed:@"anjuke_icon_attention.png"];
    [self.errorButton addTarget:self action:@selector(didRetry) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *errorImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"anjuke_icon_attention.png"]];
    errorImg.frame = CGRectMake(0, 0, 25, 25);
    [self.errorButton addSubview:errorImg];
    self.errorButton.hidden = YES;
    [self.contentView addSubview:self.errorButton];
}

#pragma mark -

- (void)setBubbleIMGOutcomeIncome {
    if (self.messageSource == AXChatMessageSourceDestinationIncoming) {
        self.bubbleIMG.image = [[UIImage axInChatBubbleBg:self.isBroker highlighted:NO] stretchableImageWithLeftCapWidth:40/2 topCapHeight:30/2];
    }else{
        self.bubbleIMG.image = [[UIImage axOutChatBubbleBg:self.isBroker highlighted:NO] stretchableImageWithLeftCapWidth:40/2 topCapHeight:30.0f / 2.0f];
    }
}

- (void)configWithData:(NSDictionary *)data
{
    [self setBubbleIMGOutcomeIncome];
    self.identifyString = data[AXCellIdentifyTag];
    self.rowData = data;
}

- (void)configWithIndexPath:(NSIndexPath *)indexPath {
    self.currentIndexPath = indexPath;
}

- (void)configWithStatus
{
    if (self.rowData[@"status"]) {
        if ([self.rowData[@"status"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageCenterSendMessageStatusSending]]) {
            self.activityIndicatorView.hidden = NO;
            self.activityIndicatorView.frame = [self statusIconRect];
            [self.activityIndicatorView startAnimating];
            self.errorButton.hidden = YES;
        } else if ([self.rowData[@"status"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageCenterSendMessageStatusFailed]]) {
            self.errorButton.frame = [self statusIconRect];
            self.errorButton.hidden = NO;
            self.activityIndicatorView.hidden = YES;
            [self.activityIndicatorView stopAnimating];
        } if ([self.rowData[@"status"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageCenterSendMessageStatusSuccessful]]) {
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
        return CGRectMake(self.bubbleIMG.frame.origin.x + self.bubbleIMG.frame.size.width + 25, self.bubbleIMG.frame.size.height - 17, 25, 25);
    } else {
        return CGRectMake(self.bubbleIMG.frame.origin.x - 28, self.bubbleIMG.frame.size.height - 5, 25, 25);
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
    [menu setTargetRect:self.bubbleIMG.frame inView:self.bubbleIMG.superview];
    UIMenuItem *delete = [[UIMenuItem alloc] initWithTitle:@"删除"action:@selector(axDelete:)];
    UIMenuItem *copy = [[UIMenuItem alloc] initWithTitle:@"复制"action:@selector(axCopy:)];
    [menu setMenuItems:@[copy, delete]];

    self.bubbleIMG.highlighted = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillShowNotification:)
                                                 name:UIMenuControllerWillShowMenuNotification
                                               object:nil];
    [menu setMenuVisible:YES animated:YES];
}

#pragma mark - Notifications

- (void)handleMenuWillHideNotification:(NSNotification *)notification
{
    self.bubbleIMG.highlighted = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillHideMenuNotification
                                                  object:nil];
}

- (void)handleMenuWillShowNotification:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillHideNotification:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
    if (self.messageSource == AXChatMessageSourceDestinationIncoming) {
        self.bubbleIMG.image = [[UIImage axInChatBubbleBg:self.isBroker highlighted:highlighted] stretchableImageWithLeftCapWidth:40/2 topCapHeight:30.0f / 2.0f];
    } else {
        self.bubbleIMG.image = [[UIImage axOutChatBubbleBg:self.isBroker highlighted:highlighted] stretchableImageWithLeftCapWidth:40/2 topCapHeight:30.0f / 2.0f];
    }
    [super setHighlighted:highlighted animated:animated];
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return (action == @selector(axDelete:));
}
#pragma mark - Action
- (void)didRetry
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didMessageRetry:)]) {
        [self.delegate didMessageRetry:self];
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

@end
