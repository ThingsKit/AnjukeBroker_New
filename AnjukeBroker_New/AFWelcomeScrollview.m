//
//  WelcomeScrollview.m
//  AiFang
//
//  Created by Wu sicong on 13-6-26.
//  Copyright (c) 2013年 anjuke. All rights reserved.
//

#import "AFWelcomeScrollview.h"
#import "Util_UI.h"

typedef enum {
    AnimationType_Defult = 0,
    AnimationType_Overlap
}AnimationType; //展示动画效果

@interface AFWelcomeScrollview ()
@property (nonatomic, assign) AnimationType animationType;

@property int totalCount;
@property (nonatomic, strong) UIScrollView *sv;

@property (nonatomic, strong) UIImageView *backgroundImgView;
@property (nonatomic, strong) UIScrollView *svForImg; //overlatType动画的底图

@end

@implementation AFWelcomeScrollview
@synthesize totalCount;
@synthesize animationType;
@synthesize backgroundImgView, svForImg;

#define showWidth 50
#define tagOfPageController 1001

#define sOffsetX 100

#define anjukeGray [UIColor colorWithRed:0.69 green:0.69 blue:0.69 alpha:1]
#define anjukeGreen [UIColor colorWithRed:0.2 green:0.67 blue:0 alpha:1]

#define btnLabelFont 26

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initScrollView];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        // Initialize self.
        [self initScrollView];
    }
    return self;
}

- (void)dealloc {
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - Private Method

- (void)initScrollView {
    // Initialization code
    UIScrollView *s = [[UIScrollView alloc] init];
    s.frame = self.bounds;
    s.delegate = self;
    s.pagingEnabled = YES;
    s.backgroundColor = [UIColor clearColor];
    s.showsHorizontalScrollIndicator = NO;
    s.showsVerticalScrollIndicator = NO;
    self.sv = s;
    [self addSubview:s];
}

- (void)addPageController {
    UIPageControl *pc = [[UIPageControl alloc] initWithFrame:CGRectMake(50, [self getWindowHeight] - 40, [self getWindowWidth]- 50*2, 20)];
    pc.numberOfPages = self.totalCount;
    pc.currentPage = 0;
    pc.tag = tagOfPageController;
    pc.backgroundColor = [UIColor clearColor];
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 6) {
        pc.pageIndicatorTintColor = anjukeGray;
        pc.currentPageIndicatorTintColor = SYSTEM_ORANGE;
    }
    [self addSubview:pc];
}

- (void)setImgArray:(NSArray *)imgArray {
    self.animationType = AnimationType_Defult;
    self.totalCount = imgArray.count;
    
    self.sv.contentSize = CGSizeMake([self getWindowWidth] *imgArray.count, [self getWindowHeight]);
    self.sv.backgroundColor = [UIColor whiteColor];
    
    [self addPageController];
    
    CGFloat imgGapH = 50;
    if ([self getWindowHeight] <= 960/2) { //iPhone4\4s
        imgGapH = 10;
    }
    
    for (int i = 0; i < imgArray.count; i ++) {
        UIImageView *img = [[UIImageView alloc] initWithImage:[imgArray objectAtIndex:i]];
        img.frame = CGRectMake(0 + [self getWindowWidth] *i, imgGapH, [self getWindowWidth], [self getWindowHeight]-50);
        img.backgroundColor = [UIColor clearColor];
        img.contentMode = UIViewContentModeTop;
        [self.sv addSubview:img];
        
        //add hide btn
        if (i == imgArray.count - 1) {
            int btnOriginX = 80;
            int btnH = 40;
            UIButton *hideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            hideBtn.frame = CGRectMake(btnOriginX + [self getWindowWidth] * (imgArray.count - 1), [self getWindowHeight]-100, [self getWindowWidth]-btnOriginX*2, btnH);
            [hideBtn setBackgroundColor:SYSTEM_ORANGE];
//            hideBtn.layer.borderColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1].CGColor;
//            hideBtn.layer.borderWidth = 0.5;
            hideBtn.layer.cornerRadius = 3;
            [hideBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [hideBtn setBackgroundImage:[[UIImage imageNamed:@"anjuke_50btn01_normal.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:4] forState:UIControlStateNormal];
//            [hideBtn setBackgroundImage:[[UIImage imageNamed:@"anjuke_50btn01_selected.png"] stretchableImageWithLeftCapWidth:4 topCapHeight:4] forState:UIControlStateHighlighted];
            [hideBtn setTitle:@"立 即 体 验" forState:UIControlStateNormal];
            [hideBtn addTarget:self action:@selector(hideScrollview) forControlEvents:UIControlEventTouchUpInside];
            [self.sv addSubview:hideBtn];
        }
    }
}

- (void)setImageBG:(NSString *)imageName withTitleArray:(NSArray *)titleArray {
    self.animationType = AnimationType_Overlap;
    self.totalCount = titleArray.count;
    
    // Initialization code
    UIScrollView *s = [[UIScrollView alloc] init];
    s.frame = self.bounds;
    s.pagingEnabled = YES;
    s.backgroundColor = [UIColor clearColor];
    self.svForImg = s;
    [self addSubview:self.svForImg]; //放在最底层
    
    //
    [self insertSubview:self.sv aboveSubview:self.svForImg];
    
    UIImageView *imgBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    self.backgroundImgView = imgBG;
    imgBG.frame = self.svForImg.bounds;
    imgBG.backgroundColor = [UIColor clearColor];
    imgBG.contentMode = UIViewContentModeScaleToFill;
    [self.svForImg addSubview:imgBG];
    
    int lbGap = 30;
    for (int i = 0; i < titleArray.count; i ++) {
        UILabel *lb = [[UILabel alloc] init];
        lb.backgroundColor = [UIColor clearColor];
        lb.frame = CGRectMake(lbGap + [self getWindowWidth]*i, 80, [self getWindowWidth] - lbGap*2, 50);
        lb.font = [UIFont systemFontOfSize:18];
        lb.text = [titleArray objectAtIndex:i];
        lb.textColor = [UIColor blackColor];
        [self.sv addSubview:lb];
    }
    
    self.sv.contentSize = CGSizeMake([self getWindowWidth] *titleArray.count, [self getWindowHeight]);
    
    self.svForImg.contentSize = CGSizeMake([self getWindowWidth] + sOffsetX*titleArray.count, [self getWindowHeight]);
    self.backgroundImgView.frame = CGRectMake(0, 0, [self getWindowWidth] + sOffsetX*titleArray.count, [self getWindowHeight]);
    
    DLog(@"sv contentSize[%f]", self.sv.contentSize.width);
}

- (void)hideScrollview {
    [UIView animateWithDuration: 0.3
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.alpha = 0.2 ;
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             //
                             [self removeFromSuperview];
                         }
                     }];
}

- (void)scrollBackImgWithIndex:(int)index {
    
    if (self.animationType == AnimationType_Defult) {
        return;
    }
    
    [UIView animateWithDuration: 0.1
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.svForImg.contentOffset = CGPointMake(sOffsetX*index, 0);
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             //
                         }
                     }];

}

- (CGFloat)getWindowHeight {    
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    return window.frame.size.height;
}

- (CGFloat)getWindowWidth {
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    return window.frame.size.width;
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    UIPageControl *pc = (UIPageControl *)[self viewWithTag:tagOfPageController];
    
    int index = scrollView.contentOffset.x / 320;
    pc.currentPage = index;
    
    [self scrollBackImgWithIndex:index];
    
    if (index == self.totalCount -1) {
        //
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.animationType == AnimationType_Overlap) {
        //scroll imgBG
        
        int index = (int)scrollView.contentOffset.x/[self getWindowWidth];
        CGFloat offsetX_per = scrollView.contentOffset.x - index *[self getWindowWidth];
        CGFloat percent = offsetX_per/ [self getWindowWidth];
        
        self.svForImg.contentOffset = CGPointMake(sOffsetX*index + sOffsetX*percent, 0);
    }
    else if (self.animationType == AnimationType_Defult) {
        
    }
    
    if (scrollView.contentOffset.x > scrollView.contentSize.width - (scrollView.contentSize.width/self.totalCount) + showWidth) {
        
        [self hideScrollview];
    }
}

@end
