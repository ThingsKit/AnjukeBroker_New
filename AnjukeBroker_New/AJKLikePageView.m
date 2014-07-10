//
//  AJKLikePageView.m
//  AnjukeBroker_New
//
//  Created by anjuke on 14-5-30.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "AJKLikePageView.h"

@interface AJKLikePageView ()

@property (nonatomic, strong)UIScrollView *scrView;
@property (nonatomic, strong)UIImageView  *linkImgView;
@end

@implementation AJKLikePageView
@synthesize linkImg = _linkImg;
@synthesize scrView = _scrView;
@synthesize linkImgView = _linkImgView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        CGFloat srWidth = CGRectGetWidth(frame);
        CGFloat srHeiht = CGRectGetHeight(frame);
        
        _scrView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, srWidth, srHeiht)];
        [self addSubview:_scrView];
        [_scrView setContentSize:CGSizeMake(srWidth, srHeiht)];
        [_scrView setBounces:NO];
        
        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 700, srWidth, 40)];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onclike:)];
        [tapView addGestureRecognizer:tap];
        
        _linkImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
        [_scrView addSubview:_linkImgView];
        [_scrView addSubview:tapView];
    }
    return self;
}

- (void)setLinkImg:(UIImage *)linkImg
{
//    CGFloat srWidth = CGRectGetWidth(self.window.frame);

    _linkImg = linkImg;
    [_scrView setContentSize:CGSizeMake(self.frame.size.width, linkImg.size.height/2)];
    
    [_linkImgView setFrame:CGRectMake(0, 0, 320, linkImg.size.height/2 + 60)];
    [_linkImgView setImage:linkImg];
}

- (void)onclike:(id)sender
{
    [self removeFromSuperview];
}


@end
