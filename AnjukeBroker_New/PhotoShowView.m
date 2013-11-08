//
//  PhotoShowView.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-7.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "PhotoShowView.h"
#import "Util_UI.h"
#import "PhotoButton.h"

#define TAG_PHOTO_BASE 9990

#define PHOTO_BTN_H 50                              //拍照按钮高
#define PHOTO_SV_H PHOTO_SHOW_VIEW_H - PHOTO_BTN_H  //拍照scrollView高
#define IMG_GAP 5                                   //预览图间距
#define IMG_H PHOTO_SV_H -IMG_GAP*2

@implementation PhotoShowView
@synthesize clickDelegate;
@synthesize photoSV;
@synthesize imgBtnArr;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = SYSTEM_BLACK;//[UIColor whiteColor];
        
        [self initModel];
        [self initDisplayWithFrame:frame];
        
     }
    return self;
}

- (void)initModel {
    self.imgArray = [NSMutableArray array];
    self.imgBtnArr = [NSMutableArray array];
}

- (void)initDisplayWithFrame:(CGRect)frame {
    CGFloat BtnW = 100;
    
    //Image Scroll View
    //photo sv
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, PHOTO_SV_H)];
    self.photoSV = sv;
    sv.backgroundColor = [UIColor clearColor];
    [self addSubview:sv];
    
    //bottom BG
    UIView *bottomBG = [[UIView alloc] initWithFrame:CGRectMake(0, sv.frame.origin.y + sv.frame.size.height, frame.size.width, PHOTO_BTN_H)];
    bottomBG.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
    [self addSubview:bottomBG];
    
    UIButton *takeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    takeBtn.frame = CGRectMake(10+100, 0, BtnW, PHOTO_BTN_H);
    takeBtn.backgroundColor = [UIColor clearColor];
//    takeBtn.layer.borderColor = SYSTEM_BLACK.CGColor;
//    takeBtn.layer.borderWidth = 1;
//    [takeBtn setTitle:@"拍照" forState:UIControlStateNormal];
//    [takeBtn setTitleColor:SYSTEM_BLUE forState:UIControlStateNormal];
//    [takeBtn setBackgroundImage:[UIImage imageNamed:@"anjuke_icon_takephoto.png"] forState:UIControlStateNormal];
    [takeBtn addTarget:self action:@selector(take_Picture:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBG addSubview:takeBtn];
    
    CGFloat iconH = 98/2;
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"anjuke_icon_takephoto.png"]];
    icon.backgroundColor = [UIColor clearColor];
    icon.frame = CGRectMake((takeBtn.frame.size.width - iconH)/2, (takeBtn.frame.size.height - iconH)/2, iconH, iconH);
    [icon setUserInteractionEnabled:YES];
    [takeBtn addSubview:icon];
    
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    exitBtn.frame = CGRectMake(takeBtn.frame.origin.x + BtnW+10, takeBtn.frame.origin.y, BtnW, PHOTO_BTN_H);
    exitBtn.backgroundColor = [UIColor clearColor];
//    exitBtn.layer.borderColor = SYSTEM_BLACK.CGColor;
//    exitBtn.layer.borderWidth = 1;
    [exitBtn setTitle:@"完成" forState:UIControlStateNormal];
    [exitBtn setTitleColor:SYSTEM_ORANGE forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(closePicker:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBG addSubview:exitBtn];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//add pre img
- (void)takePhotoWithImage:(UIImage *)image {
    [self.imgArray addObject:image];
    
    int index = self.imgArray.count -1; //增加到第几个预览图，便于设置frame及contentSize
    
    PhotoButton *pBtn = [[PhotoButton alloc] initWithFrame:CGRectMake(IMG_GAP +(IMG_GAP +IMG_H)*index, IMG_GAP, IMG_H, IMG_H)];
    [pBtn addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
    pBtn.tag = TAG_PHOTO_BASE + index;
    pBtn.photoImg.image = image;
//    pBtn.layer.borderColor = [UIColor whiteColor].CGColor;
//    pBtn.layer.borderWidth = 0.5;
    [self.photoSV addSubview:pBtn];
    
    [self.imgBtnArr addObject:pBtn];
    
    self.photoSV.contentSize = CGSizeMake(IMG_GAP + (IMG_GAP +IMG_H)*self.imgArray.count, PHOTO_SV_H);
    if (self.imgArray.count >3) {
        [self.photoSV setContentOffset:CGPointMake((IMG_GAP + IMG_H)*(index-3), 0) animated:YES];
    }
}

- (void)take_Picture:(id)sender {
    if (![self canTakePhoto]) {
        DLog(@"已到最大预览数!");
        return;
    }
    self.currentImgCount ++;
    
    if ([self.clickDelegate respondsToSelector:@selector(takePhoto_Click)]) {
        [self.clickDelegate takePhoto_Click];
    }
}

- (void)closePicker:(id)sender {
    if ([self.clickDelegate respondsToSelector:@selector(closePicker_Click_WithImgArr:)]) {
        [self.clickDelegate closePicker_Click_WithImgArr:self.imgArray];
    }
}

- (void)deletePhoto:(id)sender {
    self.currentImgCount --;
    PhotoButton *pBtn = (PhotoButton *)sender;
    int index = pBtn.tag - TAG_PHOTO_BASE;
    
    DLog(@"click index [%d]", index);
    BOOL isLast = NO;
    if (index == self.imgArray.count -1) {
        isLast = YES; //如果不是最后一个预览图，则其他预览控件迁移
    }
    
    self.userInteractionEnabled = NO;
    
    //删除当前预览图及图片数组中，对应的图片，重置预览图之后的控件的frame及tag
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void){
                         pBtn.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             [pBtn removeFromSuperview];
                             DLog(@"[%d] [%d] [%d]", self.imgArray.count, self.imgBtnArr.count, index);
                             
                             [self.imgBtnArr removeObjectAtIndex:index];
                             [self.imgArray removeObjectAtIndex:index];
                             
                             self.photoSV.contentSize = CGSizeMake(IMG_GAP + (IMG_GAP +IMG_H)*self.imgArray.count, PHOTO_SV_H);
                            
                             //其他预览图前移
                             if (!isLast) {
                                 int removeCount = self.imgArray.count - index; //得到需要移动的预览图个数
                                 DLog(@"remove count [%d]", removeCount);
                                 
                                 for (int i = 0; i < removeCount; i ++) {
                                     DLog(@"remove index [%d]", index+i);
                                     
                                     PhotoButton *pb = (PhotoButton *)[self.imgBtnArr objectAtIndex:index+i];
                                     CGRect lastFrame = pb.frame;
                                     [UIView animateWithDuration:0.2 delay:0
                                                         options:UIViewAnimationOptionCurveEaseInOut
                                                      animations:^(void){
                                                          pb.frame = CGRectMake(lastFrame.origin.x - (IMG_GAP + IMG_H), lastFrame.origin.y, lastFrame.size.width, lastFrame.size.height);
                                                      }
                                                      completion:^(BOOL finished) {
                                                          if (finished) {
                                                              pb.tag = TAG_PHOTO_BASE + i;
                                                          }
                                                      }];
                                 }
                             }
                         }
                     }];
    self.userInteractionEnabled = YES;
}

- (BOOL)canTakePhoto {
    if (self.currentImgCount >= self.maxImgCount) {
        return NO;
    }
    
    return YES;
}

@end
