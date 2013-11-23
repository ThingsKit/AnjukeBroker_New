//
//  BidPropertyListCell.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "BaseBidPropertyCell.h"
#import "Util_UI.h"

@implementation BaseBidPropertyCell
@synthesize title;
@synthesize price;
@synthesize string;
@synthesize stringNum;
@synthesize stage;
@synthesize statusImg;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        title = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 250, 40)];
        title.numberOfLines = 0;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        title.text = @"汤臣一品";
        title.textColor = SYSTEM_BLACK;
        title.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:title];
        
        price = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 250, 20)];
        price.textColor = [Util_UI colorWithHexString:@"666666"];
        price.text = @"3室2厅 120平 400万";
        price.font = [UIFont systemFontOfSize:12];
        price.layer.cornerRadius = 6;
        [self.contentView addSubview:price];
        
//        statusImg = [[UIImageView alloc] initWithFrame:CGRectMake(295, 26, 8, 13)];
//        statusImg.image = [UIImage imageNamed:@"anjuke_icon07_arrow@2x.png"];
//        [self.contentView addSubview:statusImg];
        
        UILabel *contentView = [[UILabel alloc] initWithFrame:CGRectMake(0, 62, 320, 50)];
        [contentView setBackgroundColor:[Util_UI colorWithHexString:@"#F9F9F9"]];
        
        string = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 280, 20)];
        string.textColor = [Util_UI colorWithHexString:@"#666666"];
        string.text = @"当前排名       今日点击       出价(元)      预算余额(元)";
        string.font = [UIFont systemFontOfSize:11];
        string.layer.cornerRadius = 6;
        [contentView addSubview:string];
        
        stringNum = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, 280, 20)];
        stringNum.text = @"   1                  10                  2.0             18.00";
        stringNum.font = [UIFont systemFontOfSize:12];
        [contentView addSubview:stringNum];
        [self.contentView addSubview:contentView];

        stage = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 40, 30)];
        stage.backgroundColor = [Util_UI colorWithHexString:@"#F9F9F9"];
//        stage.text = @"   3";
        stage.textColor = [UIColor redColor];
        stage.font = [UIFont systemFontOfSize:16];
        [contentView addSubview:stage];
        [self.contentView addSubview:contentView];
        // Initialization code
        
        [self showUpArrowImg];
    }
    return self;
}
-(void)setValueForCellByDictinary:(NSDictionary *) dic{
    title.text = [dic objectForKey:@"title"];
    price.text = [dic objectForKey:@"price"];
    string.text = [dic objectForKey:@"string"];
    stringNum.text = [dic objectForKey:@"stringNum"];
}

-(void)setValueForCellByDataModel:(id) dataModel{
    if([dataModel isKindOfClass:[NSDictionary class]]){
        NSDictionary *propInfo = (NSDictionary *)dataModel;
        title.text = [propInfo objectForKey:@"title"];
        price.text = [NSString stringWithFormat:@"%@ %@室%@厅%@卫 %@平 %@%@", [propInfo objectForKey:@"commName"], [propInfo objectForKey:@"roomNum"], [propInfo objectForKey:@"hallNum"], [propInfo objectForKey:@"toiletNum"], [propInfo objectForKey:@"area"], [propInfo objectForKey:@"price"], [propInfo objectForKey:@"priceUnit"]];
        stringNum.text = [NSString stringWithFormat:@"   %@                  %@              %@             %@", [propInfo objectForKey:@"index"], [propInfo objectForKey:@"clickNum"], [propInfo objectForKey:@"offer"], [self getBudget:propInfo]];
        DLog(@"===%@",[propInfo objectForKey:@"budget"])
        stage.text = [propInfo objectForKey:@"index"];
    }
}

-(NSString *)getBudget:(NSDictionary *) dic{
    if([[dic objectForKey:@"bidStatus"] isEqualToString:@"3"]){
    return @"0";
    }
    return [dic objectForKey:@"budget"];
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
