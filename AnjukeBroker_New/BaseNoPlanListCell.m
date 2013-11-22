//
//  NoPlanListCell.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/28/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "BaseNoPlanListCell.h"
#import "Util_UI.h"

@implementation BaseNoPlanListCell
@synthesize title;
@synthesize detail;
@synthesize price;
@synthesize mutableSelect;
@synthesize proIcon;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(48, 5, 260, 40)];
        self.title.numberOfLines = 0;
        self.title.lineBreakMode = NSLineBreakByWordWrapping;
        self.title.textColor = SYSTEM_BLACK;
        self.title.font = [UIFont systemFontOfSize:14];
        
        self.detail = [[UILabel alloc] initWithFrame:CGRectMake(48, 40, 260, 20)];
        self.detail.textColor = [Util_UI colorWithHexString:@"#666666"];
        self.detail.font = [UIFont systemFontOfSize:12];
        
        self.proIcon = [[UIImageView alloc] init];
        self.proIcon.frame = CGRectMake(280, 25, 22, 14);
        
        self.price = [[UILabel alloc] initWithFrame:CGRectMake(210, 30, 150, 20)];
        self.price.textColor = [UIColor grayColor];
        self.price.font = [UIFont systemFontOfSize:12];
        
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.detail];
        [self.contentView addSubview:self.proIcon];
        [self.contentView addSubview:self.price];
        // Initialization code
    }
    return self;
}

- (BOOL)configureCell:(id)dataModel withIndex:(int)index {
    if([dataModel isKindOfClass:[BasePropertyObject class]]){
        BasePropertyObject *tempProperty = (BasePropertyObject *)dataModel;
        [self setDetailLableValue:tempProperty];
        self.title.text = tempProperty.title;
        [self setProIconWithPro:tempProperty];
        return YES;
    }

    return NO;
}
-(void)setDetailLableValue:(BasePropertyObject *) pro{
    NSString *tempStr = [NSString stringWithFormat:@"%@  %@室%@厅%@卫  0平 %@%@", pro.communityName, pro.roomNum, pro.hallNum, pro.toiletNum, pro.price, pro.priceUnit];
    self.detail.text = tempStr;
}
- (void)setProIconWithPro:(BasePropertyObject *) pro{
    if([pro.isMoreImg isEqualToString:@"1"]){
    self.proIcon.image = [UIImage imageNamed:@"anjuke_icon_mutableimg@2x.png"];
    }else if([pro.isVisible isEqualToString:@"0"]){
    self.proIcon.image = [UIImage imageNamed:@"anjuke_icon_violat@2x.png"];
    }else{
   // anjuke_icon_draft@2x.png
    self.proIcon.image = nil;
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
