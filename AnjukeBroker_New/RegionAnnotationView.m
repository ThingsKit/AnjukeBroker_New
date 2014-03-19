//
//  RegionAnnotationView.m
//  AnjukeBroker_New
//
//  Created by shan xu on 14-3-19.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RegionAnnotationView.h"
#import "RegionAnnotation.h"
#import "MapViewController.h"

@implementation RegionAnnotationView
@synthesize regionDetailView;
//@synthesize loadingView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}
-(void)initUI{
    if (self.regionDetailView) {
        [self.regionDetailView removeFromSuperview];
    }
    self.regionDetailView = [[UIView alloc] init];
    self.regionDetailView.backgroundColor = [UIColor lightGrayColor];
//    self.loadingView = [[UIView alloc] init];
//    self.loadingView.frame = CGRectMake(-60, -60, 120, 40);
//    [self.regionDetailView addSubview:self.loadingView];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    
    RegionAnnotation *regionAnnotaytion = self.annotation;
    self.canShowCallout = YES;
    self.annotation = regionAnnotaytion;
    if (selected) {
        switch (regionAnnotaytion.loadStatus) {
            case RegionLoading:
                [self loadLoadingView];
                break;
            case RegionLoadSuc:
                NSLog(@"RegionLoadSuc1");
                [self loadSucView:regionAnnotaytion];
                break;
            case RegionLoadFail:
                [self loadFailView];
                break;
            case RegionLoadForNavi:
                [self loadNaviView:regionAnnotaytion];
                break;
            default:
                break;
        }        
    }else{
//        [self.regionDetailView removeFromSuperview];
    }
}
-(void)loadLoadingView{
//    UIView *regionDetailView = [[UIView alloc] init];
//    regionDetailView.backgroundColor = [UIColor lightGrayColor];
    [self initUI];
    
    regionDetailView.frame = CGRectMake(-60, -60, 120, 40);
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//    activityIndicator.center = CGPointMake(100.0f, 100.0f);
    activityIndicator.frame = CGRectMake(0, 0, 40, 40);
    [regionDetailView addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    UILabel *loadingLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 80, 40)];
    loadingLab.text = @"加载中...";
    loadingLab.font = [UIFont systemFontOfSize:13];
    [regionDetailView addSubview:loadingLab];
    
    [self animateCalloutAppearance];
    [self addSubview:regionDetailView];
}
-(void)loadSucView:(RegionAnnotation *)annotation{
    [self initUI];
    NSLog(@"RegionLoadSuc2");
    CGSize addSize = [self getSizeOfString:annotation.title maxWidth:290 withFontSize:13];
    NSLog(@"addSize-->>%f/%f",addSize.width,addSize.height);
    regionDetailView.frame = CGRectMake(-(addSize.width+10)/2, -60, addSize.width+10, 40);
    
    UILabel *addressLab = [[UILabel alloc] init];
    addressLab.frame = CGRectMake(5, 5, addSize.width, addSize.height);
    addressLab.font = [UIFont systemFontOfSize:13];
    [addressLab setNumberOfLines:0];
    addressLab.text = annotation.title;
//    addressLab.lineBreakMode = UILineBreakModeWordWrap;
    [regionDetailView addSubview:addressLab];

    [self animateCalloutAppearance];
    [self addSubview:regionDetailView];
}
-(void)loadNaviView:(RegionAnnotation *)annotation{
    CGSize addSize = [self getSizeOfString:annotation.title maxWidth:240 withFontSize:13];
    NSLog(@"addSize-->>%f/%f",addSize.width,addSize.height);
    regionDetailView.frame = CGRectMake(-(addSize.width+10+50)/2, -60, addSize.width+10+50, 40);
    
    UILabel *addressLab = [[UILabel alloc] init];
    addressLab.frame = CGRectMake(5, 5, addSize.width, addSize.height);
    addressLab.font = [UIFont systemFontOfSize:13];
    [addressLab setNumberOfLines:0];
    addressLab.text = annotation.title;
//    addressLab.lineBreakMode = UILineBreakModeWordWrap;
    [regionDetailView addSubview:addressLab];
    
    UIButton *naviBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    naviBtn.backgroundColor = [UIColor blackColor];
    [naviBtn addTarget:self action:@selector(naviMap:) forControlEvents:UIControlEventTouchUpInside];
    naviBtn.frame = CGRectMake(addSize.width+15, 5, 40, 30);
    [regionDetailView addSubview:naviBtn];
    
//    self.rightCalloutAccessoryView = naviBtn;
    
    [self animateCalloutAppearance];
    [self addSubview:regionDetailView];
}
-(void)naviMap:(UIButton *)btn{
    NSLog(@"naviMap");

    MapViewController *mapView = [[MapViewController alloc] init];
    
    if ([mapView respondsToSelector:@selector(navOption)]) {
        [mapView navOption];
    }
}
-(void)loadFailView{
//    UIView *regionDetailView = [[UIView alloc] init];
//    regionDetailView.backgroundColor = [UIColor lightGrayColor];

    [self initUI];
    regionDetailView.frame = CGRectMake(-60, -60, 120, 40);
    
    UILabel *addressLab = [[UILabel alloc] init];
    addressLab.frame = CGRectMake(0, 0, 120, 40);
    addressLab.font = [UIFont systemFontOfSize:13];
    addressLab.text = @"重新滑动寻址";
    addressLab.textAlignment = NSTextAlignmentCenter;
    [regionDetailView addSubview:addressLab];

    [self animateCalloutAppearance];
    [self addSubview:regionDetailView];
}

// 获取指定最大宽度和字体大小的string的size
- (CGSize)getSizeOfString:(NSString *)string maxWidth:(float)width withFontSize:(int)fontSize {
	UIFont *font = [UIFont systemFontOfSize:fontSize];
	CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(width, 10000.0f) lineBreakMode:NSLineBreakByWordWrapping];
	return size;
}

- (void)animateCalloutAppearance {
    CGFloat scale = 0.001f;
    self.regionDetailView.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, 0, -50);
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGFloat scale = 1.1f;
        self.regionDetailView.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, 0, 2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGFloat scale = 0.95;
            self.regionDetailView.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, 0, -2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.075 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                CGFloat scale = 1.0;
                self.regionDetailView.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, 0, 0);
            } completion:nil];
        }];
    }];
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
