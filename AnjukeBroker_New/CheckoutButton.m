//
//  CheckoutButton.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-13.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "CheckoutButton.h"

@implementation CheckoutButton
@synthesize timer;
@synthesize leftTime;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
+ (UIButton *)buttonWithNormalStatus{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"立即签到" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:20];
    
    return btn;
}

+ (UIButton *)buttonWithUnCheck{
    return nil;
}

- (UIButton *)buttonWithCountdown:(NSInteger)timeLeft{
    leftTime = &timeLeft;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 30, 30)];
    [icon setImage:[UIImage imageNamed:@"agent_icon43"]];
    [btn addSubview:icon];
    
    self.timeCountLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 150, 30)];
    self.timeCountLab.textAlignment = NSTextAlignmentLeft;
    self.timeCountLab.font = [UIFont systemFontOfSize:14];
    self.timeCountLab.text = [NSString stringWithFormat:@"距下次签到%@",[self changeTimeToStr:timeLeft]];
    [btn addSubview:self.timeCountLab];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(downTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];

    return btn;
}

- (NSString *)changeTimeToStr:(NSInteger)time{
    NSString *h;
    NSString *m;
    NSString *s;
    
    h = [NSString stringWithFormat:@"%d",time/3600];
    m = [NSString stringWithFormat:@"%d",(time - [h intValue]*3600)/60];
    s = [NSString stringWithFormat:@"%d",time - [h intValue]*3600 - [m intValue]*60];
    
    NSString *timeStr = [NSString stringWithFormat:@"%@:%@:%@",h,m,s];
    
    return timeStr;
}

- (void)downTime{
    leftTime = leftTime - 1;
    if (leftTime == 0) {
        
    }else{
        NSString *str = [self changeTimeToStr:*(leftTime)];
        DLog(@"changeTime--")
        self.timeCountLab.text = [NSString stringWithFormat:@"距下次签到%@",str];
    }
}
@end
