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
@synthesize btnImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        mutableBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        mutableBtn.frame = CGRectMake(0, 0, 48, 67);
        
        btnImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 22, 22, 22)];
        [mutableBtn addSubview:btnImage];
        
        [self.contentView addSubview:mutableBtn];
    // Initialization code
    }
    return self;
}

-(void)clickEvent:(SEL) selecter target:(id) target indexpath:(NSIndexPath *) indexpath{


}

@end
