//
//  SaleNoPlanListCell.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/30/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "SaleNoPlanListCell.h"

@implementation SaleNoPlanListCell
@synthesize mutableBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        mutableBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        mutableBtn.backgroundColor = [UIColor greenColor];
        mutableBtn.frame = CGRectMake(5, 5, 40, 40);
        [self.contentView addSubview:mutableBtn];
    // Initialization code
    }
    return self;
}

//-(void)callBack{
//    
//    if (_target != nil) {
//        if ([_target respondsToSelector:_selecter]) {
//            [_target performSelectorOnMainThread:_selecter withObject:self. waitUntilDone:YES];
//        }
//    }
//}

-(void)clickEvent:(SEL) selecter target:(id) target indexpath:(NSIndexPath *) indexpath{


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
