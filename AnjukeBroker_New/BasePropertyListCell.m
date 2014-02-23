//
//  PropertyListCell.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "BasePropertyListCell.h"
#import "BasePropertyObject.h"
#import "Util_UI.h"

@implementation BasePropertyListCell
@synthesize title;
@synthesize comName;
@synthesize detail;
@synthesize price;
@synthesize tapNum;
@synthesize tapNumStr;
@synthesize bidStatue;
@synthesize proIcon;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.title = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.title setBackgroundColor:[UIColor clearColor]];
        self.title.numberOfLines = 0;
//        self.title.lineBreakMode = NSLineBreakByWordWrapping;
        self.title.font = [UIFont systemFontOfSize:14];
        
        self.bidStatue = [[UIImageView alloc] init];
        self.bidStatue.frame = CGRectMake(10, self.title.frame.origin.y, 14, 14);
        [self.contentView addSubview:self.bidStatue];
        
        self.comName = [[UILabel alloc] initWithFrame:CGRectMake(27, self.title.frame.size.height + 5, 250, 20)];
        self.comName.textColor = [Util_UI colorWithHexString:@"#666666"];
        self.comName.font = [UIFont systemFontOfSize:12];
        
        self.detail = [[UILabel alloc] initWithFrame:CGRectMake(27, self.comName.frame.size.height + self.title.frame.size.height + 5, 270, 20)];
        self.detail.textColor = [Util_UI colorWithHexString:@"#666666"];
        self.detail.font = [UIFont systemFontOfSize:12];
        
        self.proIcon = [[UIImageView alloc] init];
        self.proIcon.frame = CGRectMake(280, 25, 22, 14);
        
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.comName];
        [self.contentView addSubview:self.detail];
        [self.contentView addSubview:self.proIcon];
        
        self.tapNum = [[UILabel alloc] initWithFrame:CGRectMake(275, 45, 100, 20)];
        self.tapNum.backgroundColor = [UIColor clearColor];
        self.tapNum.textColor = [Util_UI colorWithHexString:@"#666666"];
        self.tapNum.font = [UIFont systemFontOfSize:12];
        //        tapNum.text = @"点击：50";
        [self.contentView addSubview:self.tapNum];
        
        self.tapNumStr = [[UILabel alloc] initWithFrame:CGRectMake(240, 45, 40, 20)];
        self.tapNumStr.backgroundColor = [UIColor clearColor];
        self.tapNumStr.font = [UIFont systemFontOfSize:12];
        self.tapNumStr.text = @"点击：";
        [self.contentView addSubview:self.tapNumStr];
        [self showUpArrowImg];
    }
    return self;
}
-(void)setValueForCellByObject:(BasePropertyObject *) obj{
    self.title.text = obj.title;
    self.detail.text = obj.communityName;
}
-(BOOL)configureCell:(id)dataModel{
    if([dataModel isKindOfClass:[BasePropertyObject class]]){
        BasePropertyObject *obj = (BasePropertyObject *)dataModel;
        self.title.text = obj.title;
        self.detail.text = obj.communityName;
        return YES;
    }else if ([dataModel isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)dataModel;
        self.title.text = [dic objectForKey:@"title"];
//        CGSize size = CGSizeMake(260, 40);
//        [[dic objectForKey:@"title"] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        CGSize si = [Util_UI sizeOfString:self.title.text maxWidth:260 withFontSize:14];
        self.title.frame = CGRectMake(27, 5, si.width, si.height);
        self.bidStatue.frame = CGRectMake(10, self.title.frame.origin.y+2, 14, 14);
        self.comName.frame = CGRectMake(27, self.title.frame.size.height + 5, 250, 20);
        self.detail.frame = CGRectMake(27, self.comName.frame.size.height + self.title.frame.size.height + 5, 270, 20);
        
        self.detail.text = [NSString stringWithFormat:@"%@室%@厅 %@平 %d%@", [dic objectForKey:@"roomNum"], [dic objectForKey:@"hallNum"], [dic objectForKey:@"area"], [[dic objectForKey:@"price"] intValue], [dic objectForKey:@"priceUnit"]];
        self.tapNum.text = [dic objectForKey:@"clickNum"];
        self.comName.text = [dic objectForKey:@"commName"];
        [self setBidStatueImg:dic];
    }
    return NO;
}

-(void)setBidStatueImg:(NSDictionary *)dic{
    if([[dic objectForKey:@"isBid"] isEqualToString:@"1"]){
        self.bidStatue.image = [UIImage imageNamed:@"anjuke_icon_bid.png"];
    }else {
        self.bidStatue.image = nil;
    }
}
- (void)setProIconWithPro:(NSDictionary *) dic{
    if([[dic objectForKey:@"isMoreImg"] isEqualToString:@"1"]){
        self.proIcon.image = [UIImage imageNamed:@"anjuke_icon_mutableimg.png"];
    }else{
        // anjuke_icon_draft.png
        self.proIcon.image = nil;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
