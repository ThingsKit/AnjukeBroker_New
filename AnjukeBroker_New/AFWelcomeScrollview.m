//
//  WelcomeScrollview.m
//  AiFang
//
//  Created by Wu sicong on 13-6-26.
//  Copyright (c) 2013年 anjuke. All rights reserved.
//

#import "AFWelcomeScrollview.h"
#import "Util_UI.h"
#import "AppManager.h"

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
@synthesize delegate;

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
    s.backgroundColor = [UIColor colorWithHex:0xF6F6F6 alpha:1.0];
    s.showsHorizontalScrollIndicator = NO;
    s.showsVerticalScrollIndicator = NO;
    self.sv = s;
    [self addSubview:s];
}

- (void)addPageController:(int)imgCount {
    for (int i = 0; i < imgCount; i++) {
        UIImageView *dot = [[UIImageView alloc] initWithFrame:CGRectMake([self getWindowWidth]/2-(20*imgCount - 10)/2+20*i, [self getWindowHeight] - 50, 10, 10)];
        dot.tag = 1000 + i;
        
        if (i == 0) {
            [dot setImage:[UIImage imageNamed:@"guild_dot_selected"]];
        }else{
            [dot setImage:[UIImage imageNamed:@"guild_dot_normal"]];
        }
        [self addSubview:dot];
    }
//    UIPageControl *pc = [[UIPageControl alloc] initWithFrame:CGRectMake(50, [self getWindowHeight] - 50, [self getWindowWidth]- 50*2, 20)];
//    pc.numberOfPages = self.totalCount;
//    pc.currentPage = 0;
//    pc.tag = tagOfPageController;
//    pc.backgroundColor = [UIColor clearColor];
//    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 6) {
//        pc.pageIndicatorTintColor = anjukeGray;
//        pc.currentPageIndicatorTintColor = SYSTEM_TABBAR_SELECTCOLOR_DARK;
//    }
//    [self addSubview:pc];
}

- (void)setImgArray:(NSArray *)imgArray {
    self.animationType = AnimationType_Defult;
    self.totalCount = imgArray.count;
    
    self.sv.contentSize = CGSizeMake([self getWindowWidth] *imgArray.count, [self getWindowHeight]);
    self.sv.backgroundColor = [UIColor whiteColor];
    
    if (imgArray.count > 1) {
        [self addPageController:imgArray.count];
    }
    
    CGFloat imgGapH = 0;
    if ([AppManager isIOS6]) {
        imgGapH = 20; //iOS6去掉20像素状态栏
    }
    
    for (int i = 0; i < imgArray.count; i ++) {
        UIImageView *img = [[UIImageView alloc] initWithImage:[imgArray objectAtIndex:i]];
        img.frame = CGRectMake(0 + [self getWindowWidth] *i, imgGapH, [self getWindowWidth], [self getWindowHeight] - imgGapH);
        img.backgroundColor = [UIColor colorWithHex:0xF6F6F6 alpha:1.0];
        
        img.contentMode = UIViewContentModeScaleAspectFit;
        img.layer.borderColor = [UIColor clearColor].CGColor;
        img.layer.borderWidth = 1;
        img.clipsToBounds = YES;
        [self.sv addSubview:img];
        
        //add hide btn
        if (i == imgArray.count - 1) {
            int btnW = 150;
            int btnOriginX = ([self getWindowWidth] - btnW)/2;
            int btnH = 45;
            UIButton *hideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            if (imgArray.count == 1) {
                hideBtn.frame = self.bounds;
                [hideBtn setBackgroundColor:[UIColor clearColor]];
            }
            else {
                hideBtn.frame = CGRectMake(btnOriginX + [self getWindowWidth] * (imgArray.count - 1), [self getWindowHeight]-btnH-80, btnW, btnH);
//                [hideBtn setBackgroundColor:SYSTEM_TABBAR_SELECTCOLOR_DARK];
                [hideBtn setBackgroundImage:[[UIImage imageNamed:@"guild_btn_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 30, 20)] forState:UIControlStateNormal];
                [hideBtn setBackgroundImage:[[UIImage imageNamed:@"guild_btn_press"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 30, 20)] forState:UIControlStateHighlighted];
                hideBtn.layer.cornerRadius = 3;
//                [hideBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                [hideBtn setTitle:@"立 即 体 验" forState:UIControlStateNormal];
            }
            
            [hideBtn addTarget:self action:@selector(hideScrollview) forControlEvents:UIControlEventTouchUpInside];
            [self.sv addSubview:hideBtn];
        }
    }
}

- (void)setImageBGArr:(NSArray  *)imageBGArr withTitleArray:(NSArray *)titleArray withImgIconArr:(NSArray *)imgIconArr withDetailArr:(NSArray *)detailArr  {
    self.animationType = AnimationType_Overlap;
    self.totalCount = titleArray.count;
    
    for (int i = 0; i < titleArray.count; i ++) {
        UIImageView *imgBG = [[UIImageView alloc] initWithFrame:CGRectMake(0 + [self getWindowWidth]*i, 0, [self getWindowWidth], [self getWindowHeight] - 0)];
        imgBG.backgroundColor = [UIColor clearColor];
        imgBG.contentMode = UIViewContentModeScaleToFill;
        imgBG.image = [imageBGArr objectAtIndex:i];
        [self.sv addSubview:imgBG];
        
        CGFloat imgIconW = 324/2;
        UIImageView *imgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(([self getWindowWidth] - imgIconW)/2, ([self getWindowWidth] - imgIconW)/2, imgIconW, imgIconW)];
        imgIcon.backgroundColor = [UIColor clearColor];
        imgIcon.contentMode = UIViewContentModeScaleToFill;
        imgIcon.image = [imgIconArr objectAtIndex:i];
        [imgBG addSubview:imgIcon];
        
        UILabel *lb = [[UILabel alloc] init];
        lb.backgroundColor = [UIColor clearColor];
        lb.frame = CGRectMake(0, imgIcon.frame.origin.y + imgIcon.frame.size.height + 30, [self getWindowWidth], 35);
        lb.font = [UIFont boldSystemFontOfSize:30];
        lb.text = [titleArray objectAtIndex:i];
        lb.textAlignment = NSTextAlignmentCenter;
        lb.textColor = [UIColor whiteColor];
        [imgBG addSubview:lb];
        
        UILabel *lb2 = [[UILabel alloc] init];
        lb2.backgroundColor = [UIColor clearColor];
        lb2.frame = CGRectMake(0, lb.frame.origin.y + lb.frame.size.height + 25, [self getWindowWidth], 20);
        lb2.font = [UIFont systemFontOfSize:17];
        lb2.text = [detailArr objectAtIndex:i];
        lb2.textAlignment = NSTextAlignmentCenter;
        lb2.textColor = [UIColor whiteColor];
        [imgBG addSubview:lb2];
    }
    
    self.sv.contentSize = CGSizeMake([self getWindowWidth] *titleArray.count, [self getWindowHeight]);
    
    self.totalCount = titleArray.count;
    [self addPageController:self.totalCount];
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
                             if ([self.delegate respondsToSelector:@selector(welcomeViewDidHide)]) {
                                 [self.delegate welcomeViewDidHide];
                             }
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
//    UIPageControl *pc = (UIPageControl *)[self viewWithTag:tagOfPageController];
    
    int index = scrollView.contentOffset.x / 320;
//    pc.currentPage = index;
    
    [self scrollBackImgWithIndex:index];

    for (int i = 0; i < scrollView.contentSize.width/320; i++) {
        UIImageView *dot = (UIImageView *)[self viewWithTag:i+1000];
        if (i == index) {
            [dot setImage:[UIImage imageNamed:@"guild_dot_selected"]];
        }else{
            [dot setImage:[UIImage imageNamed:@"guild_dot_normal"]];
        }
    }

    
    if (index == self.totalCount -1) {
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
