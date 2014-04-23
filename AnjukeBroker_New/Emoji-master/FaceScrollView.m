//
//  FaceScrollView.m
//  WeiboDemo1
//
//  Created by leo.zhu on 14-2-8.
//  Copyright (c) 2014年 3k. All rights reserved.
//

#import "FaceScrollView.h"
#import "KKPageControl.h"
#import "UIViewExt.h"

@interface FaceScrollView ()

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) KKPageControl* pageControl;

@end

@implementation FaceScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.faceView = [[FaceView alloc] initWithFrame:CGRectZero];
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.faceView.height)];
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(_faceView.width, _faceView.height);
    //超出部分是否裁剪,默认是
    _scrollView.clipsToBounds = NO;
    [_scrollView addSubview:_faceView];
    [self addSubview:_scrollView];
    
    self.pageControl = [[KKPageControl alloc] initWithFrame:CGRectMake(ScreenWidth/2-100, _scrollView.bottom + 5, 200, 20)];
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.numberOfPages = _faceView.pageNumber;
    _pageControl.dotColorCurrentPage = [UIColor grayColor];
    _pageControl.dotColorOtherPage = [UIColor colorWithWhite:0.8 alpha:1];

    [self addSubview:_pageControl];
    
    //底部的toolbar
    UIView* toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, _pageControl.bottom+5, ScreenWidth, 42)];
    toolBar.layer.borderColor = [UIColor colorWithWhite:0.6 alpha:1].CGColor;
    toolBar.layer.borderWidth = 0.5f;
    
    UIScrollView* emojiSet = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-64, 42)];
//    emojiSet.backgroundColor = [UIColor yellowColor];
    emojiSet.contentSize = CGSizeMake(72*5, 42);
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 72, 42);
    button.backgroundColor = [UIColor grayColor];
    [button setTitle:@"Emoji" forState:UIControlStateNormal];
    [emojiSet addSubview:button];
    [toolBar addSubview:emojiSet];
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendButton.frame = CGRectMake(emojiSet.right, 0, 64, 42);
    self.sendButton.layer.borderWidth = 0.5f;
    self.sendButton.layer.borderColor = [UIColor colorWithWhite:0.6 alpha:1].CGColor;
    
//    sendButton.layer.shadowOpacity = 0.2;
//    sendButton.layer.shadowRadius = 1;
//    sendButton.layer.shadowOffset = CGSizeMake(-1.0f, 0.0f);
//    sendButton.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectInset(sendButton.bounds, -1.0f, 1.0f)].CGPath;
    
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.sendButton setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1]];
    [self.sendButton addTarget:self action:@selector(sendEmoji) forControlEvents:UIControlEventTouchUpInside];
    self.sendButton.enabled = NO;
    [toolBar addSubview:self.sendButton];
    
    [self addSubview:toolBar];
    
    self.height = _scrollView.height + _pageControl.height;
    self.width = _scrollView.width;
    
}

- (void)sendEmoji{
    if (self.sendButtonClick != nil) {
        _sendButtonClick();
    }
}


#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //    scrollView isKindOfClass;
    //    scrollView isMemberOfClass;
    //    这里注意两者的差别
    if ([scrollView isKindOfClass:[UITableView class]]) { //因为表视图控制器也实现了滚动协议
        NSLog(@"table view 滚动结束");
    }else{
        //        NSLog(@"scroll view 滚动结束");
        //        NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
        self.pageControl.currentPage = self.scrollView.contentOffset.x / ScreenWidth;
    }
    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [[UIImage imageNamed:@"facesBack"] drawInRect:rect]; //自动拉伸图片,铺满整个View
}


@end
