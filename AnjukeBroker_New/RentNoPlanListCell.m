//
//  RentNoPlanListCell.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/20/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "RentNoPlanListCell.h"
#import "Util_UI.h"

@implementation RentNoPlanListCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
    }
    return self;
}
-(BOOL)configureCellWithDic:(NSDictionary *) dic{
    self.backView.frame = CGRectMake(10, 0, 320, self.contentView.frame.size.height);
    self.title.text = [dic objectForKey:@"title"];
//    CGSize size = CGSizeMake(270, 40);
//    CGSize si = [[dic objectForKey:@"title"] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    CGSize si = [Util_UI sizeOfString:[dic objectForKey:@"title"] maxWidth:270 withFontSize:14];
    self.title.frame = CGRectMake(0, 8, si.width, si.height);
    self.proIcon.frame = CGRectMake(290, self.title.frame.origin.y + 2, 22, 14);
    self.detail.frame = CGRectMake(0, self.title.frame.size.height + 15, 270, 20);
    NSString *tempStr = [NSString stringWithFormat:@"%@ %@室%@厅  %@平 %@%@", [dic objectForKey:@"commName"], [dic objectForKey:@"roomNum"], [dic objectForKey:@"hallNum"], [dic objectForKey:@"area"], [dic objectForKey:@"price"], [dic objectForKey:@"priceUnit"]];
    self.detail.text = tempStr;
    [self setProIconWithPro:dic];
    return YES;
}
- (void)setProIconWithPro:(NSDictionary *) dic{
    if([[dic objectForKey:@"isMoreImg"] isEqualToString:@"1"]){
        self.proIcon.image = [UIImage imageNamed:@"anjuke_icon_mutableimg@2x.png"];
    }else{
        // anjuke_icon_draft@2x.png
        self.proIcon.image = nil;
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
