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
        
        //用于显示照片的控件
        WebImageView *img = [[WebImageView alloc] initWithFrame:self.bounds];
        self.photoImg = img;
        img.clipsToBounds = YES;
        img.contentMode = UIViewContentModeScaleAspectFill;
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
    CGFloat dBtnW = 20;
    
    UIButton *deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deletelBtn = deleBtn;
    deleBtn.frame = CGRectMake(self.frame.size.width - dBtnW +5, -5, dBtnW, dBtnW);
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
