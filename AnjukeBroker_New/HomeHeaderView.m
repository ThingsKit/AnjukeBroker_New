//
//  HomeHeaderView.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-9.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "HomeHeaderView.h"

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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-10)];
    view.backgroundColor = [UIColor whiteColor];
    
    NSArray *titArr = @[@"二手房管理",@"租房管理",@"市场分析"];
    
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor brokerLightGrayColor];
        btn.frame = CGRectMake(i*103 + 20, 30, 80, 80);
        [view addSubview:btn];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.origin.x, btn.frame.origin.y+btn.frame.size.height + 10, 80, 20)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.backgroundColor = [UIColor clearColor];
        lab.font = [UIFont ajkH3Font];
        lab.text = [titArr objectAtIndex:i];
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
