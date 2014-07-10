//
//  Broker_InputEditView.m
//  AnjukeBroker_New
//
//  Created by paper on 14-2-21.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "Broker_InputEditView.h"
#import "Util_UI.h"
#import "BrokerLineView.h"

#define lbH 20

@implementation Broker_InputEditView
@synthesize titleLb, textFidle_Input, textView_Input;
@synthesize displayStyle;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initUIWithFrame:frame];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)initUIWithFrame:(CGRect)frame{
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(17, (self.frame.size.height - lbH)/2, 70, lbH)];
    title.backgroundColor = [UIColor clearColor];
    self.titleLb = title;
    title.textColor = SYSTEM_DARK_GRAY;
    title.font = [UIFont systemFontOfSize:15];
    [self addSubview:title];
    
    [self addLineViewWithOriginY:-0.5];
    [self addLineViewWithOriginY:self.frame.size.height-0.5];
}

- (void)drawInputWithStyle:(DisplayStyle)style {
    self.displayStyle = style;
    
    if (self.displayStyle == DisplayStyle_ForTextField) {
        self.textFidle_Input = [[UITextField alloc] initWithFrame:CGRectMake(self.titleLb.frame.origin.x + self.titleLb.frame.size.width + 15, self.titleLb.frame.origin.y, 180, lbH)];
        self.textFidle_Input.backgroundColor = [UIColor clearColor];
        self.textFidle_Input.font = self.titleLb.font;
        self.textFidle_Input.textColor = SYSTEM_BLACK;
        self.textFidle_Input.keyboardType = UIKeyboardTypeDefault;
        [self addSubview:textFidle_Input];
    }
    else if (self.displayStyle == DisplayStyle_ForTextView) {
        self.textView_Input = [[UITextView alloc] initWithFrame:CGRectMake(self.titleLb.frame.origin.x + self.titleLb.frame.size.width + 15, 5, 180, INPUT_EDIT_TEXTVIEW_H - 10)];
        self.textView_Input.backgroundColor = [UIColor clearColor];
        self.textView_Input.font = self.titleLb.font;
        self.textView_Input.textColor = SYSTEM_BLACK;
        self.textView_Input.delegate = self;
        self.textView_Input.keyboardType = UIKeyboardTypeDefault;
        [self addSubview:textView_Input];
    }
    
}

- (void)addLineViewWithOriginY:(CGFloat)originY {
    BrokerLineView *bl = [[BrokerLineView alloc] initWithFrame:CGRectMake(0, originY, 320, 0.5)];
    [self addSubview:bl];
}

@end
