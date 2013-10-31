//
//  PhotoButton.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-24.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "PhotoButton.h"

@implementation PhotoButton
@synthesize photoImg;
@synthesize deletelBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //用于显示照片的控件
        UIImageView *img = [[UIImageView alloc] initWithFrame:self.bounds];
        self.photoImg = img;
        img.clipsToBounds = YES;
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.userInteractionEnabled = NO;
        [self addSubview:img];
        
//        CGFloat dBtnW = 20;
//        
//        UIButton *deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.deletelBtn = deleBtn;
//        deleBtn.frame = CGRectMake(frame.size.width - dBtnW, 0, dBtnW, dBtnW);
//        deleBtn.backgroundColor = [UIColor redColor];
//        [self addSubview:deleBtn];
        
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

@end
