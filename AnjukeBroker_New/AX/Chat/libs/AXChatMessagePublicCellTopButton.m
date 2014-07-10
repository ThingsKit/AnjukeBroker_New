//
//  AXChatMessagePublicCellTopButton.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-17.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "AXChatMessagePublicCellTopButton.h"
#import "BK_WebImageView.h"
#import "Util_UI.h"
#import "UIImage+RTStyle.h"

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
    self.frame = CGRectMake(1, 1, 290, 156);
    BK_WebImageView *img = [[BK_WebImageView alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width-20, 135)];
    [img setImageUrl:_data[@"img"]];
    [self addSubview:img];

    UIImageView *titBgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.frame.size.height -10 - 50, self.frame.size.width - 20, 50)];
    [titBgView setImage:[UIImage createImageWithColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5]]];
   
    UILabel *tit = [[UILabel alloc] init];
    tit.lineBreakMode = UILineBreakModeWordWrap;
    tit.backgroundColor = [UIColor clearColor];
    tit.numberOfLines = 0;
    tit.frame = CGRectMake(10, 5, titBgView.frame.size.width-20, 40);
    tit.textColor = [UIColor brokerWhiteColor];
    tit.font = [UIFont ajkH3Font];
    tit.text = _data[@"title"];
    tit.textAlignment = NSTextAlignmentLeft;
    [titBgView addSubview:tit];

    [self addSubview:titBgView];
    
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
        self.backgroundColor = [UIColor brokerBgSelectColor];
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end
