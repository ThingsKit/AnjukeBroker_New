//
//  PublishBigImageViewController.h
//  AnjukeBroker_New
//
//  Created by paper on 14-1-26.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RTViewController.h"
@class PublishBigImageViewController;
@protocol PublishBigImageViewClickDelegate <NSObject>
@optional
- (void)viewDidFinishWithImageArr:(NSArray *)imageArray;
- (void)viewDidFinishWithImageArr:(NSArray *)imageArray sender:(PublishBigImageViewController *)sender;
- (void)onlineHouseTypeImgDelete;

- (void)editPropertyDidDeleteImgWithDeleteIndex:(int)deleteIndex;
- (void)viewDidFinishWithImageNewArr:(NSArray *)imageNewArray;
@end

@interface PublishBigImageViewController : RTViewController <UIScrollViewDelegate, UIAlertViewDelegate>

@property (nonatomic, assign) id <PublishBigImageViewClickDelegate> clickDelegate;

@property BOOL isEditProperty; //是否是编辑房源，是则单张显示编辑图片，点击删除返回
@property int editDeleteImgIndex; //删除房源对应的index，便于通知
@property BOOL isNewAddImg; //编辑房源是否是新添加图片

- (void)showImagesWithNewArray:(NSArray *)imageNewArr atIndex:(int)index;
- (void)showImagesWithArray:(NSArray *)imageArr atIndex:(int)index;
- (void)showImagesForOnlineHouseTypeWithDic:(NSDictionary *)dic;

@end
