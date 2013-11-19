//
//  RentPPCGroupCell.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/19/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "RentPPCGroupCell.h"
#import "SaleFixedGroupObject.h"
#import "Util_UI.h"

@implementation RentPPCGroupCell
@synthesize statueImg;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}
-(void)setValueForCellByData:(id ) data index:(int) index{
    [super setValueForCellByData:data index:index];
}

-(void)setFixedGroupValueForCellByData:(id ) data index:(int) index{
    [super setFixedGroupValueForCellByData:data index:index];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

