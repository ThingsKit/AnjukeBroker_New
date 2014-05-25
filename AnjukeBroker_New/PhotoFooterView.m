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

@interface PhotoFooterView ()
{
}
@property (nonatomic, assign)NSInteger addActionTag;

@end

@implementation PhotoFooterView
@synthesize clickDelegate;
@synthesize emptyImgBtn;
@synthesize isHouseType;
@synthesize imageBtnArray;
@synthesize bottomLine, topLine;
@synthesize addActionTag = _addActionTag;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        self.imageBtnArray = [NSMutableArray array];
        
        self.topLine = [[BrokerLineView alloc] init];
        [self addSubview:self.topLine];
        self.bottomLine = [[BrokerLineView alloc] init];
        [self addSubview:self.bottomLine];
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
    
    int wholeCount = imageArr.count +1;
    
    if (imageArr.count == 0) {
        [self cleanImageShow]; //一定要先清空老图片数据显示
        
        //空白view
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, PF_EMPTY_IMAGE_HEIGHT);
        
        if (!self.emptyImgBtn)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            btn.backgroundColor = [UIColor clearColor];
            self.emptyImgBtn = btn;
            [btn addTarget:self action:@selector(emptyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            CGFloat titleW = 120;
            UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, titleW, 20)];
            titleLb.text = @"室内图";
            if (self.isHouseType) {
                titleLb.text = @"户型图";
            }
            [titleLb setTextAlignment:NSTextAlignmentLeft];
            titleLb.textColor = SYSTEM_LIGHT_GRAY;
            titleLb.font = [UIFont systemFontOfSize:20];
            [btn addSubview:titleLb];
            
            //cameraIcon
            CGFloat iconX = titleLb.frame.origin.x - 2;
            CGFloat iconY = titleLb.frame.origin.y + titleLb.frame.size.height + 10;
            
            UIImage *craIconImg = [UIImage imageNamed:@"anjuke_icon_add_pic"];
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, iconY, craIconImg.size.width, craIconImg.size.height)];
            [icon setImage:craIconImg];
            [icon setTag:-1];//为了点击换图片
            [btn addSubview:icon];
            
            [self addSubview:btn];
        }
        
        [self addSubview:self.emptyImgBtn];
    }
    else { //图片排列，添加btn+预览btn
        if (self.emptyImgBtn) {
            [self.emptyImgBtn removeFromSuperview];
        }
        
        [self cleanImageShow]; //一定要先清空老图片数据显示
        
        int verticalRow = [self getVerticalRowNumberWithWholeCount:wholeCount];
        
        //3*4双循环
        for (int j = 0; j < verticalRow; j ++) {
            for (int i = 0; i < 4; i ++) {
                
//                int realIndex = j + i;
                
                int all_imageIndex = j*4+i; //在3*4的矩阵中，换算的图片index（添加按钮+1）
                if (all_imageIndex > imageArr.count) {
                    break; //数组越界前跳出双循环
                }
                
                PhotoButton *pBtn = [[PhotoButton alloc] initWithFrame:CGRectMake(
                                                                                  5+PF_IMAGE_GAP_X +(PF_IMAGE_GAP_X + PF_IMAGE_WIDTH)*i,
                                                                                  PF_IMAGE_GAP_Y + 35 + (PF_IMAGE_GAP_Y + PF_IMAGE_WIDTH)*j, PF_IMAGE_WIDTH,
                                                                                  PF_IMAGE_WIDTH)];
                pBtn.tag = all_imageIndex;
                DLog(@"index------[%d]", pBtn.tag);
                _addActionTag = imageArr.count;
                if (all_imageIndex == (imageArr.count)) {
                    pBtn.photoImg.image = [UIImage imageNamed:@"anjuke_icon_add_pic"];
                }
                else {
                    NSString *url = nil;
                    url =  [imageArr objectAtIndex:all_imageIndex]; //去除第一个添加按钮
                    pBtn.photoImg.image = [UIImage imageWithContentsOfFile:url];
                }
                [pBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:pBtn];
                
                [self.imageBtnArray addObject:pBtn];
            }
        }
        
        CGFloat titleW = 120;
        UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, titleW, 20)];
        titleLb.text = @"室内图";
        if (self.isHouseType) {
            titleLb.text = @"户型图";
        }
        [titleLb setTextAlignment:NSTextAlignmentLeft];
        titleLb.textColor = SYSTEM_LIGHT_GRAY;
        titleLb.font = [UIFont systemFontOfSize:20];
        [self addSubview:titleLb];
        
        CGFloat frameHeight = titleLb.frame.origin.y + CGRectGetHeight(titleLb.frame) + PF_IMAGE_GAP_Y + (PF_IMAGE_GAP_Y + PF_IMAGE_WIDTH)*verticalRow;
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frameHeight);
    }
    
    height = self.frame.size.height;
    DLog(@"new photo Height %f", height);
    
    //将当前的新高度回调给superView
    if ([self.clickDelegate respondsToSelector:@selector(drawFinishedWithCurrentHeight:)]) {
        [self.clickDelegate drawFinishedWithCurrentHeight:height];
    }
    [self resetLineWithHeight:height];
}

- (void)redrawWithHouseTypeImageArray:(NSArray *)imageArr andImgUrl:(NSArray *)urlImgArr {
    CGFloat height = 0;
    CGRect frame = self.frame;
    
    int wholeCount = imageArr.count + urlImgArr.count +1;
    
    if (wholeCount == 1) {
        [self cleanImageShow]; //一定要先清空老图片数据显示
        
        //空白view
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, PF_EMPTY_IMAGE_HEIGHT);
        
        if (!self.emptyImgBtn)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            btn.backgroundColor = [UIColor clearColor];
            self.emptyImgBtn = btn;
            [btn addTarget:self action:@selector(emptyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            CGFloat titleW = 120;
            UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, titleW, 20)];
            titleLb.text = @"室内图";
            if (self.isHouseType) {
                titleLb.text = @"户型图";
            }
            [titleLb setTextAlignment:NSTextAlignmentLeft];
            titleLb.textColor = SYSTEM_LIGHT_GRAY;
            titleLb.font = [UIFont systemFontOfSize:20];
            [btn addSubview:titleLb];
            
            //cameraIcon
            CGFloat iconX = titleLb.frame.origin.x - 2;
            CGFloat iconY = titleLb.frame.origin.y + titleLb.frame.size.height + 10;
            
            UIImage *craIconImg = [UIImage imageNamed:@"anjuke_icon_add_pic"];
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, iconY, craIconImg.size.width, craIconImg.size.height)];
            [icon setImage:craIconImg];
            [icon setTag:-1];//为了点击换图片
            [btn addSubview:icon];
            
            [self addSubview:btn];
        }
        
        [self addSubview:self.emptyImgBtn];
    }
    else { //图片排列，添加btn+预览btn
        if (self.emptyImgBtn) {
            [self.emptyImgBtn removeFromSuperview];
        }
        
        [self cleanImageShow]; //一定要先清空老图片数据显示
        
        int verticalRow = [self getVerticalRowNumberWithWholeCount:wholeCount];
        
        //3*4双循环
        for (int j = 0; j < verticalRow; j ++) {
            for (int i = 0; i < 4; i ++) {
                
                int all_imageIndex = j*4+i; //在3*4的矩阵中，换算的图片index（添加按钮+1）
                
                if (all_imageIndex >= wholeCount) {
                    break; //数组越界前跳出双循环
                }
                
                PhotoButton *pBtn = [[PhotoButton alloc] initWithFrame:CGRectMake(
                                                                                  5+PF_IMAGE_GAP_X +(PF_IMAGE_GAP_X + PF_IMAGE_WIDTH)*i,
                                                                                  PF_IMAGE_GAP_Y + 35 + (PF_IMAGE_GAP_Y + PF_IMAGE_WIDTH)*j, PF_IMAGE_WIDTH,
                                                                                  PF_IMAGE_WIDTH)];
                pBtn.tag = all_imageIndex;
                DLog(@"index------[%d]", pBtn.tag);
                _addActionTag = wholeCount - 1;
                if (all_imageIndex == _addActionTag) {
                    pBtn.photoImg.image = [UIImage imageNamed:@"anjuke_icon_add_pic"];
                }
                else if (all_imageIndex < (int)(imageArr.count)) {
                    NSString *url = nil;
                    url =  [imageArr objectAtIndex:all_imageIndex]; //去除第一个添加按钮
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
        
        CGFloat titleW = 120;
        UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, titleW, 20)];
        titleLb.text = @"室内图";
        if (self.isHouseType) {
            titleLb.text = @"户型图";
        }
        [titleLb setTextAlignment:NSTextAlignmentLeft];
        titleLb.textColor = SYSTEM_LIGHT_GRAY;
        titleLb.font = [UIFont systemFontOfSize:20];
        [self addSubview:titleLb];
        
        CGFloat frameHeight = titleLb.frame.origin.y + CGRectGetHeight(titleLb.frame) + PF_IMAGE_GAP_Y + (PF_IMAGE_GAP_Y + PF_IMAGE_WIDTH)*verticalRow;
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frameHeight);
    }
    
    height = self.frame.size.height;
    DLog(@"new photo Height %f", height);
    
    //将当前的新高度回调给superView
    if ([self.clickDelegate respondsToSelector:@selector(drawFinishedWithCurrentHeight:)]) {
        [self.clickDelegate drawFinishedWithCurrentHeight:height];
    }
    [self resetLineWithHeight:height];
}

- (void)redrawWithEditRoomImageArray:(NSArray *)imageArr andImgUrl:(NSArray *)urlImgArr {
    CGFloat height = 0;
    CGRect frame = self.frame;
    
    int wholeCount = imageArr.count + urlImgArr.count +1;
    
    if (wholeCount == 0) {
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
            
            CGFloat titleW = 120;
            UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, titleW, 20)];
            titleLb.text = @"室内图";
            if (self.isHouseType) {
                titleLb.text = @"户型图";
            }
            [titleLb setTextAlignment:NSTextAlignmentLeft];
            titleLb.textColor = SYSTEM_LIGHT_GRAY;
            titleLb.font = [UIFont systemFontOfSize:20];
            [btn addSubview:titleLb];
            
            //cameraIcon
            CGFloat iconX = titleLb.frame.origin.x - 2;
            CGFloat iconY = titleLb.frame.origin.y + titleLb.frame.size.height + 10;
            
            UIImage *craIconImg = [UIImage imageNamed:@"anjuke_icon_add_pic"];
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, iconY, craIconImg.size.width, craIconImg.size.height)];
            [icon setImage:craIconImg];
            [icon setTag:-1];//为了点击换图片
            [btn addSubview:icon];
            
            [self addSubview:btn];
        }
        
        [self addSubview:self.emptyImgBtn];
    }
    else { //图片排列，添加btn+预览btn
        if (self.emptyImgBtn) {
            [self.emptyImgBtn removeFromSuperview];
        }
        
        [self cleanImageShow]; //一定要先清空老图片数据显示
        
        int verticalRow = [self getVerticalRowNumberWithWholeCount:wholeCount];
        
        //3*4双循环
        for (int j = 0; j < verticalRow; j ++) {
            for (int i = 0; i < 4; i ++) {
                
                int all_imageIndex = j*4+i; //在3*4的矩阵中，换算的图片index（添加按钮+1）
                
                if (all_imageIndex >= wholeCount) {
                    break; //数组越界前跳出双循环
                }
                
                PhotoButton *pBtn = [[PhotoButton alloc] initWithFrame:CGRectMake(
                                                                                  5+PF_IMAGE_GAP_X +(PF_IMAGE_GAP_X + PF_IMAGE_WIDTH)*i,
                                                                                  PF_IMAGE_GAP_Y + 35 + (PF_IMAGE_GAP_Y + PF_IMAGE_WIDTH)*j,
                                                                                  PF_IMAGE_WIDTH,
                                                                                  PF_IMAGE_WIDTH)];
                pBtn.tag = all_imageIndex;
                
                DLog(@"index------[%d]", pBtn.tag);
                
                _addActionTag = imageArr.count + urlImgArr.count;
                if (all_imageIndex == (imageArr.count + urlImgArr.count)) {
                    pBtn.photoImg.image = [UIImage imageNamed:@"anjuke_icon_add_pic"];
                }
                else if (all_imageIndex < (int)(urlImgArr.count))
                {
                    pBtn.photoImg.imageUrl = [urlImgArr objectAtIndex:all_imageIndex];
                }
                else
                {
                    NSString *url = nil;
                    url =  [imageArr objectAtIndex:all_imageIndex - urlImgArr.count]; //去除第一个添加按钮
                    pBtn.photoImg.image = [UIImage imageWithContentsOfFile:url];
                }
                [pBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:pBtn];
                
                [self.imageBtnArray addObject:pBtn];
                
            }
        }
        
        CGFloat titleW = 120;
        UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, titleW, 20)];
        titleLb.text = @"室内图";
        if (self.isHouseType) {
            titleLb.text = @"户型图";
        }
        [titleLb setTextAlignment:NSTextAlignmentLeft];
        titleLb.textColor = SYSTEM_LIGHT_GRAY;
        titleLb.font = [UIFont systemFontOfSize:20];
        [self addSubview:titleLb];
        
        CGFloat frameHeight = titleLb.frame.origin.y + CGRectGetHeight(titleLb.frame) + PF_IMAGE_GAP_Y + (PF_IMAGE_GAP_Y + PF_IMAGE_WIDTH)*verticalRow;
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frameHeight);
    }
    
    height = self.frame.size.height;
    DLog(@"new photo Height %f", height);
    //将当前的新高度回调给superView
    if ([self.clickDelegate respondsToSelector:@selector(drawFinishedWithCurrentHeight:)]) {
        [self.clickDelegate drawFinishedWithCurrentHeight:height];
    }
    [self resetLineWithHeight:height];
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
            
            CGFloat titleW = 120;
            UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, titleW, 20)];
            titleLb.text = @"室内图";
            if (self.isHouseType) {
                titleLb.text = @"户型图";
            }
            [titleLb setTextAlignment:NSTextAlignmentLeft];
            titleLb.textColor = SYSTEM_LIGHT_GRAY;
            titleLb.font = [UIFont systemFontOfSize:20];
            [btn addSubview:titleLb];
            
            //cameraIcon
            CGFloat iconX = titleLb.frame.origin.x - 2;
            CGFloat iconY = titleLb.frame.origin.y + titleLb.frame.size.height + 10;
            
            UIImage *craIconImg = [UIImage imageNamed:@"anjuke_icon_add_pic"];
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, iconY, craIconImg.size.width, craIconImg.size.height)];
            [icon setImage:craIconImg];
            [icon setTag:-1];//为了点击换图片
            [btn addSubview:icon];
            
            [self addSubview:btn];
        }
        
        [self addSubview:self.emptyImgBtn];
    }
    else { //图片排列，添加btn+预览btn
        if (self.emptyImgBtn) {
            [self.emptyImgBtn removeFromSuperview];
        }
        
        [self cleanImageShow]; //一定要先清空老图片数据显示
        
        int verticalRow = [self getVerticalRowNumberWithWholeCount:wholeCount];
        
        //3*4双循环
        for (int j = 0; j < verticalRow; j ++) {
            for (int i = 0; i < 4; i ++) {
                
                int all_imageIndex = j*4+i; //在3*4的矩阵中，换算的图片index（添加按钮+1）
                
                if (all_imageIndex >= wholeCount) {
                    break; //数组越界前跳出双循环
                }
                
                PhotoButton *pBtn = [[PhotoButton alloc] initWithFrame:CGRectMake(5+PF_IMAGE_GAP_X +(PF_IMAGE_GAP_X + PF_IMAGE_WIDTH)*i, PF_IMAGE_GAP_Y + 35 + (PF_IMAGE_GAP_Y + PF_IMAGE_WIDTH)*j, PF_IMAGE_WIDTH, PF_IMAGE_WIDTH)];
                pBtn.tag = all_imageIndex;
                DLog(@"index------[%d]", pBtn.tag);
                _addActionTag = wholeCount - 1;
                if (all_imageIndex == (wholeCount - 1)) {
                    pBtn.photoImg.image = [UIImage imageNamed:@"anjuke_icon_add_pic"];
                }
                else if (all_imageIndex < (int)(showedImageArr.count))
                {
                    pBtn.photoImg.imageUrl = [showedImageArr objectAtIndex:all_imageIndex];
                }
                else if (all_imageIndex >= showedImageArr.count && all_imageIndex  < showedImageArr.count + addImgArr.count)
                {
                    NSString *url = nil;
                    url =  [addImgArr objectAtIndex:all_imageIndex - showedImageArr.count]; //去除第一个添加按钮
                    pBtn.photoImg.image = [UIImage imageWithContentsOfFile:url];
                }else { //草泥马的在线户型图。。。
                    if (onlineHouseTypeArr.count > 0) {
                        pBtn.photoImg.imageUrl = [onlineHouseTypeArr objectAtIndex:0];
                    }
                }
                [pBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:pBtn];
                    
                [self.imageBtnArray addObject:pBtn];
            }
        }
        
        CGFloat titleW = 120;
        UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, titleW, 20)];
        titleLb.text = @"室内图";
        if (self.isHouseType) {
            titleLb.text = @"户型图";
        }
        [titleLb setTextAlignment:NSTextAlignmentLeft];
        titleLb.textColor = SYSTEM_LIGHT_GRAY;
        titleLb.font = [UIFont systemFontOfSize:20];
        [self addSubview:titleLb];
        
        CGFloat frameHeight = titleLb.frame.origin.y + CGRectGetHeight(titleLb.frame) + PF_IMAGE_GAP_Y + (PF_IMAGE_GAP_Y + PF_IMAGE_WIDTH)*verticalRow;
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frameHeight);
        
        DLog(@"new photo Height %d层高", verticalRow);
    }
    
    height = self.frame.size.height;
    DLog(@"new photo Height %f", height);
    
    //将当前的新高度回调给superView
    if ([self.clickDelegate respondsToSelector:@selector(drawFinishedWithCurrentHeight:)]) {
        [self.clickDelegate drawFinishedWithCurrentHeight:height];
    }
    [self resetLineWithHeight:height];
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
    if (self.clickDelegate && [self.clickDelegate respondsToSelector:@selector(addImageDidClick)]) {
        [self.clickDelegate addImageDidClick];
    }
    if (self.clickDelegate && [self.clickDelegate respondsToSelector:@selector(addImageDidClick:)])
    {
        [self.clickDelegate addImageDidClick:self];
    }
}

- (void)imageBtnClick:(id)sender {
    PhotoButton *pb = (PhotoButton *)sender;
    int index = pb.tag;
    
    if (index == _addActionTag) { //点击添加图片
        //将添加按钮点击时间回调给superView
        if ([self.clickDelegate respondsToSelector:@selector(addImageDidClick)]) {
            [self.clickDelegate addImageDidClick];
        }
        if ([self.clickDelegate respondsToSelector:@selector(addImageDidClick:)]) {
            [self.clickDelegate addImageDidClick:self];
        }
    }
    else {
        //产看第几张图片通过数组index给到
        if ([self.clickDelegate respondsToSelector:@selector(imageDidClickWithIndex:)]) {
            [self.clickDelegate imageDidClickWithIndex:index];
        }
        if ([self.clickDelegate respondsToSelector:@selector(imageDidClickWithIndex:sender:)])
        {
            [self.clickDelegate imageDidClickWithIndex:index sender:self];
        }
    }
}

- (int)getVerticalRowNumberWithWholeCount:(int)wholeCount {
    int verticalRow = 0;
    
    if (wholeCount <= 4) {
        verticalRow = 1; //一行
    }
    else if (wholeCount >= 5 && wholeCount <= 8){
        verticalRow = 2; //2行
    }
    else {
        verticalRow = 3; //3行
    }
    
    return verticalRow;
}

- (void)resetLineWithHeight:(CGFloat)height {
    self.topLine.frame = CGRectMake(0, 0, 320, BL_HEIGHT);
    self.bottomLine.frame = CGRectMake(0, height - BL_HEIGHT, 320, BL_HEIGHT);
}

@end
