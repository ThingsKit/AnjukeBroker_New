//
//  PPCGroupCell.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "PPCGroupCell.h"

@implementation PPCGroupCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        title = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 310, 30)];
        title.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:title];
        
        detail = [[UILabel alloc] initWithFrame:CGRectMake(20, 35, 310, 20)];
        detail.textColor = [UIColor grayColor];
        detail.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:detail];
        
        status = [[UILabel alloc] initWithFrame:CGRectMake(240, 30, 50, 15)];
        status.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:status];
        // Initialization code
    }
    return self;
}
-(void)setValueForCellByDictinary:(NSDictionary *) dic{
    title.text = [dic objectForKey:@"title"];
    detail.text = [dic objectForKey:@"detail"];
    status.text = [dic objectForKey:@"status"];
    if([[dic objectForKey:@"type"] isEqualToString:@"1"]){
//        status.backgroundColor = [UIColor redColor];
        
    }else if ([[dic objectForKey:@"type"] isEqualToString:@"2"]){
        status.backgroundColor = [UIColor greenColor];
        status.textAlignment = NSTextAlignmentCenter;
        status.layer.cornerRadius = 6;
    }
    else{
    
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
