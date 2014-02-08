//
//  PhotoFooterView.m
//  AnjukeBroker_New
//
//  Created by paper on 14-1-24.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PhotoFooterView.h"
#import "PhotoButton.h"
#import "Util_UI.h"

@implementation PhotoFooterView
@synthesize clickDelegate;
@synthesize emptyImgBtn;
@synthesize isHouseType;
@synthesize imageBtnArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        self.imageBtnArray = [NSMutableArray array];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)redrawWithImageArray:(NSArray *)imageArr {
    CGFloat height = 0;
    CGRect frame = self.frame;
    
    if (imageArr.count == 0) {
        [self cleanImageShow]; //一定要先清空老图片数据显示
        
        //空白view
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, PF_EMPTY_IMAGE_HEIGHT);
        
        if (!self.emptyImgBtn) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            btn.backgroundColor = [UIColor clearColor];
            self.emptyImgBtn = btn;
            [btn addTarget:self action:@selector(emptyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//            [self addSubview:btn];
            
            UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"anjuke_icon_photo_add.png"]];
            icon.frame = CGRectMake((btn.frame.size.width - 80/2)/2, 10, 80/2, 60/2);
            [btn addSubview:icon];
            
            CGFloat titleW = 120;
            UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake((btn.frame.size.width - titleW)/2, icon.frame.origin.y+ icon.frame.size.height + 10, titleW, 20)];
            titleLb.text = @"添加室内图";
            if (self.isHouseType) {
                titleLb.text = @"添加户型图";
            }
            titleLb.textColor = SYSTEM_LIGHT_GRAY;
            titleLb.textAlignment = NSTextAlignmentCenter;
            titleLb.font = [UIFont systemFontOfSize:12];
            [btn addSubview:titleLb];
            
            [self addSubview:btn];
        }
        
        [self addSubview:self.emptyImgBtn];
    }
    else { //图片排列，添加btn+预览btn
        if (self.emptyImgBtn) {
            [self.emptyImgBtn removeFromSuperview];
        }
        
        [self cleanImageShow]; //一定要先清空老图片数据显示
        
        int verticalRow = 0; //数列数量，至少一列
        if (imageArr.count <= 3) {
            verticalRow = 1; //一行
        }
        else if (imageArr.count >= 4 && imageArr.count <= 7){
            verticalRow = 2; //2行
        }
        else {
            verticalRow = 3; //3行
        }
        
        //3*4双循环
        for (int j = 0; j < verticalRow; j ++) {
            for (int i = 0; i < 4; i ++) {
                
                int all_imageIndex = j*4+i; //在3*4的矩阵中，换算的图片index（添加按钮+1）
                if (all_imageIndex > imageArr.count) {
                    break; //数组越界前跳出双循环
                }
                
                PhotoButton *pBtn = [[PhotoButton alloc] initWithFrame:CGRectMake(5+PF_IMAGE_GAP_X +(PF_IMAGE_GAP_X + PF_IMAGE_WIDTH)*i, PF_IMAGE_GAP_Y + (PF_IMAGE_GAP_Y + PF_IMAGE_WIDTH)*j, PF_IMAGE_WIDTH, PF_IMAGE_WIDTH)];
                pBtn.tag = all_imageIndex;
//                DLog(@"index------[%d]", pBtn.tag);
                if (all_imageIndex == 0) {
                    pBtn.photoImg.image = [UIImage imageNamed:@"anjuke_icon_nextphoto_.png"];
                }
                else {
                    NSString *url = nil;
                    url =  [imageArr objectAtIndex:all_imageIndex - 1]; //去除第一个添加按钮
                    pBtn.photoImg.image = [UIImage imageWithContentsOfFile:url];
                }
                [pBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:pBtn];
                
                [self.imageBtnArray addObject:pBtn];
            }
        }
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, PF_IMAGE_GAP_Y + (PF_IMAGE_GAP_Y + PF_IMAGE_WIDTH)*verticalRow);
    }
    
    height = self.frame.size.height;
    DLog(@"new photo Height %f", height);
    
    //将当前的新高度回调给superView
    if ([self.clickDelegate respondsToSelector:@selector(drawFinishedWithCurrentHeight:)]) {
        [self.clickDelegate drawFinishedWithCurrentHeight:height];
    }
}

- (void)redrawWithHouseTypeImageArray:(NSArray *)imageArr andImgUrl:(NSArray *)urlImgArr {
    CGFloat height = 0;
    CGRect frame = self.frame;
    
    int wholeCount = imageArr.count + urlImgArr.count +1;
    
    if (wholeCount == 1) {
        [self cleanImageShow]; //一定要先清空老图片数据显示
        
        //空白view
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, PF_EMPTY_IMAGE_HEIGHT);
        
        if (!self.emptyImgBtn) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            btn.backgroundColor = [UIColor clearColor];
            self.emptyImgBtn = btn;
            [btn addTarget:self action:@selector(emptyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//            [self addSubview:btn];
            
            UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"anjuke_icon_fxt_.png"]];
            icon.frame = CGRectMake((btn.frame.size.width - 80/2)/2, 10, 80/2, 60/2);
            [btn addSubview:icon];
            
            CGFloat titleW = 120;
            UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake((btn.frame.size.width - titleW)/2, icon.frame.origin.y+ icon.frame.size.height + 10, titleW, 20)];
            titleLb.text = @"添加户型图";
            titleLb.textColor = SYSTEM_LIGHT_GRAY;
            titleLb.textAlignment = NSTextAlignmentCenter;
            titleLb.font = [UIFont systemFontOfSize:12];
            [btn addSubview:titleLb];
            
            [self addSubview:btn];
        }
        
        [self addSubview:self.emptyImgBtn];
    }
    else { //图片排列，添加btn+预览btn
        if (self.emptyImgBtn) {
            [self.emptyImgBtn removeFromSuperview];
        }
        
        [self cleanImageShow]; //一定要先清空老图片数据显示
        
        int verticalRow = 0; //数列数量，至少一列
        if (wholeCount <= 3) {
            verticalRow = 1; //一行
        }
        else if (wholeCount >= 4 && wholeCount <= 7){
            verticalRow = 2; //2行
        }
        else {
            verticalRow = 3; //3行
        }
        
        //3*4双循环
        for (int j = 0; j < verticalRow; j ++) {
            for (int i = 0; i < 4; i ++) {
                
                int all_imageIndex = j*4+i; //在3*4的矩阵中，换算的图片index（添加按钮+1）
                
                if (all_imageIndex >= wholeCount) {
                    break; //数组越界前跳出双循环
                }
                
                PhotoButton *pBtn = [[PhotoButton alloc] initWithFrame:CGRectMake(5+PF_IMAGE_GAP_X +(PF_IMAGE_GAP_X + PF_IMAGE_WIDTH)*i, PF_IMAGE_GAP_Y + (PF_IMAGE_GAP_Y + PF_IMAGE_WIDTH)*j, PF_IMAGE_WIDTH, PF_IMAGE_WIDTH)];
                pBtn.tag = all_imageIndex;
                DLog(@"index------[%d]", pBtn.tag);
                if (all_imageIndex == 0) {
                    pBtn.photoImg.image = [UIImage imageNamed:@"anjuke_icon_nextfxt_.png"];
                }
                else if (all_imageIndex -1 < (int)(imageArr.count)) {
                    NSString *url = nil;
                    url =  [imageArr objectAtIndex:all_imageIndex - 1]; //去除第一个添加按钮
                    pBtn.photoImg.image = [UIImage imageWithContentsOfFile:url];
                }
                else {
                    pBtn.photoImg.imageUrl = [urlImgArr objectAtIndex:0];
                }
                [pBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:pBtn];
                
                [self.imageBtnArray addObject:pBtn];
            }
        }
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, PF_IMAGE_GAP_Y + (PF_IMAGE_GAP_Y + PF_IMAGE_WIDTH)*verticalRow);
    }
    
    height = self.frame.size.height;
    DLog(@"new photo Height %f", height);
    
    //将当前的新高度回调给superView
    if ([self.clickDelegate respondsToSelector:@selector(drawFinishedWithCurrentHeight:)]) {
        [self.clickDelegate drawFinishedWithCurrentHeight:height];
    }
}

- (void)redrawWithEditRoomImageArray:(NSArray *)imageArr andImgUrl:(NSArray *)urlImgArr {
    CGFloat height = 0;
    CGRect frame = self.frame;
    
    int wholeCount = imageArr.count + urlImgArr.count +1;
    
    if (wholeCount == 1) {
        [self cleanImageShow]; //一定要先清空老图片数据显示
        
        //空白view
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, PF_EMPTY_IMAGE_HEIGHT);
        
        if (!self.emptyImgBtn) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            btn.backgroundColor = [UIColor clearColor];
            self.emptyImgBtn = btn;
            [btn addTarget:self action:@selector(emptyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            //            [self addSubview:btn];
            
            UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"anjuke_icon_photo_add.png"]];
            icon.frame = CGRectMake((btn.frame.size.width - 80/2)/2, 10, 80/2, 60/2);
            [btn addSubview:icon];
            
            CGFloat titleW = 120;
            UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake((btn.frame.size.width - titleW)/2, icon.frame.origin.y+ icon.frame.size.height + 10, titleW, 20)];
            titleLb.text = @"添加户型图";
            titleLb.textColor = SYSTEM_LIGHT_GRAY;
            titleLb.textAlignment = NSTextAlignmentCenter;
            titleLb.font = [UIFont systemFontOfSize:12];
            [btn addSubview:titleLb];
            
            [self addSubview:btn];
        }
        
        [self addSubview:self.emptyImgBtn];
    }
    else { //图片排列，添加btn+预览btn
        if (self.emptyImgBtn) {
            [self.emptyImgBtn removeFromSuperview];
        }
        
        [self cleanImageShow]; //一定要先清空老图片数据显示
        
        int verticalRow = 0; //数列数量，至少一列
        if (wholeCount <= 3) {
            verticalRow = 1; //一行
        }
        else if (wholeCount >= 4 && wholeCount <= 7){
            verticalRow = 2; //2行
        }
        else {
            verticalRow = 3; //3行
        }
        
        //3*4双循环
        for (int j = 0; j < verticalRow; j ++) {
            for (int i = 0; i < 4; i ++) {
                
                int all_imageIndex = j*4+i; //在3*4的矩阵中，换算的图片index（添加按钮+1）
                
                if (all_imageIndex >= wholeCount) {
                    break; //数组越界前跳出双循环
                }
                
                PhotoButton *pBtn = [[PhotoButton alloc] initWithFrame:CGRectMake(5+PF_IMAGE_GAP_X +(PF_IMAGE_GAP_X + PF_IMAGE_WIDTH)*i, PF_IMAGE_GAP_Y + (PF_IMAGE_GAP_Y + PF_IMAGE_WIDTH)*j, PF_IMAGE_WIDTH, PF_IMAGE_WIDTH)];
                pBtn.tag = all_imageIndex;
                
                DLog(@"index------[%d]", pBtn.tag);
                
                if (all_imageIndex == 0) { //添加按钮
                    pBtn.photoImg.image = [UIImage imageNamed:@"anjuke_icon_nextphoto_.png"];
                }
                else if (all_imageIndex -1 < (int)(urlImgArr.count)) {
                    pBtn.photoImg.imageUrl = [urlImgArr objectAtIndex:all_imageIndex - 1];
                }
                else {
                    NSString *url = nil;
                    url =  [imageArr objectAtIndex:all_imageIndex- 1 - urlImgArr.count]; //去除第一个添加按钮
                    pBtn.photoImg.image = [UIImage imageWithContentsOfFile:url];
                }
                [pBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:pBtn];
                
                [self.imageBtnArray addObject:pBtn];
            }
        }
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, PF_IMAGE_GAP_Y + (PF_IMAGE_GAP_Y + PF_IMAGE_WIDTH)*verticalRow);
    }
    
    height = self.frame.size.height;
    DLog(@"new photo Height %f", height);
    
    //将当前的新高度回调给superView
    if ([self.clickDelegate respondsToSelector:@selector(drawFinishedWithCurrentHeight:)]) {
        [self.clickDelegate drawFinishedWithCurrentHeight:height];
    }
}

- (void)redrawWithEditHouseTypeShowedImageArray:(NSArray *)showedImageArr andAddImgArr:(NSArray *)addImgArr andOnlineHouseTypeArr:(NSArray *)onlineHouseTypeArr {
    CGFloat height = 0;
    CGRect frame = self.frame;
    
    int wholeCount = showedImageArr.count + addImgArr.count + onlineHouseTypeArr.count +1;
    
    if (wholeCount == 1) {
        [self cleanImageShow]; //一定要先清空老图片数据显示
        
        //空白view
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, PF_EMPTY_IMAGE_HEIGHT);
        
        if (!self.emptyImgBtn) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            btn.backgroundColor = [UIColor clearColor];
            self.emptyImgBtn = btn;
            [btn addTarget:self action:@selector(emptyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            //            [self addSubview:btn];
            
            UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"anjuke_icon_fxt_.png"]];
            icon.frame = CGRectMake((btn.frame.size.width - 80/2)/2, 10, 80/2, 60/2);
            [btn addSubview:icon];
            
            CGFloat titleW = 120;
            UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake((btn.frame.size.width - titleW)/2, icon.frame.origin.y+ icon.frame.size.height + 10, titleW, 20)];
            titleLb.text = @"添加户型图";
            titleLb.textColor = SYSTEM_LIGHT_GRAY;
            titleLb.textAlignment = NSTextAlignmentCenter;
            titleLb.font = [UIFont systemFontOfSize:12];
            [btn addSubview:titleLb];
            
            [self addSubview:btn];
        }
        
        [self addSubview:self.emptyImgBtn];
    }
    else { //图片排列，添加btn+预览btn
        if (self.emptyImgBtn) {
            [self.emptyImgBtn removeFromSuperview];
        }
        
        [self cleanImageShow]; //一定要先清空老图片数据显示
        
        int verticalRow = 0; //数列数量，至少一列
        if (wholeCount <= 3) {
            verticalRow = 1; //一行
        }
        else if (wholeCount >= 4 && wholeCount <= 7){
            verticalRow = 2; //2行
        }
        else {
            verticalRow = 3; //3行
        }
        
        //3*4双循环
        for (int j = 0; j < verticalRow; j ++) {
            for (int i = 0; i < 4; i ++) {
                
                int all_imageIndex = j*4+i; //在3*4的矩阵中，换算的图片index（添加按钮+1）
                
                if (all_imageIndex >= wholeCount) {
                    break; //数组越界前跳出双循环
                }
                
                PhotoButton *pBtn = [[PhotoButton alloc] initWithFrame:CGRectMake(5+PF_IMAGE_GAP_X +(PF_IMAGE_GAP_X + PF_IMAGE_WIDTH)*i, PF_IMAGE_GAP_Y + (PF_IMAGE_GAP_Y + PF_IMAGE_WIDTH)*j, PF_IMAGE_WIDTH, PF_IMAGE_WIDTH)];
                pBtn.tag = all_imageIndex;
                DLog(@"index------[%d]", pBtn.tag);
                
                if (all_imageIndex == 0) {
                    pBtn.photoImg.image = [UIImage imageNamed:@"anjuke_icon_nextfxt_.png"];
                }
                else if (all_imageIndex -1 < (int)(showedImageArr.count)) { //已有的户型图
                    NSString *url = nil;
                    url =  [showedImageArr objectAtIndex:all_imageIndex - 1]; //去除第一个添加按钮
                    pBtn.photoImg.imageUrl = url;
                }
                else if (all_imageIndex -1 >= showedImageArr.count && all_imageIndex - 1 < showedImageArr.count + addImgArr.count) {
                    NSString *url = nil;
                    url =  [addImgArr objectAtIndex:all_imageIndex - 1- showedImageArr.count]; //去除第一个添加按钮
                    pBtn.photoImg.image = [UIImage imageWithContentsOfFile:url];
                }
                else { //草泥马的在线户型图。。。
                    if (onlineHouseTypeArr.count > 0) {
                        pBtn.photoImg.imageUrl = [onlineHouseTypeArr objectAtIndex:0];
                    }
                }
                [pBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:pBtn];
                
                [self.imageBtnArray addObject:pBtn];
            }
        }
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, PF_IMAGE_GAP_Y + (PF_IMAGE_GAP_Y + PF_IMAGE_WIDTH)*verticalRow);
        
        DLog(@"new photo Height %d层高", verticalRow);
    }
    
    height = self.frame.size.height;
    DLog(@"new photo Height %f", height);
    
    //将当前的新高度回调给superView
    if ([self.clickDelegate respondsToSelector:@selector(drawFinishedWithCurrentHeight:)]) {
        [self.clickDelegate drawFinishedWithCurrentHeight:height];
    }
}

- (void)cleanImageShow {
    for (int i = 0; i < self.imageBtnArray.count; i ++) {
        [[self.imageBtnArray objectAtIndex:i] removeFromSuperview];
    }
    [self.imageBtnArray removeAllObjects];
}

//空白按钮点击添加
- (void)emptyBtnClick:(id)sender {
    //将添加按钮点击时间回调给superView
    if ([self.clickDelegate respondsToSelector:@selector(addImageDidClick)]) {
        [self.clickDelegate addImageDidClick];
    }
}

- (void)imageBtnClick:(id)sender {
    PhotoButton *pb = (PhotoButton *)sender;
    int index = pb.tag;
    
    if (index == 0) { //点击添加图片
        //将添加按钮点击时间回调给superView
        if ([self.clickDelegate respondsToSelector:@selector(addImageDidClick)]) {
            [self.clickDelegate addImageDidClick];
        }
    }
    else {
        //产看第几张图片通过数组index给到
        if ([self.clickDelegate respondsToSelector:@selector(imageDidClickWithIndex:)]) {
            [self.clickDelegate imageDidClickWithIndex:index -1];
        }
    }
}

@end
