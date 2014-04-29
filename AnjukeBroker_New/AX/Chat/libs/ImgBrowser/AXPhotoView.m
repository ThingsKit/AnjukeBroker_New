//
//  MJZoomingScrollView.m
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "AXPhotoView.h"
#import "AXPhoto.h"
#import <QuartzCore/QuartzCore.h>
#import "AXPhotoManager.h"
#import "AXChatMessageCenter.h"
#import "AXIMGDownloader.h"

static NSString * const AXPhotoFolderName = @"AXCaht_AJK_Broker";

@interface AXPhotoView ()
{
    BOOL _doubleTap;
     WebImageView *_imageView;
}

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) AXIMGDownloader *imgDownloader;

@end

@implementation AXPhotoView
@synthesize imageView = _imageView;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.clipsToBounds = YES;
        self.bounces = YES;
        // 图片
        _imageView = [[WebImageView alloc] init];
        _imageView.frame = CGRectZero;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        _imageView.image = _photo.image;
		// 属性
		self.backgroundColor = [UIColor clearColor];
		self.delegate = self;
		self.showsHorizontalScrollIndicator = NO;
		self.showsVerticalScrollIndicator = NO;
		self.decelerationRate = UIScrollViewDecelerationRateFast;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.scrollEnabled = YES;
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

- (AXIMGDownloader *)imgDownloader {
    if (_imgDownloader == nil) {
        _imgDownloader = [[AXIMGDownloader alloc] init];
    }
    return _imgDownloader;
}

- (IMGDowloaderManager *)downloader {
    if (_downloader == nil) {
        _downloader = [[IMGDowloaderManager alloc] init];
    }
    return _downloader;
}

- (void)dealloc {
    _imageView = nil;
    _photo = nil;
    [_downloader cancelAllRequest];
}

#pragma mark - photoSetter
- (void)setPhoto:(AXPhoto *)photo {
    _photo = photo;
    
    [self showImage];
}
- (NSString *)fixedImgPath:(NSString *) imgPath {
    NSString *libPath = [AXPhotoManager getLibrary:nil];
    
    NSArray *imgArray = [imgPath componentsSeparatedByString:@"/"];
    
    NSString *resultPath = [NSString stringWithFormat:@"%@/%@/%@",libPath ,[imgArray objectAtIndex:[imgArray count] - 2], [imgArray objectAtIndex:[imgArray count] - 1]];
    
    
    return resultPath;
}
#pragma mark 显示图片
- (void)showImage
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.labelText = @"加载中…";
    if (_photo.firstShow) { // 首次显示
        //        _imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:_photo.picMessage.imgPath]];; // 占位图片
        if (_photo.picMessage.imgPath.length > 0) {
            _photo.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[self fixedImgPath:_photo.picMessage.imgPath]]];
            _imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[self fixedImgPath:_photo.picMessage.imgPath]]];
            [MBProgressHUD hideAllHUDsForView:self animated:YES];
            [self adjustFrame];
        } else {
            //                _imageView.image = nil;
            if (_photo.picMessage.thumbnailImgPath.length > 0) {
                _imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:_photo.picMessage.thumbnailImgPath]];
                _photo.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:_photo.picMessage.thumbnailImgPath]];
                [self adjustFrame];
            }
            __weak AXPhotoView *mySelf = self;
            __unsafe_unretained AXPhoto *blockPhoto = _photo;
            [self.downloader dowloadIMGWithImgURL:[self componentUrl:_photo.picMessage.imgUrl] identify:_photo.picMessage.identifier successBlock:^(BrokerResponder *response) {
                if (response.statusCode == 2) {
                    if (blockPhoto && mySelf && [blockPhoto.picMessage.identifier isEqualToString:response.identify]) {
                        UIImage *image = [UIImage imageWithContentsOfFile:response.imgPath];
                        blockPhoto.image = image;
                        [mySelf.imageView setImage:image];
                        [MBProgressHUD hideAllHUDsForView:mySelf animated:YES];
                        [mySelf adjustFrame];
                        NSString *imgName = [NSString stringWithFormat:@"%@%dx%d.jpg",blockPhoto.picMessage.identifier, (int)image.size.height, (int)image.size.width];
                        NSString *imgpath = [AXPhotoManager saveImageFile:image toFolder:AXPhotoFolderName whitChatId:mySelf.photo.picMessage.to andIMGName:imgName];
                        blockPhoto.picMessage.imgPath = imgpath;
                        [[AXChatMessageCenter defaultMessageCenter] updateMessage:blockPhoto.picMessage];
                    }else {
                        
                        [MBProgressHUD hideAllHUDsForView:mySelf animated:YES];
                        return ;
                    }
                }
            } fialedBlock:^(BrokerResponder *response) {
                
            }];
            
//            [self.imgDownloader dowloadIMGWithURL:[NSURL URLWithString:[self componentUrl:_photo.picMessage.imgUrl]] resultBlock:^(RTNetworkResponse * response) {
//                if (response.status == 2) {
//                    if (response.content && [response.content objectForKey:@"imagePath"]) {
//                        if (blockPhoto && mySelf) {
//                            UIImage *image = [UIImage imageWithContentsOfFile:[response.content objectForKey:@"imagePath"]];
//                            blockPhoto.image = image;
//                            [mySelf.imageView setImage:image];
//                            [MBProgressHUD hideAllHUDsForView:mySelf animated:YES];
//                            [mySelf adjustFrame];
//                            NSString *imgName = [NSString stringWithFormat:@"%@%dx%d.jpg",blockPhoto.picMessage.identifier, (int)image.size.height, (int)image.size.width];
//                            NSString *imgpath = [AXPhotoManager saveImageFile:image toFolder:AXPhotoFolderName whitChatId:mySelf.photo.picMessage.to andIMGName:imgName];
//                            blockPhoto.picMessage.imgPath = imgpath;
//                            
//                        }else {
//                            [MBProgressHUD hideAllHUDsForView:mySelf animated:YES];
//                            return ;
//                        }
//                        [[AXChatMessageCenter defaultMessageCenter] updateMessage:blockPhoto.picMessage];
//                    }
//                }
//            }];
        }
        
    } else {
        [self photoStartLoad];
    }
}

#pragma mark 开始加载图片
- (void)photoStartLoad
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.labelText = @"加载中…";
    if (_photo.picMessage.imgPath.length > 0) {
        
        _photo.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[self fixedImgPath:_photo.picMessage.imgPath]]];
        _imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[self fixedImgPath:_photo.picMessage.imgPath]]];
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
        [self adjustFrame];
    } else {
        if (_photo.picMessage.thumbnailImgPath.length > 0) {
            _imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:_photo.picMessage.thumbnailImgPath]];
            _photo.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:_photo.picMessage.thumbnailImgPath]];
            [self adjustFrame];
        }
        __weak AXPhotoView *mySelf = self;
        __unsafe_unretained AXPhoto *blockPhoto = _photo;
        [self.downloader dowloadIMGWithImgURL:[self componentUrl:_photo.picMessage.imgUrl] identify:_photo.picMessage.identifier successBlock:^(BrokerResponder *response) {
            if (response.statusCode == 2) {
                if (blockPhoto && mySelf && [blockPhoto.picMessage.identifier isEqualToString:response.identify]) {
                    UIImage *image = [UIImage imageWithContentsOfFile:response.imgPath];
                    blockPhoto.image = image;
                    [mySelf.imageView setImage:image];
                    [MBProgressHUD hideAllHUDsForView:mySelf animated:YES];
                    [mySelf adjustFrame];
                    NSString *imgName = [NSString stringWithFormat:@"%@%dx%d.jpg",blockPhoto.picMessage.identifier, (int)image.size.height, (int)image.size.width];
                    NSString *imgpath = [AXPhotoManager saveImageFile:image toFolder:AXPhotoFolderName whitChatId:mySelf.photo.picMessage.to andIMGName:imgName];
                    blockPhoto.picMessage.imgPath = imgpath;
                    [[AXChatMessageCenter defaultMessageCenter] updateMessage:blockPhoto.picMessage];
                }else {
                    [MBProgressHUD hideAllHUDsForView:mySelf animated:YES];
                    return ;
                }
                
            }
            
            
        } fialedBlock:^(BrokerResponder *response) {
            
        }];
//        [self.imgDownloader dowloadIMGWithURL:[NSURL URLWithString:[self componentUrl:_photo.picMessage.imgUrl]] resultBlock:^(RTNetworkResponse * response) {
//            if (response.status == 2) {
//                if (response.content && [response.content objectForKey:@"imagePath"]) {
//                    if (blockPhoto && mySelf) {
//                        UIImage *image = [UIImage imageWithContentsOfFile:[response.content objectForKey:@"imagePath"]];
//                        blockPhoto.image = image;
//                        [mySelf.imageView setImage:image];
//                        [MBProgressHUD hideAllHUDsForView:mySelf animated:YES];
//                        [mySelf adjustFrame];
//                        NSString *imgName = [NSString stringWithFormat:@"%@%dx%d.jpg",blockPhoto.picMessage.identifier, (int)image.size.height, (int)image.size.width];
//                        NSString *imgpath = [AXPhotoManager saveImageFile:image toFolder:AXPhotoFolderName whitChatId:mySelf.photo.picMessage.to andIMGName:imgName];
//                        blockPhoto.picMessage.imgPath = imgpath;
//                        
//                    }else {
//                        [MBProgressHUD hideAllHUDsForView:mySelf animated:YES];
//                        return ;
//                    }
//                    [[AXChatMessageCenter defaultMessageCenter] updateMessage:blockPhoto.picMessage];
//                }
//            }
//        }];
    }
    //     [self adjustFrame];
}

#pragma mark 调整frame
- (void)adjustFrame
{
    
    _imageView.image = _photo.image;
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
        
        [UIView animateWithDuration:0.0f animations:^{
            _imageView.frame = imageFrame;
        } completion:^(BOOL finished) {
            // 设置底部的小图片
            //            _photo.srcImageView.image = _photo.placeholder;
            [self photoStartLoad];
        }];
    } else {
        _imageView.frame = imageFrame;
    }
    //    [MBProgressHUD hideAllHUDsForView:self animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return _imageView;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [_imageView setCenter:CGPointMake(scrollView.frame.size.width / 2, scrollView.frame.size.height / 2)];
}
#pragma mark - 手势处理
- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    _doubleTap = NO;
    if ([self.photoViewDelegate respondsToSelector:@selector(photoViewDidEndZoom:)]) {
        [self.photoViewDelegate photoViewDidEndZoom:self];
    }
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

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage {
    [_imageView setImageUrl:url.absoluteString];
//    [_imageView setImageWithURL:url placeholderImage:placeholderImage];
}

- (NSString *)componentUrl:(NSString *)path {
    NSString *sizeStr = [path stringByReplacingOccurrencesOfString:@"100x100.jpg" withString:@"800x800.jpg"];
    return sizeStr;
}

@end