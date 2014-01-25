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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
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
    
    if (imageArr.count == 0) {
        //空白view
        CGRect frame = self.frame;
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, PF_EMPTY_IMAGE_HEIGHT);
        
        if (!self.emptyImgBtn) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            btn.backgroundColor = [UIColor clearColor];
            self.emptyImgBtn = btn;
            [btn addTarget:self action:@selector(emptyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
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
        
    }
    else { //图片排列，添加btn+预览btn
        
    }
    
    height = self.frame.size.height;
    DLog(@"new photo Height %f", height);
    
    //将当前的新高度回调给superView
    if ([self.clickDelegate respondsToSelector:@selector(drawFinishedWithCurrentHeight:)]) {
        [self.clickDelegate drawFinishedWithCurrentHeight:height];
    }
}

//空白按钮点击添加
- (void)emptyBtnClick:(id)sender {
    //将添加按钮点击时间回调给superView
    if ([self.clickDelegate respondsToSelector:@selector(addImageDidClick)]) {
        [self.clickDelegate addImageDidClick];
    }
    
    
}

@end
