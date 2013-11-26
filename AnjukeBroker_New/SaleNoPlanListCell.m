//
//  SaleNoPlanListCell.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/30/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "SaleNoPlanListCell.h"
#import "SalePropertyObject.h"

@implementation SaleNoPlanListCell
@synthesize mutableBtn;
@synthesize btnImage;
@synthesize clickDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.mutableBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.mutableBtn.frame = CGRectMake(0, 0, 48, 67);
        [self.mutableBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.btnImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 22, 22, 22)];
        [self.mutableBtn addSubview:self.btnImage];
        
        [self.contentView addSubview:self.mutableBtn];
    }
    return self;
}

- (BOOL)configureCell:(id)dataModel withIndex:(int)index{
    [super configureCell:dataModel withIndex:index];
    return NO;
}
-(BOOL)configureCellWithDic:(NSDictionary *) dic{
    self.backView.frame = CGRectMake(10, 5, 300, self.contentView.frame.size.height);
    self.title.text = [dic objectForKey:@"title"];
    
    NSString *tempStr = [NSString stringWithFormat:@"%@ %@室%@厅  %@平 %@%@", [dic objectForKey:@"commName"], [dic objectForKey:@"roomNum"], [dic objectForKey:@"hallNum"], [dic objectForKey:@"area"], [dic objectForKey:@"price"], [dic objectForKey:@"priceUnit"]];
    self.detail.text = tempStr;
    return YES;
}
- (void)btnClicked:(id)sender {
    if ([self.clickDelegate respondsToSelector:@selector(checkmarkBtnClickedWithRow:)]) {
        [self.clickDelegate checkmarkBtnClickedWithRow:self.selectRow];
    }
}

@end
