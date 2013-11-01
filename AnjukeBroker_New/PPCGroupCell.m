//
//  PPCGroupCell.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "PPCGroupCell.h"
#import "Util_UI.h"

@implementation PPCGroupCell
@synthesize statueImg;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        title = [[UILabel alloc] initWithFrame:CGRectMake(26, 10, 310, 20)];
        title.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:title];
        
        detail = [[UILabel alloc] initWithFrame:CGRectMake(26, 35, 310, 20)];
        detail.textColor = [Util_UI colorWithHexString:@"#999999"];
        detail.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:detail];
        
        statueImg = [[UIImageView alloc] initWithFrame:CGRectMake(230, 25, 50, 20)];
        [self.contentView addSubview:statueImg];
        
        status = [[UILabel alloc] initWithFrame:CGRectMake(230, 25, 50, 20)];
        status.textColor = [UIColor whiteColor];
        status.font = [UIFont systemFontOfSize:12];
//        [self.contentView addSubview:status];
        // Initialization code
    }
    return self;
}
-(void)setValueForCellByDictinary:(NSDictionary *) dic{
    title.text = [dic objectForKey:@"title"];
    detail.text = [dic objectForKey:@"detail"];
    if([[dic objectForKey:@"status"] isEqualToString:@"推广中"]){
        [statueImg setImage:[UIImage imageNamed:@"anjuke_icon09_woking@2x.png"]];
    }else if ([[dic objectForKey:@"status"] isEqualToString:@""]){
        statueImg.frame = CGRectMake(260, 25, 12, 12);
        [statueImg setImage:[UIImage imageNamed:@"anjuke_icon08_attention@2x.png"]];
    }
//    status.text = [dic objectForKey:@"status"];
    if([[dic objectForKey:@"type"] isEqualToString:@"1"]){
//        status.backgroundColor = [UIColor redColor];
        
    }else if ([[dic objectForKey:@"type"] isEqualToString:@"2"]){
        status.backgroundColor = [Util_UI colorWithHexString:@"66CC00"];
        status.textAlignment = NSTextAlignmentCenter;
        status.layer.cornerRadius = 4;
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
