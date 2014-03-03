//
//  AJKChatMessageTextCell.m
//  X
//
//  Created by 杨 志豪 on 2/13/14.
//  Copyright (c) 2014 williamYang. All rights reserved.
//


#import "AXChatMessageTextCell.h"
#import <OHAttributedLabel/OHAttributedLabel.h>
#import <OHAttributedLabel/NSAttributedString+Attributes.h>
#import <OHAttributedLabel/OHASBasicMarkupParser.h>

@interface AXChatMessageTextCell () <OHAttributedLabelDelegate>

@property (nonatomic, strong) OHAttributedLabel *attrLabel;
@property (nonatomic) CGFloat textWidth;
@property (nonatomic) CGFloat textHeight;
@end

@implementation AXChatMessageTextCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [super initUI];
}

#pragma mark - setters and getters
- (void)setMessageStatus:(AXMessageCenterSendMessageStatus)messageStatus
{
    messageStatus = messageStatus;
    if (messageStatus == AXMessageCenterSendMessageStatusSending) {
    } else if (messageStatus == AXMessageCenterSendMessageStatusSuccessful) {
    } else if (messageStatus == AXMessageCenterSendMessageStatusFailed) {
    }
}

- (OHAttributedLabel *)attrLabel
{
    if (!_attrLabel) {
        _attrLabel = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 1000)];
        _attrLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _attrLabel.centerVertically = NO;
        _attrLabel.automaticallyAddLinksForType = NSTextCheckingAllTypes;
        _attrLabel.delegate = self;
        _attrLabel.backgroundColor = [UIColor clearColor];
        _attrLabel.linkUnderlineStyle = kCTUnderlinePatternSolid;
        [self.contentView addSubview:_attrLabel];
    }
    return _attrLabel;
}

- (void)configWithData:(NSDictionary *)data
{
    [super configWithData:data];
    if (self.attrLabel) {
        [self.attrLabel removeFromSuperview];
        self.attrLabel = nil;
    }
//    if (![data[@"status"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageCenterSendMessageStatusSending]]) {
//        [self configWithStatus];
//        return;
//    }
//    NSLog(@"s:%@,w:%@, h:%@", data[@"content"], data[@"rowWidth"], data[@"rowHeight"]);
    self.textWidth = [data[@"rowWidth"] floatValue];
    self.textHeight = [data[@"rowHeight"] floatValue];
    
    if (self.messageSource == AXChatMessageSourceDestinationIncoming) {
        self.attrLabel.frame = CGRectMake(kJSAvatarSize + 38, 21, self.textWidth, self.textHeight);
    } else {
        self.attrLabel.frame = CGRectMake(320 - kJSAvatarSize - self.textWidth - kAvatarMargin - 24, 21, self.textWidth, self.textHeight);
    }
    self.content = data[@"content"];
    self.attrLabel.attributedText = data[@"mas"];

    //气泡
    CGRect size = CGRectMake(0, 0, self.textWidth, self.textHeight);
    [self setBubbleImg:size.size];
    [self configWithStatus];
}

- (void)drawRect:(CGRect)rect
{
    
}

- (void)setBubbleImg:(CGSize )size {
    if (self.messageSource == AXChatMessageSourceDestinationIncoming) {
        self.bubbleIMG.frame = CGRectMake(self.attrLabel.frame.origin.x - 21 + 2, axTagMarginTop, size.width + 30.0f , size.height + 20.0f);
    } else {
        self.bubbleIMG.frame = CGRectMake(self.attrLabel.frame.origin.x - 13, axTagMarginTop, size.width + 30.0f , size.height + 20.0f);
    }
}

#pragma mark - OHAttributedLabel Delegate Method
- (BOOL)attributedLabel:(OHAttributedLabel *)attributedLabel shouldFollowLink:(NSTextCheckingResult *)linkInfo
{
    if ([[linkInfo.extendedURL absoluteString] rangeOfString:@"http://"].location != NSNotFound) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didOpenAXWebView:)]) {
            [self.delegate didOpenAXWebView:[linkInfo.extendedURL absoluteString]];
        }
    }  else if ([[linkInfo.extendedURL absoluteString] rangeOfString:@"tel:"].location != NSNotFound) {
        self.phoneNum = [linkInfo.extendedURL absoluteString];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"这可能是一个电话号码。\n是否拨打该号码" message:nil delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        alertView.tag = AXChatCellViewTypePhoneAlert;
        [alertView show];
    }
    return NO;
}

#pragma mark - 重载
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return (action == @selector(axDelete:)) || (action == @selector(axCopy:));
}

#pragma mark - Action
- (void)axCopy:(id)sender
{
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:self.content];
}


@end
