//
//  NoDataView.m
//  AiFang
//
//  Created by lh liu on 12-4-10.
//  Copyright (c) 2012年 anjuke. All rights reserved.
//

#import "NoDataView.h"
#import "Util_UI.h"

#define imageWidth 191/2
#define imageHeight 175/2

#define labTitleWidth 195

@implementation NoDataView
@synthesize labTitle, imageView;
@synthesize selfFrame, show_Type, noDataImgName, noDataImgSize, showTitle;
@synthesize showSuperview, listView;

#pragma mark - new Image Show Method

- (id)initWithImgName:(NSString *)imgName AndTitle:(NSString *)title{
    self = [super init];
    if (self) {
        self.hidden = YES;
        self.showType = TypeWithNoData;
        self.backgroundColor = [UIColor whiteColor];
        
        //image
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
        img.backgroundColor = [UIColor clearColor];
        img.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView = img;
        [self addSubview:img];
        
        self.noDataImgSize = self.imageView.image.size; //记录指定的无数据图面size
        self.noDataImgName = [NSString stringWithString:imgName];
        
        //title
        if (title.length > 0 && title!= nil) {
            self.showTitle = [NSString stringWithString:title];
            
            UILabel *titleLb = [[UILabel alloc] init];
            self.labTitle = titleLb;
            titleLb.textAlignment = UITextAlignmentCenter;
            titleLb.font = [UIFont systemFontOfSize:14];
            titleLb.textColor = [Util_UI colorWithHexString:@"a2a2a2"];
            titleLb.text = title;
            [titleLb setBackgroundColor:[UIColor clearColor]];
            [self addSubview:titleLb];
        }
        self.show_Type = TypeWithNoData; //默认无数据显示
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    self.selfFrame = frame; //记录指定的自身frame
    
    self.imageView.frame = CGRectMake((frame.size.width-imageWidth)/2, (frame.size.height - imageHeight)/2 - 30, imageWidth, imageHeight);
    self.labTitle.frame = CGRectMake((frame.size.width-labTitleWidth)/2, self.imageView.frame.origin.y+self.imageView.frame.size.height+13, labTitleWidth, 22);
}

- (void)setShowType:(ShowType)showType {
    self.show_Type = showType;
    
    if (self.show_Type == TypeWithNoData) {
        self.imageView.image = [UIImage imageNamed:self.noDataImgName];
        self.labTitle.text = self.showTitle;
    }
    else if (self.show_Type == TypeWithNoNetWork) {
        self.imageView.image = [UIImage imageNamed:NoDataImg_NetWorkError];
        self.labTitle.text = @"请检查您的网络设置";
    }
    
    self.imageView.frame = CGRectMake((self.selfFrame.size.width-imageWidth)/2, (self.selfFrame.size.height - imageHeight)/2, imageWidth, imageHeight);
    self.labTitle.frame = CGRectMake((self.selfFrame.size.width-labTitleWidth)/2, self.imageView.frame.origin.y+self.imageView.frame.size.height+3, labTitleWidth, 22);
}

- (void)showNoDataView:(BOOL)show{
    if (show) { //显示提示
        self.hidden = NO;
        self.listView.hidden = YES;
        [self.showSuperview insertSubview:self aboveSubview:self.listView];
    }
    else { //隐藏提示
        self.hidden = YES;
        self.listView.hidden = NO;
        [self.showSuperview insertSubview:self.listView aboveSubview:self];
    }
}

@end
