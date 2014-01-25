//
//  PhotoFooterView.h
//  AnjukeBroker_New
//
//  Created by paper on 14-1-24.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PF_EMPTY_IMAGE_HEIGHT 80

@protocol ImageClickDelegate <NSObject>

- (void)imageDidClickWithIndex:(int)index;
- (void)addImageDidClick;

- (void)drawFinishedWithCurrentHeight:(CGFloat)height; //重绘结束后返回当前页面的高度

@end

@interface PhotoFooterView : UIView

@property (nonatomic, assign) id <ImageClickDelegate>clickDelegate;
@property (nonatomic, strong) UIButton *emptyImgBtn;
@property BOOL isHouseType; //是室内图还是房型图

- (void)redrawWithImageArray:(NSArray *)imageArr;

@end
