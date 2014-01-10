//
//  RentBidPropertyCell.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/19/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "RentBidPropertyCell.h"
#import "Util_UI.h"

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
    //    self.stage.frame = CGRectMake(20, 20, 60, 30);
    
}
-(void)setValueForCellByDataModel:(id) dataModel{
    if([dataModel isKindOfClass:[NSDictionary class]]){
        NSDictionary *propInfo = (NSDictionary *)dataModel;
        self.title.text = [propInfo objectForKey:@"title"];
//        CGSize size = CGSizeMake(260, 40);
//        CGSize si = [[propInfo objectForKey:@"title"] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        CGSize si = [Util_UI sizeOfString:[propInfo objectForKey:@"title"] maxWidth:260 withFontSize:14];
        self.title.frame = CGRectMake(20, 5, si.width, si.height);
        //        self.price.frame = CGRectMake(10, self.title.frame.origin.y+2, 14, 14);
        self.price.frame = CGRectMake(20, self.title.frame.size.height + 5, 270, 20);
        //        self.detail.frame = CGRectMake(27, self.comName.frame.size.height + self.title.frame.size.height + 5, 270, 20);
        self.detailView.frame = CGRectMake(0, self.price.frame.origin.y +23, 300, 50);
        self.price.text = [NSString stringWithFormat:@"%@ %@室%@厅 %@平 %@%@", [propInfo objectForKey:@"commName"], [propInfo objectForKey:@"roomNum"], [propInfo objectForKey:@"hallNum"], [propInfo objectForKey:@"area"], [propInfo objectForKey:@"price"], [propInfo objectForKey:@"priceUnit"]];
        self.stringNum.text = [NSString stringWithFormat:@"%@", [propInfo objectForKey:@"clickNum"]];
        self.offer.text = [propInfo objectForKey:@"offer"];
        self.ceiling.text = [self getBudget:propInfo];
        DLog(@"===%@",[propInfo objectForKey:@"budget"])
        [self setIndex:propInfo];
        
    }
}
- (void)setIndex:(NSDictionary *) dic{
    if([[dic objectForKey:@"index"] integerValue] <= 5 && ((NSString *)[dic objectForKey:@"index"]).length <2){
        self.stage.textColor = [Util_UI colorWithHexString:@"#ff6600"];
    }else{
        self.stage.textColor = SYSTEM_BLACK;
    }
    self.stage.text = [dic objectForKey:@"index"];
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
