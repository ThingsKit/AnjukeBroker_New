//
//  PhotoShowView.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-7.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "PhotoShowView.h"
#import "Util_UI.h"

@implementation PhotoShowView
@synthesize clickDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = SYSTEM_BLACK;//[UIColor whiteColor];
        self.alpha = 0.8;
        
        [self initModel];
        [self initDisplayWithFrame:frame];
        
     }
    return self;
}

- (void)initModel {
    self.imgArray = [NSMutableArray array];
}

- (void)initDisplayWithFrame:(CGRect)frame {
    CGFloat Whole_H = frame.size.height; //self总高
    CGFloat BtnH = 50;
    CGFloat BtnW = 100;
    
    UIButton *takeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    takeBtn.frame = CGRectMake(10+100, Whole_H - BtnH-5, BtnW, BtnH);
    takeBtn.backgroundColor = [UIColor whiteColor];
    takeBtn.layer.borderColor = SYSTEM_BLACK.CGColor;
    takeBtn.layer.borderWidth = 1;
    [takeBtn setTitle:@"拍照" forState:UIControlStateNormal];
    [takeBtn setTitleColor:SYSTEM_BLACK forState:UIControlStateNormal];
    [takeBtn addTarget:self action:@selector(take_Picture:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:takeBtn];
    
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    exitBtn.frame = CGRectMake(takeBtn.frame.origin.x + BtnW, takeBtn.frame.origin.y, BtnW, BtnH);
    exitBtn.backgroundColor = [UIColor whiteColor];
    exitBtn.layer.borderColor = SYSTEM_BLACK.CGColor;
    exitBtn.layer.borderWidth = 1;
    [exitBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [exitBtn setTitleColor:SYSTEM_BLACK forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(closePicker:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:exitBtn];
    
    //Image Scroll View
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)take_Picture:(id)sender {
    if ([self.clickDelegate respondsToSelector:@selector(takePhoto_Click)]) {
        [self.clickDelegate takePhoto_Click];
    }
}

- (void)closePicker:(id)sender {
    if ([self.clickDelegate respondsToSelector:@selector(closePicker_Click_WithImgArr:)]) {
        [self.clickDelegate closePicker_Click_WithImgArr:self.imgArray];
    }

}

@end
