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
@property (nonatomic, strong) UIScrollView *photoSV;
@property (nonatomic, strong) NSMutableArray *imgBtnArr;
@property int maxImgCount; //外部传递的最大图片数
@property int currentImgCount; //外部已有的图片数，用以和自身的imgArray.count想加比较是否可继续拍照

- (void)takePhotoWithImage:(UIImage *)image; //外部拍照后传递预览图，用以此编辑框显示预览图
@end
