//
//  MJPhotoBrowser.m
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <QuartzCore/QuartzCore.h>
#import "AXPhotoBrowser.h"
#import "AXPhoto.h"
#import "AXPhotoView.h"
#import "AXMessage.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "AXChatPhotoActionSheet.h"

#define kPadding 10
#define kPhotoViewTagOffset 1000
#define kPhotoViewIndex(photoView) ([photoView tag] - kPhotoViewTagOffset)

@interface AXPhotoBrowser ()
{
    // 滚动的view
	UIScrollView *_photoScrollView;
    // 所有的图片view
	NSMutableSet *_visiblePhotoViews;
    NSMutableSet *_reusablePhotoViews;
}
@end

@implementation AXPhotoBrowser

#pragma mark - Lifecycle
- (void)loadView
{
    
    //    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    self.view = [[UIView alloc] init];
    self.view.frame = [UIScreen mainScreen].bounds;
	self.view.backgroundColor = [UIColor blackColor];
}

- (void)dealloc {
    _photoScrollView.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavTitle];
    // 1.创建UIScrollView
    [self createScrollView];
    [self initRightBar];
}
- (void)setNavTitle {
    NSString *navTitle = [NSString stringWithFormat:@"%d/%d",_currentPhotoIndex + 1,_photos.count];
    NSLog(@"===========title=======%@", navTitle);
    self.navigationItem.title = navTitle;
}
- (void)initRightBar {
    if (self.isBroker) {
        return;
    }
    UIButton *rightBar = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBar.frame = CGRectMake(0, 0, 21, 5);
    [rightBar setImage:[UIImage imageNamed:@"xproject_dialogue_more.png"] forState:UIControlStateNormal];
    [rightBar setImage:[UIImage imageNamed:@"xproject_dialogue_more_selected.png"] forState:UIControlStateHighlighted];
    [rightBar addTarget:self  action:@selector(rightBarClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_currentPhotoIndex == 0) {
        [self showPhotoViewAtIndex:_currentPhotoIndex];
    }
    //    [self showPhotoViewAtIndex:_currentPhotoIndex];
}

#pragma mark 创建UIScrollView
- (void)createScrollView
{
    CGRect frame = self.view.bounds;
    frame.origin.x -= kPadding;
    frame.size.width += (2 * kPadding);
	_photoScrollView = [[UIScrollView alloc] initWithFrame:frame];
	_photoScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_photoScrollView.pagingEnabled = YES;
	_photoScrollView.delegate = self;
	_photoScrollView.showsHorizontalScrollIndicator = NO;
	_photoScrollView.showsVerticalScrollIndicator = NO;
	_photoScrollView.backgroundColor = [UIColor clearColor];
    _photoScrollView.contentSize = CGSizeMake(frame.size.width * _photos.count, 0);
    _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * frame.size.width, 0);
	[self.view addSubview:_photoScrollView];

}

- (void)show
{
    return;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.view];
    [window.rootViewController addChildViewController:self];
    
    if (_currentPhotoIndex == 0) {
        [self showPhotos];
    }
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    if (photos.count > 1) {
        _visiblePhotoViews = [NSMutableSet set];
        _reusablePhotoViews = [NSMutableSet set];
    }
    
    for (int i = 0; i<_photos.count; i++) {
        AXPhoto *photo = _photos[i];
        photo.index = i;
        photo.firstShow = i == _currentPhotoIndex;
    }
}

#pragma mark 设置选中的图片
- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
    [self setNavTitle];
    for (int i = 0; i<_photos.count; i++) {
        AXPhoto *photo = _photos[i];
        photo.firstShow = i == currentPhotoIndex;
    }
    
    if ([self isViewLoaded]) {
        _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * _photoScrollView.frame.size.width, 0);
        
        // 显示所有的相片
        [self showPhotos];
    }
}

#pragma mark 显示照片
- (void)showPhotos
{
    [self setNavTitle];
    // 只有一张图片
    if (_photos.count == 1) {
        
        [self showPhotoViewAtIndex:0];
        return;
    }
    
    CGRect visibleBounds = _photoScrollView.bounds;
	int firstIndex = (int)floorf((CGRectGetMinX(visibleBounds)+kPadding*2) / CGRectGetWidth(visibleBounds));
	int lastIndex  = (int)floorf((CGRectGetMaxX(visibleBounds)-kPadding*2-1) / CGRectGetWidth(visibleBounds));
    if (firstIndex < 0) firstIndex = 0;
    if (firstIndex >= _photos.count) firstIndex = _photos.count - 1;
    if (lastIndex < 0) lastIndex = 0;
    if (lastIndex >= _photos.count) lastIndex = _photos.count - 1;
	
	// 回收不再显示的ImageView
    NSInteger photoViewIndex;
	for (AXPhotoView *photoView in _visiblePhotoViews) {
        photoViewIndex = kPhotoViewIndex(photoView);
		if (photoViewIndex < firstIndex || photoViewIndex > lastIndex) {
			[_reusablePhotoViews addObject:photoView];
			[photoView removeFromSuperview];
		}
	}
    
	[_visiblePhotoViews minusSet:_reusablePhotoViews];
    while (_reusablePhotoViews.count > 2) {
        [_reusablePhotoViews removeObject:[_reusablePhotoViews anyObject]];
    }
	
	for (NSUInteger index = firstIndex; index <= lastIndex; index++) {
		if (![self isShowingPhotoViewAtIndex:index]) {
			[self showPhotoViewAtIndex:index];
		}
	}
}

#pragma mark 显示一个图片view
- (void)showPhotoViewAtIndex:(int)index
{
    _currentPhotoIndex = index;
    AXPhotoView *photoView = [self dequeueReusablePhotoView];
    if (!photoView) { // 添加新的图片view
        photoView = [[AXPhotoView alloc] init];
        photoView.photoViewDelegate = self;
        //        if ([[_photos objectAtIndex:index] isKindOfClass:[AXPhoto class]]) {
        //            AXPhoto *message = [_photos objectAtIndex:index];
        //            [photoView setImageWithURL:nil placeholderImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:message.picMessage.imgUrl]]];
        //
        //        }
        
        //[photoView setImageWit]
    }
    
    // 调整当期页的frame
    CGRect bounds = _photoScrollView.bounds;
    CGRect photoViewFrame = bounds;
    photoViewFrame.size.width -= (2 * kPadding);
    photoViewFrame.origin.x = (bounds.size.width * index) + kPadding;
    photoView.tag = kPhotoViewTagOffset + index;
    
    AXPhoto *photo = _photos[index];
    photoView.frame = photoViewFrame;
    photoView.photo = photo;
    
    [_visiblePhotoViews addObject:photoView];
    [_photoScrollView addSubview:photoView];
    
    [self loadImageNearIndex:index];
}

#pragma mark 加载index附近的图片
- (void)loadImageNearIndex:(int)index
{
    if (index > 0) {
        //        AXPhoto *photo = _photos[index - 1];
        
        //#warning downloadIMG and set img to photo
        
    }
    
    if (index < _photos.count - 1) {
        //        AXPhoto *photo = _photos[index + 1];
        
        //#warning downloadIMG
    }
}

#pragma mark index这页是否正在显示
- (BOOL)isShowingPhotoViewAtIndex:(NSUInteger)index {
	for (AXPhotoView *photoView in _visiblePhotoViews) {
		if (kPhotoViewIndex(photoView) == index) {
            return YES;
        }
    }
	return  NO;
}

#pragma mark 循环利用某个view
- (AXPhotoView *)dequeueReusablePhotoView
{
    AXPhotoView *photoView = [_reusablePhotoViews anyObject];
	if (photoView) {
		[_reusablePhotoViews removeObject:photoView];
	}
	return photoView;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self showPhotos];
}

#pragma mark - AXPhotoViewDelegate
- (void)photoViewImageFinishLoad:(AXPhotoView *)photoView{
    
}

- (void)photoViewSingleTap:(AXPhotoView *)photoView {
    
}

- (void)photoViewDidEndZoom:(AXPhotoView *)photoView {
    
}
#pragma mark - privateMethods
- (void)rightBarClick:(id)sender {
    AXChatPhotoActionSheet *actionSheet = [[AXChatPhotoActionSheet alloc] init];
    [actionSheet showWithBlock:^(NSUInteger index) {
        if (index) {
            if (((AXPhoto *)[_photos objectAtIndex:_currentPhotoIndex]).image) {
                UIImageWriteToSavedPhotosAlbum(((AXPhoto *)[_photos objectAtIndex:_currentPhotoIndex]).image, nil, nil,nil);
            }
//            [self showInfo:@"已保存到手机相册" autoHidden:YES];
        }
    }];
}

@end
