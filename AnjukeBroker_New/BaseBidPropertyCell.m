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
@synthesize detailView;
@synthesize offer;
@synthesize ceiling;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //        UIView
        [self.contentView setBackgroundColor:[Util_UI colorWithHexString:@"#EFEFF4"]];
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 130)];
        [backView setBackgroundColor:[UIColor whiteColor]];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectZero];
        self.title.numberOfLines = 0;
        self.title.lineBreakMode = NSLineBreakByWordWrapping;
//        self.title.text = @"汤臣一品";
        self.title.textColor = SYSTEM_BLACK;
        self.title.font = [UIFont systemFontOfSize:14];
        [backView addSubview:self.title];
        
        self.price = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 250, 20)];
        self.price.textColor = [Util_UI colorWithHexString:@"666666"];
        //        self.price.text = @"3室2厅 120平 400万";
        self.price.font = [UIFont systemFontOfSize:12];
        self.price.layer.cornerRadius = 6;
        [backView addSubview:self.price];
        
        //        statusImg = [[UIImageView alloc] initWithFrame:CGRectMake(295, 26, 8, 13)];
        //        statusImg.image = [UIImage imageNamed:@"anjuke_icon07_arrow@2x.png"];
        //        [self.contentView addSubview:statusImg];
        
        self.detailView = [[UILabel alloc] initWithFrame:CGRectMake(0, 62, 300, 50)];
        
        self.string = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 280, 20)];
        self.string.textColor = [Util_UI colorWithHexString:@"#666666"];
        self.string.text = @"当前排名       今日点击       出价(元)      预算余额(元)";
        self.string.font = [UIFont systemFontOfSize:11];
        self.string.layer.cornerRadius = 6;
        [self.detailView addSubview:self.string];
        
        self.stringNum = [[UILabel alloc] initWithFrame:CGRectMake(90, 25, 40, 20)];
        //        self.stringNum.text = @"   1                  10                  2.0             18.00";
        self.stringNum.textAlignment = NSTextAlignmentCenter;
        self.stringNum.font = [UIFont systemFontOfSize:12];
        [self.detailView addSubview:self.stringNum];
        
        
        self.stage = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 50, 30)];
//        self.stage.backgroundColor = [Util_UI colorWithHexString:@"#F9F9F9"];
        //        stage.text = @"   3";
        //        self.stage.textColor = [Util_UI colorWithHexString:@"#ff6600"];
        self.stage.textAlignment = NSTextAlignmentCenter;
        self.stage.font = [UIFont systemFontOfSize:16];
        [self.detailView addSubview:self.stage];
        
        self.offer = [[UILabel alloc] initWithFrame:CGRectMake(145, 25, 60, 20)];
        self.offer.text = @"0";
        self.offer.font = [UIFont systemFontOfSize:12];
        self.offer.textAlignment = NSTextAlignmentCenter;
        [self.detailView addSubview:self.offer];
        
        self.ceiling = [[UILabel alloc] initWithFrame:CGRectMake(215, 25, 60, 20)];
        self.ceiling.text = @"0";
        self.ceiling.font = [UIFont systemFontOfSize:12];
        self.ceiling.textAlignment = NSTextAlignmentCenter;
        [self.detailView addSubview:self.ceiling];
        [backView addSubview:self.detailView];
        [self.contentView addSubview:backView];
        
        // Initialization code
        
        [self showUpArrowImg];
    }
    return self;
}
-(void)setValueForCellByDictinary:(NSDictionary *) dic{
    self.title.text = [dic objectForKey:@"title"];
    self.price.text = [dic objectForKey:@"price"];
    self.string.text = [dic objectForKey:@"string"];
    self.stringNum.text = [dic objectForKey:@"stringNum"];
}

-(void)setValueForCellByDataModel:(id) dataModel{
    if([dataModel isKindOfClass:[NSDictionary class]]){
        NSDictionary *propInfo = (NSDictionary *)dataModel;
        self.title.text = [propInfo objectForKey:@"title"];
        
        CGSize size = CGSizeMake(260, 40);
        CGSize si = [[propInfo objectForKey:@"title"] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        
        self.title.frame = CGRectMake(20, 5, si.width, si.height);
        self.price.frame = CGRectMake(20, self.title.frame.size.height + 5, 270, 20);
        
        self.detailView.frame = CGRectMake(0, self.price.frame.origin.y +23, 300, 50);
        
        self.price.text = [NSString stringWithFormat:@"%@ %@室%@厅 %@平 %@%@", [propInfo objectForKey:@"commName"], [propInfo objectForKey:@"roomNum"], [propInfo objectForKey:@"hallNum"], [propInfo objectForKey:@"area"], [propInfo objectForKey:@"price"], [propInfo objectForKey:@"priceUnit"]];
        self.stringNum.text = [NSString stringWithFormat:@"%@", [propInfo objectForKey:@"clickNum"]];
        self.offer.text = [propInfo objectForKey:@"offer"];
        self.ceiling.text = [self getBudget:propInfo];
        DLog(@"===%@",[propInfo objectForKey:@"budget"])
        //        self.stage.text = [propInfo objectForKey:@"index"];
        [self setStageByBidStatus:propInfo];
    }
}

-(NSString *)getBudget:(NSDictionary *) dic{
    if([[dic objectForKey:@"bidStatus"] isEqualToString:@"3"]){
        return @"0";
    }
    return [dic objectForKey:@"budget"];
}
- (void)setStageByBidStatus:(NSDictionary *) dic{
    if([[dic objectForKey:@"bidStatus"] isEqualToString:@"1"]){
        self.stage.textColor = [Util_UI colorWithHexString:@"#ff6600"];
    }else if ([[dic objectForKey:@"bidStatus"] isEqualToString:@"11"]){
        self.stage.textColor = SYSTEM_BLACK;
        self.stage.text = @"排队中";
        return ;
    }else{
        self.stage.textColor = SYSTEM_BLACK;
    }
    if([[dic objectForKey:@"index"] isEqualToString:@"0"]){
        self.stage.text = @"已暂停";
    }else{
        self.stage.text = [dic objectForKey:@"index"];
    }
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
