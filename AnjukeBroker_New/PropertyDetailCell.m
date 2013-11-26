//
//  PropertyDetailCell.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "PropertyDetailCell.h"
#import "Util_UI.h"

@implementation PropertyDetailCell
@synthesize title;
@synthesize detail;
@synthesize price;
@synthesize mutableSelect;
@synthesize proIcon;
@synthesize backView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.backView = [[UIView alloc] initWithFrame:CGRectMake(48, 0, 270, self.contentView.frame.size.height)];
        self.backView.backgroundColor = [UIColor clearColor];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 260, 40)];
        self.title.numberOfLines = 0;
        self.title.lineBreakMode = NSLineBreakByWordWrapping;
        self.title.textColor = SYSTEM_BLACK;
        self.title.font = [UIFont systemFontOfSize:14];
        
        self.detail = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 300, 20)];
        self.detail.textColor = [Util_UI colorWithHexString:@"#666666"];
        self.detail.font = [UIFont systemFontOfSize:12];
        
        self.proIcon = [[UIImageView alloc] init];
        self.proIcon.frame = CGRectMake(280, 25, 22, 14);
        
        self.price = [[UILabel alloc] initWithFrame:CGRectMake(210, 30, 150, 20)];
        self.price.textColor = [UIColor grayColor];
        self.price.font = [UIFont systemFontOfSize:12];
        
        [self.backView addSubview:self.title];
        [self.backView addSubview:self.detail];
        [self.contentView addSubview:self.proIcon];
        [self.contentView addSubview:self.backView];
//        [self.contentView addSubview:price];
    }
    return self;
}

-(void)setValueForCellByDictionar:(NSDictionary *) dic{
    self.backView.frame = CGRectMake(10, 0, 320, self.contentView.frame.size.height);
    self.title.text = [dic objectForKey:@"title"];
    
    NSString *tempStr = [NSString stringWithFormat:@"%@ %@室%@厅  %@平 %@%@", [dic objectForKey:@"commName"], [dic objectForKey:@"roomNum"], [dic objectForKey:@"hallNum"], [dic objectForKey:@"area"], [dic objectForKey:@"price"], [dic objectForKey:@"priceUnit"]];
    self.detail.text = tempStr;
    [self setProIconWithPro:dic];
}

- (void)setProIconWithPro:(NSDictionary *) dic{
    if([[dic objectForKey:@"isMoreImg"] isEqualToString:@"1"]){
        self.proIcon.image = [UIImage imageNamed:@"anjuke_icon_mutableimg@2x.png"];
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
