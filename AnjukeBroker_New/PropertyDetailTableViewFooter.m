//
//  PropertyDetailTableViewFooter.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-7-1.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PropertyDetailTableViewFooter.h"
#import "PropertyDetailButton.h"

@interface PropertyDetailTableViewFooter ()

@property (nonatomic, strong) PropertyDetailButton* buttonEdit;  //编辑按钮
@property (nonatomic, strong) PropertyDetailButton* buttonDelete;  //删除按钮

@end


@implementation PropertyDetailTableViewFooter

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    
    self.frame = CGRectMake(0, 0, ScreenWidth, <#CGFloat height#>)
    
    
}

@end
