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
        self.clipsToBounds = NO;
        
//        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        self.layer.borderWidth = 0.5;
        
        //用于显示照片的控件
        BK_WebImageView *img = [[BK_WebImageView alloc] initWithFrame:self.bounds];
        self.photoImg = img;
        img.clipsToBounds = NO;
        img.contentMode = UIViewContentModeScaleToFill;
        //UIViewContentModeScaleAspectFit
        img.userInteractionEnabled = NO;
        [self addSubview:img];
        
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

- (void)showDeleteBtn {
    CGFloat dBtnW = 18;
    
    UIButton *deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deletelBtn = deleBtn;
    deleBtn.frame = CGRectMake(self.frame.size.width - dBtnW/2, -dBtnW/2, dBtnW, dBtnW);
    deleBtn.backgroundColor = [UIColor clearColor];
    [deleBtn setBackgroundImage:[UIImage imageNamed:@"anjuke_icon_delete.png"] forState:UIControlStateNormal];
    [self addSubview:deleBtn];
}

- (void)setPhotoImage:(UIImage *)image {
    if (image == nil) {
        self.deletelBtn.hidden = YES;
    }
    else
        self.deletelBtn.hidden = NO;
}

@end
