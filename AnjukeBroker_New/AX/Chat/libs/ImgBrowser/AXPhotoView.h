//
//  MJZoomingScrollView.h
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

@class AXPhotoBrowser, AXPhoto, AXPhotoView;

@protocol AXPhotoViewDelegate <NSObject>
- (void)photoViewImageFinishLoad:(AXPhotoView *)photoView;
- (void)photoViewSingleTap:(AXPhotoView *)photoView;
- (void)photoViewDidEndZoom:(AXPhotoView *)photoView;
@end

@interface AXPhotoView : UIScrollView <UIScrollViewDelegate>
@property (nonatomic, strong) AXPhoto *photo;
@property (nonatomic, weak) id<AXPhotoViewDelegate> photoViewDelegate;
@property BOOL isFirstIMG;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage;
@end