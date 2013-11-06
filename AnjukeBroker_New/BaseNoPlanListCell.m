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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(48, 10, 250, 20)];
        self.title.textColor = SYSTEM_BLACK;
        
        self.detail = [[UILabel alloc] initWithFrame:CGRectMake(48, 40, 150, 20)];
        self.detail.textColor = [Util_UI colorWithHexString:@"#666666"];
        self.detail.font = [UIFont systemFontOfSize:12];
        
        self.price = [[UILabel alloc] initWithFrame:CGRectMake(210, 30, 150, 20)];
        self.price.textColor = [UIColor grayColor];
        self.price.font = [UIFont systemFontOfSize:12];
        
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.detail];
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
        return YES;
    }

    return NO;
}
-(void)setDetailLableValue:(BasePropertyObject *) pro{
    NSString *tempStr = [NSString stringWithFormat:@"%@  0平 %@%@",pro.type, pro.price, pro.priceUnit];
    self.detail.text = tempStr;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
