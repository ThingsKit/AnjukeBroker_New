//
//  SimpleKeyboardToolBar.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-24.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "SimpleKeyboardToolBar.h"

@implementation SimpleKeyboardToolBar
@synthesize clickDelagate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        CGFloat finishBtn_W = 56;
        CGFloat finishBtn_H = 30;
        UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        finishBtn.frame = CGRectMake(frame.size.width- finishBtn_W*1.2, (frame.size.height-finishBtn_H)/2, finishBtn_W, finishBtn_H);
        finishBtn.backgroundColor = [UIColor clearColor];
        [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [finishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [finishBtn addTarget:self action:@selector(doDone) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:finishBtn];
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

- (void)doDone {
    if ([self.clickDelagate respondsToSelector:@selector(SK_finishBtnClicked)]) {
        [self.clickDelagate SK_finishBtnClicked];
    }
}

@end
