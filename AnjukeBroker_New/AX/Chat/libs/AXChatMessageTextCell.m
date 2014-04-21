//
//  AJKChatMessageTextCell.m
//  X
//
//  Created by 杨 志豪 on 2/13/14.
//  Copyright (c) 2014 williamYang. All rights reserved.
//


#import "AXChatMessageTextCell.h"

@interface AXChatMessageTextCell () <AXTTTAttributedLabelDelegate>

@property (nonatomic, strong) AXTTTAttributedLabel *attrLabel;
@property (nonatomic) CGFloat textWidth;
@property (nonatomic) CGFloat textHeight;
@end

@implementation AXChatMessageTextCell

+ (AXTTTAttributedLabel *)createAXAttributedLabel
{
    AXTTTAttributedLabel *attrLabel = [[AXTTTAttributedLabel alloc] init];
    attrLabel.numberOfLines = 0;
    attrLabel.userInteractionEnabled = YES;
    attrLabel.font = [UIFont systemFontOfSize:16.0];
    attrLabel.textColor = [UIColor blackColor];
    attrLabel.lineBreakMode = UILineBreakModeWordWrap;
    attrLabel.verticalAlignment = AXTTTAttributedLabelVerticalAlignmentTop;
    attrLabel.backgroundColor = [UIColor clearColor];
    NSMutableDictionary *mutableActiveLinkAttributes = [NSMutableDictionary dictionary];
    [mutableActiveLinkAttributes setValue:@NO forKey:(NSString *)kCTUnderlineStyleAttributeName];
    [mutableActiveLinkAttributes setValue:(__bridge id)[[UIColor blueColor] CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
    [mutableActiveLinkAttributes setValue:(__bridge id)[[UIColor colorWithHex:0xc1c1c1 alpha:1] CGColor] forKey:(NSString *)kAXTTTBackgroundFillColorAttributeName];
    [mutableActiveLinkAttributes setValue:(__bridge id)[[UIColor colorWithHex:0xc1c1c1 alpha:1] CGColor] forKey:(NSString *)kAXTTTBackgroundStrokeColorAttributeName];
    [mutableActiveLinkAttributes setValue:[NSNumber numberWithFloat:1.0f] forKey:(NSString *)kAXTTTBackgroundLineWidthAttributeName];
    [mutableActiveLinkAttributes setValue:[NSNumber numberWithFloat:2.0f] forKey:(NSString *)kAXTTTBackgroundCornerRadiusAttributeName];
    
    attrLabel.activeLinkAttributes = mutableActiveLinkAttributes;
    
    NSMutableDictionary *mutableLinkAttributes = [NSMutableDictionary dictionary];
    [mutableLinkAttributes setValue:@NO forKey:(NSString *)kCTUnderlineStyleAttributeName];
    [mutableLinkAttributes setValue:(__bridge id)[[UIColor blueColor] CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
    attrLabel.linkAttributes = mutableLinkAttributes;
    return attrLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                 action:@selector(handleLongPressGesture:)];
        [recognizer setMinimumPressDuration:0.4f];
        [self addGestureRecognizer:recognizer];
    }
    return self;
}

- (void)initUI {
    [super initUI];
}

#pragma mark - setters and getters
- (AXTTTAttributedLabel *)attrLabel
{
    if (!_attrLabel) {
        _attrLabel = [AXChatMessageTextCell createAXAttributedLabel];
        _attrLabel.delegate = self;
        [self.contentView addSubview:_attrLabel];
    }
    return _attrLabel;
}

- (void)configWithData:(NSDictionary *)data
{
    [super configWithData:data];
    if (!self.content || ![self.content isEqualToString:data[@"content"]]) {
        NSString *text;
        if ([data[@"content"] length] > 0 && [data[@"content"] hasSuffix:@"]"]) {
            text = [NSString stringWithFormat:@"%@ ", data[@"content"]];
        } else {
            text = data[@"content"];
        }
        self.attrLabel.text = text;
        [self.attrLabel regularTextCheckingTypes];
        self.textWidth = [data[@"rowWidth"] floatValue];
        self.textHeight = [data[@"rowHeight"] floatValue];
        self.attrLabel.width = self.textWidth;
        self.attrLabel.height = self.textHeight;
        
        if (self.messageSource == AXChatMessageSourceDestinationIncoming) {
            self.attrLabel.frame = CGRectMake(kBubbleMargin + 18, 20, self.textWidth, self.textHeight);
        } else {
            self.attrLabel.frame = CGRectMake(320 - kJSAvatarSize - self.textWidth - kAvatarMargin - 24, 20, self.textWidth, self.textHeight);
        }
        self.content = data[@"content"];
        self.cellContentWidth = self.textWidth + 24;
        self.cellContentHeight = self.textHeight + 20;
        
        [self configBubbleView];
    }
    
    [self configWithStatus];
}


#pragma mark - 重载
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return (action == @selector(axDelete:)) || (action == @selector(axCopy:));
}

#pragma mark - Action
- (void)axCopy:(id)sender
{
    if (self.content) {
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        [pb setString:self.content];
    }
}

#pragma mark - Gestures
- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state != UIGestureRecognizerStateBegan || ![self becomeFirstResponder]) {
        return;
    }
    CGPoint point = [longPress locationInView:self];
    if (!CGRectContainsPoint(self.bubbleIMG.frame, point)) {
        return;
    }
    [self showMenu];
}

#pragma mark - AXTTTAttributedLabelDelegate
- (void)attributedLabel:(AXTTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didOpenAXWebView:)]) {
        [self.delegate didOpenAXWebView:[url absoluteString]];
    }
}

- (void)attributedLabel:(AXTTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber
{
    self.phoneNum = phoneNumber;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"这可能是一个电话号码。\n是否拨打该号码" message:nil delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alertView.tag = AXChatCellViewTypePhoneAlert;
    [alertView show];
    self.alertView = alertView;
}
@end
