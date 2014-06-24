//
//  HomeHeaderView.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-9.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "HomeHeaderView.h"
#import "BrokerLineView.h"

@implementation HomeHeaderView
@synthesize btnClickDelegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self initUI];
    }
    return self;
}


- (void)initUI{
    self.backgroundColor = [UIColor brokerBgPageColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-10.5)];
    view.backgroundColor = [UIColor whiteColor];
    
    BrokerLineView *line = [[BrokerLineView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 10, self.frame.size.width, 0.5)];
    line.horizontalLine = YES;
    [self addSubview:line];

    
    NSArray *titArr = @[@"二手房管理",@"租房管理",@"市场分析"];
    
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor clearColor];
        if (i == 0) {
            [btn setBackgroundImage:[UIImage imageNamed:@"broker_home_icon_esf"] forState:UIControlStateNormal];
        }else if (i == 1){
            [btn setBackgroundImage:[UIImage imageNamed:@"broker_home_icon_zf"] forState:UIControlStateNormal];
        }else if (i == 2){
            [btn setBackgroundImage:[UIImage imageNamed:@"broker_home_icon_scfx"] forState:UIControlStateNormal];
        }
        
        btn.frame = CGRectMake(i*98 + 35, 30, 54, 54);
        [view addSubview:btn];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(i*98 + 13, btn.frame.origin.y+btn.frame.size.height + 10, 98, 15)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.backgroundColor = [UIColor clearColor];
        lab.font = [UIFont ajkH5Font];
        lab.text = [titArr objectAtIndex:i];
        lab.textColor = [UIColor ajkBlackColor];
        [view addSubview:lab];
    }
    
    [self addSubview:view];
}

- (void)btnClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    [btnClickDelegate btnClickWithTag:btn.tag];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
