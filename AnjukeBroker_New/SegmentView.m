//
//  SegmentView.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 5/20/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import "SegmentView.h"
@class SegmentView;
@interface SegmentView ()

@property (nonatomic, strong)UIButton *leftBut;
@property (nonatomic, strong)UIButton *rightBut;

@end

@implementation SegmentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectedSegmentIndex = 0;
        self.selectedBackGroundColor = [UIColor clearColor];
        self.selectedButTitleColor = [UIColor redColor];
        self.disSelectedButTitleColor = [UIColor redColor];
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.leftBut = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBut.frame = CGRectMake(1.0f, 1.0f, self.frame.size.width / 2.0f - 1.0f, self.frame.size.height - 2.0f);
//    [self.leftBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.leftBut.tag = 0;
    [self.leftBut setBackgroundColor:[UIColor clearColor]];
    [self.leftBut addTarget:self action:@selector(didSelectedIndex:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.leftBut];
    
    self.rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBut.frame = CGRectMake(self.frame.size.width / 2.0f, 1.0f, self.frame.size.width / 2.0f - 1.0f, self.frame.size.height - 2.0f);
//    [self.rightBut setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    self.rightBut.tag = 1;
    [self.rightBut addTarget:self action:@selector(didSelectedIndex:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.rightBut];
    
    UIBezierPath * maskPathr = [UIBezierPath bezierPathWithRoundedRect:self.rightBut.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(2, 2)];
    CAShapeLayer * maskLayerr = [[CAShapeLayer alloc] init];
    maskLayerr.frame = self.rightBut.bounds;
    maskLayerr.path = maskPathr.CGPath;
    self.rightBut.layer.mask = maskLayerr;
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.leftBut.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(2, 2)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.leftBut.bounds;
    maskLayer.path = maskPath.CGPath;
    self.leftBut.layer.mask = maskLayer;

}

- (void)didSelectedIndex:(id)sender {
    UIButton *but = (UIButton *)sender;
    if (but.tag == 0) {
        if (_delegate && [_delegate respondsToSelector:@selector(didSelectedIndex:)]) {
            self.selectedSegmentIndex = 0;
            [_delegate didSelectedIndex:0];
            [self setSelectedBGColor:nil];
        }
    }else {
        if (_delegate && [_delegate respondsToSelector:@selector(didSelectedIndex:)]) {
            self.selectedSegmentIndex = 1;
            [_delegate didSelectedIndex:1];
            [self setSelectedBGColor:nil];
        }
    }
}

- (void)setLeftButTitle:(NSString *)title withColor:(UIColor *)color{
    [self.leftBut setTitle:title forState:UIControlStateNormal];
    [self.leftBut setTitleColor:color forState:UIControlStateNormal];
}

- (void)setRightButTitle:(NSString *)title withColor:(UIColor *)color{
    [self.rightBut setTitle:title forState:UIControlStateNormal];
    [self.rightBut setTitleColor:color forState:UIControlStateNormal];
}

- (void)setLeftButBackColor:(UIColor *)color {
    [self.leftBut setBackgroundColor:color];
}

- (void)setRightButBackColor:(UIColor *)color {
    [self.rightBut setBackgroundColor:color];
}

- (void)setSelectedBGColor:(UIColor *)color {
    if (color) {
        self.selectedBackGroundColor = color;
    }
    switch (self.selectedSegmentIndex) {
        case 0:
        {
            [self.leftBut setBackgroundColor:[UIColor clearColor]];
            [self.leftBut setTitleColor:self.selectedButTitleColor forState:UIControlStateNormal];
            [self.rightBut setTitleColor:self.disSelectedButTitleColor forState:UIControlStateNormal];
            [self.rightBut setBackgroundColor:self.selectedBackGroundColor];
        }
            break;
        case 1:
        {
            [self.rightBut setBackgroundColor:[UIColor clearColor]];
            
            [self.leftBut setTitleColor:self.disSelectedButTitleColor forState:UIControlStateNormal];
            [self.rightBut setTitleColor:self.selectedButTitleColor forState:UIControlStateNormal];
            [self.leftBut setBackgroundColor:self.selectedBackGroundColor];
        }
            break;
        default:
            break;
    }
}

- (void)setDisSelectTitleColor:(UIColor *)disColor selectedTitleColor:(UIColor *)selectedColor {
    self.selectedButTitleColor = selectedColor;
    self.disSelectedButTitleColor = disColor;
}
@end
