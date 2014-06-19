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
@synthesize mutableSelect;
@synthesize proIcon;
@synthesize backView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.backView = [[UIView alloc] initWithFrame:CGRectMake(48, 0, 270, self.contentView.frame.size.height)];
        self.backView.backgroundColor = [UIColor clearColor];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 260, 40)];
        self.title.numberOfLines = 2;
        self.title.lineBreakMode = NSLineBreakByWordWrapping;
        self.title.textColor = [UIColor ajkBlackColor];
        self.title.font = [UIFont systemFontOfSize:15];
        
        self.detail = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, 300, 20)];
        self.detail.textColor = [UIColor ajkLightGrayColor];
        self.detail.font = [UIFont systemFontOfSize:12];
        
        self.proIcon = [[UIImageView alloc] init];
        self.proIcon.frame = CGRectMake(280, 25, 22, 14);
        
        [self.backView addSubview:self.title];
        [self.backView addSubview:self.detail];
        [self.contentView addSubview:self.proIcon];
        [self.contentView addSubview:self.backView];
    }
    return self;
}

-(void)setValueForCellByDictionar:(NSDictionary *) dic{
    self.backView.frame = CGRectMake(10, 0, 320, self.contentView.frame.size.height);
    self.title.text = [dic objectForKey:@"title"];
    self.title.text = @"中文中温中文中文他咋的张杰打开费拉达斯放大镜看了";

    CGSize si = [Util_UI sizeOfString:self.title.text maxWidth:260 withFontSize:15];
    self.title.frame = CGRectMake(5, 13, si.width, si.height);
    self.proIcon.frame = CGRectMake(290, self.title.frame.origin.y + 2, 22, 14);
    self.detail.frame = CGRectMake(5, self.title.frame.size.height + 12, 270, 20);
    
    NSString *tempStr = [NSString stringWithFormat:@"%@ %@室%@厅  %@平 %@%@",
                         [dic objectForKey:@"commName"],
                         [dic objectForKey:@"roomNum"],
                         [dic objectForKey:@"hallNum"],
                         [dic objectForKey:@"area"],
                         [dic objectForKey:@"price"],
                         [dic objectForKey:@"priceUnit"]];
    
    self.detail.text = tempStr;
    [self setProIconWithPro:dic];
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
}

@end
