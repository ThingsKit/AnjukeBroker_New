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
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
        [img setImage:[UIImage imageNamed:@"wl_launchframe_bg"]];
        [self addSubview:img];
        
        UIButton *ajkBut = [UIButton buttonWithType:UIButtonTypeCustom];
        ajkBut.frame = CGRectMake(0, 10, 100, 30);
        [ajkBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [ajkBut setTitle:@"二手房" forState:UIControlStateNormal];
        [ajkBut addTarget:self action:@selector(ajkClick:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:ajkBut];
        
        UIButton *haozuBut = [UIButton buttonWithType:UIButtonTypeCustom];
        haozuBut.frame = CGRectMake(0, 45, 100, 30);
        [haozuBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [haozuBut setTitle:@"租房" forState:UIControlStateNormal];
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
