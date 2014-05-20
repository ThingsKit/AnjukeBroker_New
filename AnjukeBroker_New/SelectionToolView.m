//
//  SelectionToolView.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 5/13/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import "SelectionToolView.h"

@implementation SelectionToolView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 110, 100)];
        [img setImage:[UIImage imageNamed:@"bg_3.4_01.png"]];
        [self addSubview:img];
        
        UIImageView *ajkIcon = [[UIImageView alloc] initWithFrame:CGRectMake(12, 24, 20, 20)];
        [ajkIcon setImage:[UIImage imageNamed:@"icon_3.4_01.png"]];
        [self addSubview:ajkIcon];
        
        UIImageView *hzIcon = [[UIImageView alloc] initWithFrame:CGRectMake(12, 68, 20, 20)];
        [hzIcon setImage:[UIImage imageNamed:@"icon_3.4_02.png"]];
        [self addSubview:hzIcon];
        
        UIButton *ajkBut = [UIButton buttonWithType:UIButtonTypeCustom];
        ajkBut.frame = CGRectMake(35, 20, 70, 30);
        [ajkBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [ajkBut setTitle:@"发二手房" forState:UIControlStateNormal];
//        ajkBut.backgroundColor = [UIColor redColor];
        ajkBut.titleLabel.textAlignment = NSTextAlignmentLeft;
        ajkBut.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [ajkBut addTarget:self action:@selector(ajkClick:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:ajkBut];
        
        UIButton *haozuBut = [UIButton buttonWithType:UIButtonTypeCustom];
        haozuBut.frame = CGRectMake(38, 60, 50, 30);
//        haozuBut.backgroundColor = [UIColor redColor];
        haozuBut.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        haozuBut.titleLabel.textAlignment = NSTextAlignmentLeft;
        [haozuBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [haozuBut setTitle:@"发租房" forState:UIControlStateNormal];
        [haozuBut addTarget:self action:@selector(haozuClick:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:haozuBut];
        
    }
    return self;
}

- (void)ajkClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didClickSectionAtIndex:)]) {
        [_delegate didClickSectionAtIndex:0];
    }
    
}

- (void)haozuClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didClickSectionAtIndex:)]) {
        [_delegate didClickSectionAtIndex:1];
    }
}
@end
