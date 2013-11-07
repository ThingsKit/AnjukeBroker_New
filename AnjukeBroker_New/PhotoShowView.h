//
//  PhotoShowView.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-7.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PHOTO_SHOW_VIEW_H 140

@protocol PhotoViewClickDelegate <NSObject>

- (void)takePhoto_Click; //拍照按钮点击
- (void)closePicker_Click_WithImgArr:(NSMutableArray *)arr; //关闭按钮点击
//- (void)photoImg_ClickWithIndex:(int)index; //预览图点击（删除）

@end

@interface PhotoShowView : UIView

@property (nonatomic, assign) id <PhotoViewClickDelegate> clickDelegate;
@property (nonatomic, strong) NSMutableArray *imgArray;
@end
