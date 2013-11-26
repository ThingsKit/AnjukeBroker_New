//
//  RentBidPropertyCell.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/19/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "RentBidPropertyCell.h"

@implementation RentBidPropertyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self adjustUI];
        // Initialization code
    }
    return self;
}
-(void)adjustUI{
    self.stage.frame = CGRectMake(20, 20, 60, 30);

}
-(void)setValueForCellByDataModel:(id) dataModel{
    if([dataModel isKindOfClass:[NSDictionary class]]){
        NSDictionary *propInfo = (NSDictionary *)dataModel;
        self.title.text = [propInfo objectForKey:@"title"];
        self.price.text = [NSString stringWithFormat:@"%@ %@室%@厅 %@平 %@%@", [propInfo objectForKey:@"commName"], [propInfo objectForKey:@"roomNum"], [propInfo objectForKey:@"hallNum"], [propInfo objectForKey:@"area"], [propInfo objectForKey:@"price"], [propInfo objectForKey:@"priceUnit"]];
        self.stringNum.text = [NSString stringWithFormat:@"%@           %@              %@             %@", [propInfo objectForKey:@"index"], [propInfo objectForKey:@"clickNum"], [propInfo objectForKey:@"offer"], [self getBudget:propInfo]];
        DLog(@"===%@",[propInfo objectForKey:@"budget"])
        self.stage.text = [propInfo objectForKey:@"index"];
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
