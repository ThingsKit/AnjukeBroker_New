//
//  RentNoPlanListCell.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/20/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "RentNoPlanListCell.h"

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
    self.title.text = [dic objectForKey:@"title"];
    
    NSString *tempStr = [NSString stringWithFormat:@"%@室%@厅%@卫  %@平 %@%@", [dic objectForKey:@"roomNum"], [dic objectForKey:@"hallNum"], [dic objectForKey:@"toiletNum"], [dic objectForKey:@"area"], [dic objectForKey:@"price"], [dic objectForKey:@"priceUnit"]];
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
