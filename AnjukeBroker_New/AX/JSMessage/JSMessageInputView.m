//
//  Created by Jesse Squires
//  http://www.hexedbits.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSMessagesViewController
//
//
//  The MIT License
//  Copyright (c) 2013 Jesse Squires
//  http://opensource.org/licenses/MIT
//

#import "JSMessageInputView.h"

#import <QuartzCore/QuartzCore.h>
#import "NSString+JSMessagesView.h"
#import "UIColor+JSMessagesView.h"
#import "UIColor+AXChatMessage.h"

@interface JSMessageInputView ()

@property (nonatomic, strong) UIView *lineView;

- (void)setup;
- (void)configureInputBarWithStyle:(JSMessageInputViewStyle)style;
- (void)configureSendButtonWithStyle:(JSMessageInputViewStyle)style;

@end



@implementation JSMessageInputView

#pragma mark - Initialization

- (void)setup
{
    self.backgroundColor = [UIColor whiteColor];
    self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
    self.opaque = YES;
    self.userInteractionEnabled = YES;
}

- (void)configureInputBarWithStyle:(JSMessageInputViewStyle)style
{
    CGFloat width = 260;
    CGFloat height = 30;
    if (self.isBroker) {
    
    } else {
        width = 219;
        height = [JSMessageInputView textViewLineHeight];
    }
    JSMessageTextView *textView = [[JSMessageTextView  alloc] initWithFrame:CGRectZero];
    [self addSubview:textView];
	_textView = textView;
    
    _textView.frame = CGRectMake(12.0f, 10.0f, width, height);
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.layer.borderColor = [UIColor axChatInputBorderColor:self.isBroker].CGColor;
    _textView.layer.borderWidth = 0.65f;
    _textView.layer.cornerRadius = 6.0f;
    _textView.returnKeyType = UIReturnKeySend;
    _textView.contentInset = UIEdgeInsetsMake(-3.0f, 0.0f, -1.0f, 0.0f);
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    self.lineView.backgroundColor = [UIColor axChatInputBorderColor:self.isBroker];
    [self addSubview:self.lineView];
    
    self.backgroundColor = [UIColor axChatInputBGColor:self.isBroker];
}

- (void)configureSendButtonWithStyle:(JSMessageInputViewStyle)style
{
    UIButton *sendButton;
    
    sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake(self.textView.frame.origin.x + self.textView.frame.size.width + 19, 10, 52, 30);
    sendButton.backgroundColor = [UIColor clearColor];
    sendButton.layer.borderColor = [UIColor axChatInputBorderColor:self.isBroker].CGColor;
    sendButton.layer.borderWidth = 0.65f;
    sendButton.layer.cornerRadius = 6.0f;
    
    [sendButton setTitleColor:[UIColor axChatSendButtonNColor:self.isBroker] forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor axChatSendButtonHColor:self.isBroker] forState:UIControlStateHighlighted];
    [sendButton setTitleColor:[UIColor axChatSendButtonDColor:self.isBroker] forState:UIControlStateDisabled];
        
    sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    
    NSString *title = @"发送";
    [sendButton setTitle:title forState:UIControlStateNormal];
    [sendButton setTitle:title forState:UIControlStateHighlighted];
    [sendButton setTitle:title forState:UIControlStateDisabled];
    
    [self setSendButton:sendButton];
}

- (instancetype)initWithFrame:(CGRect)frame
                        style:(JSMessageInputViewStyle)style
                     delegate:(id<UITextViewDelegate, JSDismissiveTextViewDelegate>)delegate
         panGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer isBroker:(BOOL)isBroker
{
    self = [super initWithFrame:frame];
    if (self) {
        _isBroker = isBroker;
        _style = style;
        [self setup];
        [self configureInputBarWithStyle:style];
        [self configureSendButtonWithStyle:style];
        
        _textView.delegate = delegate;
        _textView.keyboardDelegate = delegate;
        _textView.dismissivePanGestureRecognizer = panGestureRecognizer;
    }
    return self;
}

- (void)dealloc
{
    _textView = nil;
    _sendButton = nil;
}

#pragma mark - UIView

- (BOOL)resignFirstResponder
{
    [self.textView resignFirstResponder];
    return [super resignFirstResponder];
}

#pragma mark - Setters

- (void)setSendButton:(UIButton *)btn
{
    if (_sendButton) {
        [_sendButton removeFromSuperview];
    }
    [self addSubview:btn];
    _sendButton = btn;
    if (self.isBroker) {
        btn.hidden = YES;
    } else {
        btn.hidden = NO;
    }
}

#pragma mark - Message input view

- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight
{
    CGRect prevFrame = self.textView.frame;
    
    NSUInteger numLines = MAX([self.textView numberOfLinesOfText],
                              [self.textView.text js_numberOfLines]);
    
    //  below iOS 7, if you set the text view frame programmatically, the KVO will continue notifying
    //  to avoid that, we are removing the observer before setting the frame and add the observer after setting frame here.
    [self.textView removeObserver:_textView.keyboardDelegate
                       forKeyPath:@"contentSize"];
    
    self.textView.frame = CGRectMake(prevFrame.origin.x,
                                     prevFrame.origin.y,
                                     prevFrame.size.width,
                                     prevFrame.size.height + changeInHeight);
    
    [self.textView addObserver:_textView.keyboardDelegate
                    forKeyPath:@"contentSize"
                       options:NSKeyValueObservingOptionNew
                       context:nil];

    self.textView.contentInset = UIEdgeInsetsMake((numLines >= 5 ? 4.0f : -3.0f),
                                                  0.0f,
                                                  (numLines >= 5 ? 4.0f : -1.0f),
                                                  0.0f);
    
    // from iOS 7, the content size will be accurate only if the scrolling is enabled.
    self.textView.scrollEnabled = YES;
    
    if (numLines >= 5) {
        CGPoint bottomOffset = CGPointMake(0.0f, self.textView.contentSize.height - self.textView.bounds.size.height);
        [self.textView setContentOffset:bottomOffset animated:YES];
        [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length - 2, 1)];
    }
}

+ (CGFloat)textViewLineHeight
{
    return 30.0f; // for fontSize 16.0f
}

+ (CGFloat)maxLines
{
    return 5.0f;
}

+ (CGFloat)maxHeight
{
    return 110.0f;
}

@end
