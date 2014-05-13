//
//  FangYuanTableView.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-13.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "FangYuanTableView.h"

@implementation FangYuanTableView

#pragma mark -
#pragma mark - Table view data source

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        
    }
    
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"FangYuanTableViewCell";
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    [self deselectRowAtIndexPath:indexPath animated:NO]; //取消选中
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

@end
