//
//  PublishBigImageViewController.m
//  AnjukeBroker_New
//
//  Created by paper on 14-1-26.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PublishBigImageViewController.h"
#import "Util_UI.h"
#import "PhotoButton.h"

#import "E_Photo.h"

@interface PublishBigImageViewController ()

@property (nonatomic, strong) NSMutableArray *imgArr;
@property (nonatomic, strong) NSMutableArray *buttonImgArr;

@property (nonatomic, strong) UIScrollView *mainScroll;
@property int currentIndex;

@property (nonatomic, strong) UIImageView *leftIcon;
@property (nonatomic, strong) UIImageView *rightIcon;

@property BOOL isHouseType;

@end

@implementation PublishBigImageViewController
@synthesize clickDelegate;
@synthesize imgArr;
@synthesize buttonImgArr;
@synthesize mainScroll;
@synthesize currentIndex;
@synthesize leftIcon, rightIcon;
@synthesize isHouseType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    DLog(@"dealloc PublishBigImageViewController");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setTitleViewWithString:@"查看大图"];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doBack:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(doDelete)];
    self.navigationItem.rightBarButtonItem = deleteItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initModel {
    self.imgArr = [NSMutableArray array];
    self.buttonImgArr = [NSMutableArray array];
}

- (void)initDisplay {
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:FRAME_WITH_NAV];
    sv.backgroundColor = SYSTEM_BLACK;
    sv.delegate = self;
    sv.pagingEnabled = YES;
    self.mainScroll = sv;
    sv.contentSize = CGSizeMake([self windowWidth], [self currentViewHeight]);
    [self.view addSubview:sv];
}

#pragma mark - Private Method

- (void)doDelete {
    if (self.isHouseType) {
        //通知删除在线户型图。。。并退出
        if ([self.clickDelegate respondsToSelector:@selector(onlineHouseTypeImgDelete)]) {
            [self.clickDelegate onlineHouseTypeImgDelete];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else { //非在线户型图查看，删除后重绘页面
        if (self.currentIndex == self.self.imgArr.count - 1) { //如果是最后一项删除，则将当前选择的index前移一位
            [self.imgArr removeLastObject];
            self.currentIndex --;
        }
        else
            [self.imgArr removeObjectAtIndex:self.currentIndex];
        
        if (self.imgArr.count <= 0) {
            [self doBack:self];
        }
        
        //redraw
        [self redrawImageScroll];
    }
}

- (void)doBack:(id)sender {
    if (self.isHouseType) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    //设置...
    if ([self.clickDelegate respondsToSelector:@selector(viewDidFinishWithImageArr:)]) {
        [self.clickDelegate viewDidFinishWithImageArr:self.imgArr];
    }
    
    //do back
    [self dismissViewControllerAnimated:YES completion:nil];
}

//绘制图片
- (void)drawImageScroll {
    
    [self showLoadingActivity:YES];
    
    CGFloat buttonW = [self windowWidth];
    CGFloat buttonGap = ([self currentViewHeight] - buttonW) /2;
    
    for (int i = 0; i < self.imgArr.count; i ++) {
        PhotoButton *pb = [[PhotoButton alloc] initWithFrame:CGRectMake(0 + buttonW*i, buttonGap, buttonW, buttonW)];
        pb.tag = i;
        NSString *url = nil;
        url =  [(E_Photo *)[self.imgArr objectAtIndex:i] smallPhotoUrl];
        pb.photoImg.image = [UIImage imageWithContentsOfFile:url];
        [self.buttonImgArr addObject:pb];
        [self.mainScroll addSubview:pb];
    }
    
    self.mainScroll.contentSize = CGSizeMake([self windowWidth] * self.imgArr.count, [self currentViewHeight]);
    self.mainScroll.contentOffset = CGPointMake([self windowWidth] * self.currentIndex, 0);
    
    [self showArrowImg];
    
    [self hideLoadWithAnimated:YES];
}

- (void)redrawImageScroll {
    for (int i = 0; i < self.buttonImgArr.count; i ++) {
        [[self.buttonImgArr objectAtIndex:i] removeFromSuperview];
    }
    [self.buttonImgArr removeAllObjects];
    
    [self drawImageScroll];
}

- (void)showArrowImg {
    if (self.imgArr.count >1) {
        if (!self.leftIcon) {
            CGFloat imgGap = 3;
            CGFloat imgH = 26/2;
            CGFloat imgW = 17/2;
            
            UIImageView *leftImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"details_arrow_left.png"]];
            leftImg.backgroundColor = [UIColor clearColor];
            leftImg.frame = CGRectMake(imgGap, ([self currentViewHeight]- imgH)/2 -imgGap, imgW, imgH);
            self.leftIcon = leftImg;
            
            UIImageView *rightImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"details_arrow_right.png"]];
            rightImg.backgroundColor = [UIColor clearColor];
            rightImg.frame = CGRectMake([self windowWidth] - imgW- imgGap, ([self currentViewHeight]- imgH)/2 -imgGap, imgW, imgH);
            self.rightIcon = rightImg;
        }
        
        [self.view addSubview:self.leftIcon];
        [self.view addSubview:self.rightIcon];
    }
    else { //hide
        [self.leftIcon removeFromSuperview];
        [self.rightIcon removeFromSuperview];
    }
}

#pragma mark - Public Method

- (void)showImagesWithArray:(NSArray *)imageArr atIndex:(int)index {
    [self.imgArr addObjectsFromArray:imageArr];
    self.currentIndex = index;
    
    [self drawImageScroll];
}

//在线户型图单独显示
- (void)showImagesForOnlineHouseTypeWithDic:(NSDictionary *)dic {
    self.isHouseType = YES;
    
    [self showLoadingActivity:YES];
    
    CGFloat buttonW = [self windowWidth];
    CGFloat buttonGap = ([self currentViewHeight] - buttonW) /2;
    
    PhotoButton *pb = [[PhotoButton alloc] initWithFrame:CGRectMake(0, buttonGap, buttonW, buttonW)];
    pb.photoImg.imageUrl = [dic objectForKey:@"url"];
    [self.buttonImgArr addObject:pb];
    [self.mainScroll addSubview:pb];
    
    self.mainScroll.contentSize = CGSizeMake([self windowWidth], [self currentViewHeight]);
    self.mainScroll.contentOffset = CGPointMake(0, 0);
    
    [self hideLoadWithAnimated:YES];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.currentIndex = scrollView.contentOffset.x / [self windowWidth];
    DLog(@"index [%d]", self.currentIndex);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        //
    }
}

@end
