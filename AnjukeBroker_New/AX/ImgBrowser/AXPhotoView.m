//
//  MJZoomingScrollView.m
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "AXPhotoView.h"
#import "AXPhoto.h"
#import <QuartzCore/QuartzCore.h>

@interface AXPhotoView ()
{
    BOOL _doubleTap;
    UIImageView *_imageView;
}
@end

@implementation AXPhotoView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.clipsToBounds = YES;
		// 图片
		_imageView = [[UIImageView alloc] init];
		_imageView.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:_imageView];
		
		// 属性
		self.backgroundColor = [UIColor clearColor];
		self.delegate = self;
		self.showsHorizontalScrollIndicator = NO;
		self.showsVerticalScrollIndicator = NO;
		self.decelerationRate = UIScrollViewDecelerationRateFast;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // 监听点击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.delaysTouchesBegan = YES;
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
    }
    return self;
}

#pragma mark - photoSetter
- (void)setPhoto:(AXPhoto *)photo {
    _photo = photo;
    
    [self showImage];
}

#pragma mark 显示图片
- (void)showImage
{
    if (_photo.firstShow) { // 首次显示
        _imageView.image = _photo.placeholder; // 占位图片
//        _photo.srcImageView.image = nil;
        if (![_photo.url.absoluteString hasSuffix:@"gif"]) {
            _imageView.image = _photo.image;
        }
    } else {
        [self photoStartLoad];
    }
    [self adjustFrame];
}

#pragma mark 开始加载图片
- (void)photoStartLoad
{
    if (_photo.image) {
        self.scrollEnabled = YES;
        _imageView.image = _photo.image;
    } else {
        self.scrollEnabled = NO;
        _imageView.image = [UIImage imageNamed:@"timeline_image_loading@2x.png"];
    }
}

#pragma mark 加载完毕
- (void)photoDidFinishLoadWithImage:(UIImage *)image
{
    if (image) {
        self.scrollEnabled = YES;
        _photo.image = image;
        
        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewImageFinishLoad:)]) {
            [self.photoViewDelegate photoViewImageFinishLoad:self];
        }
    } else {
    }
    
    // 设置缩放比例
    [self adjustFrame];
}
#pragma mark 调整frame
- (void)adjustFrame
{
	if (_imageView.image == nil) return;
    
    // 基本尺寸参数
    CGSize boundsSize = self.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    
    CGSize imageSize = _imageView.image.size;
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
	
	// 设置伸缩比例
    CGFloat minScale = boundsWidth / imageWidth;
	if (minScale > 1) {
		minScale = 1.0;
	}
	CGFloat maxScale = 2.0; 
	if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
		maxScale = maxScale / [[UIScreen mainScreen] scale];
	}
	self.maximumZoomScale = maxScale;
	self.minimumZoomScale = minScale;
	self.zoomScale = minScale;
    
    CGRect imageFrame = CGRectMake(0, 0, boundsWidth, imageHeight * boundsWidth / imageWidth);
    // 内容尺寸
    self.contentSize = CGSizeMake(0, imageFrame.size.height);
    
    // y值
    if (imageFrame.size.height < boundsHeight) {
        imageFrame.origin.y = floorf((boundsHeight - imageFrame.size.height) / 2.0);
	} else {
        imageFrame.origin.y = 0;
	}
    
    if (_photo.firstShow) { // 第一次显示的图片
        _photo.firstShow = NO; // 已经显示过了
//        _imageView.frame = [_photo.srcImageView convertRect:_photo.srcImageView.bounds toView:nil];
        
        [UIView animateWithDuration:0.3 animations:^{
            _imageView.frame = imageFrame;
        } completion:^(BOOL finished) {
            // 设置底部的小图片
//            _photo.srcImageView.image = _photo.placeholder;
            [self photoStartLoad];
        }];
    } else {
        _imageView.frame = imageFrame;
    }
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return _imageView;
}

#pragma mark - 手势处理
- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    _doubleTap = NO;
    if ([self.photoViewDelegate respondsToSelector:@selector(photoViewDidEndZoom:)]) {
        [self.photoViewDelegate photoViewDidEndZoom:self];
    }
//    [self performSelector:@selector(hide) withObject:nil afterDelay:0.2];
}

- (void)reset
{
    _imageView.image = _photo.capture;
    _imageView.contentMode = UIViewContentModeScaleToFill;
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    _doubleTap = YES;
    
    CGPoint touchPoint = [tap locationInView:self];
	if (self.zoomScale == self.maximumZoomScale) {
		[self setZoomScale:self.minimumZoomScale animated:YES];
	} else {
		[self zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
	}
}

- (void)dealloc
{
    // 取消请求
//    [_imageView setImageWithURL:[NSURL URLWithString:@"file:///abc"]];
}

@end