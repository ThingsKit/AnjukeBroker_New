//
//  AXChatMessagePublicCellTopButton.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-17.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "AXChatMessagePublicCellTopButton.h"
#import "BK_WebImageView.h"
#import "Util_UI.h"

@interface AXChatMessagePublicCellTopButton ()
//@property(nonatomic, strong) NSDictionary *data;
@end

@implementation AXChatMessagePublicCellTopButton


- (instancetype)initWithData:(NSDictionary *)dic{
    self = [AXChatMessagePublicCellTopButton buttonWithType:UIButtonTypeCustom];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _data = dic;
        [self initUI];
    }
    
    return self;
}

- (void)initUI{
    self.frame = CGRectMake(0, 0, 290, 156);
    BK_WebImageView *img = [[BK_WebImageView alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width-20, 135)];
    [img setImageUrl:_data[@"img"]];
    [self addSubview:img];

    UIView *titBgView = [[UIView alloc] initWithFrame:CGRectMake(10, self.frame.size.width-20, 95, 50)];
    titBgView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
    [self addSubview:titBgView];
    
    UILabel *tit = [[UILabel alloc] init];
    tit.lineBreakMode = UILineBreakModeWordWrap;
    tit.numberOfLines = 1;
    tit.textColor = [UIColor brokerWhiteColor];
    tit.font = [UIFont ajkH3Font];
    tit.textAlignment = NSTextAlignmentLeft;
    [titBgView addSubview:tit];
    
    
    CGSize size = [Util_UI sizeOfString:_data[@"title"] maxWidth:self.frame.size.width-20 withFontSize:15];
    if (size.height > 15) {
        tit.frame = CGRectMake(10, 5, titBgView.frame.size.width-20, 40);
    }else{
        tit.frame = CGRectMake(10, 15, titBgView.frame.size.width-20, 20);
    }
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.backgroundColor = [UIColor clearColor];
    }else{
        self.backgroundColor = [UIColor clearColor];
    }
}

@end
