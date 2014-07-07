//
//  PPCHouseCell.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-7-1.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PPCHouseCell.h"
#import <QuartzCore/QuartzCore.h>
#import "BK_WebImageView.h"
#import "PPCPriceingListModel.h"
#import "Util_UI.h"
#import "HouseCellView.h"

@interface PPCHouseCell ()
@property(nonatomic, strong) HouseCellView *cellView;
@end

@implementation PPCHouseCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier containingTableView:containingTableView leftUtilityButtons:leftUtilityButtons rightUtilityButtons:rightUtilityButtons];
    
    if (self) {
        self.cellView = [[HouseCellView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:self.cellView];
    }
    return self;
}

- (BOOL)configureCell:(id)dataModel withIndex:(int)index isHaoZu:(BOOL)isHaoZu{
    [self.cellView configCellViewWithData:dataModel isHaoZu:isHaoZu];
    
    return YES;
}

- (void)showBottonLineWithCellHeight:(CGFloat)cellH andOffsetX:(CGFloat)offsetX {
    if (self.lineView == nil) {
        self.lineView = [[BrokerLineView alloc] initWithFrame:CGRectMake(offsetX, cellH -0.5, 320 - offsetX, 0.5)];
        [self.contentView addSubview:self.lineView];
    }
    else {
        self.lineView.frame = CGRectMake(offsetX, cellH -0.5, 320 - offsetX, 0.5);
    }
}


@end
