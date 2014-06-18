//
//  AuctionForbidView.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-16.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "AuctionForbidView.h"

@implementation AuctionForbidView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 20 -44);
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(104, 135, 112, 80)];
        [img setImage:[UIImage imageNamed:@"broker_fy_noproperty"]];
        [self addSubview:img];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(100, img.frame.origin.y + img.frame.size.height + 12, 120, 36)];
        lab.numberOfLines = 0;
        lab.font = [UIFont ajkH3Font];
        lab.lineBreakMode = UILineBreakModeWordWrap;
        lab.textColor = [UIColor brokerLightGrayColor];
        lab.text = @"竞价产品已下架\n 全新精选推广敬请期待！";
        [self addSubview:lab];
    }
    return self;
}



@end
