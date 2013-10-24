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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //用于显示照片的控件
        UIImageView *img = [[UIImageView alloc] initWithFrame:self.bounds];
        self.photoImg = img;
        img.backgroundColor = [UIColor lightGrayColor];
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

@end
