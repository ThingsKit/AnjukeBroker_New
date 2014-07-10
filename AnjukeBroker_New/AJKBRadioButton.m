//
//  AJKBRadioButton.m
//  AnjukeBroker_New
//
//  Created by anjuke on 14-5-19.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "AJKBRadioButton.h"

@implementation AJKBRadioButton
@synthesize isChoose = _isChoose;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)clickAction
{
    self.isChoose = !_isChoose;

    if (_delegate && [_delegate respondsToSelector:@selector(clickAction:)])
    {
        [_delegate clickAction:self];
    }
}

- (void)setIsChoose:(BOOL)isChoose
{
    _isChoose = isChoose;
    if (!isChoose)
    {
        [self clickOff];
    }else
    {
        [self clickOn];
    }
}

- (void)clickOn
{
    [self setImage:[UIImage imageNamed:@"anjuke_icon_choosed"] forState:UIControlStateNormal];
}

- (void)clickOff
{
    [self setImage:[UIImage imageNamed:@"anjuke_icon_not_choose"] forState:UIControlStateNormal];
}


@end
