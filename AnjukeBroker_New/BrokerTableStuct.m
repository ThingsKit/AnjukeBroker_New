//
//  BrokerTableStuct.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-12.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "BrokerTableStuct.h"

@implementation BrokerTableStuct
@synthesize headerView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)setTableStatus:(UIView *)showView status:(TableStatus)status{
    if (status == STATUSFOROK) {
        self.tableHeaderView = nil;
        return;
    }
    if (!self.headerView) {
        [self.headerView removeFromSuperview];
        self.headerView = nil;
    }
    self.headerView = [[UIView alloc] initWithFrame:self.frame];
    self.headerView.backgroundColor = [UIColor whiteColor];
    
    showView.center = self.center;
    [self.headerView addSubview:showView];
    
    self.tableHeaderView = self.headerView;
}
@end
