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

@interface PPCHouseCell ()
@property(nonatomic, strong) BK_WebImageView *mainImgView;
@property(nonatomic, strong) UILabel *titLab;
@property(nonatomic, strong) UIImageView *mutImgView;
@property(nonatomic, strong) UIImageView *choiceImgView;
@property(nonatomic, strong) UIImageView *fromImgView;
@property(nonatomic, strong) UILabel *commNameLab;
@property(nonatomic, strong) UILabel *houseDetailLab;
@property(nonatomic, strong) UILabel *totalClickTitLab;
@property(nonatomic, strong) UILabel *totalClickLab;

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
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.mainImgView = [[BK_WebImageView alloc] initWithFrame:CGRectMake(15, 15, 80, 60)];
    self.mainImgView.layer.masksToBounds = YES;
    self.mainImgView.layer.cornerRadius = 4;
    self.mainImgView.backgroundColor = [UIColor brokerLineColor];
    [self.contentView addSubview:self.mainImgView];
    
    self.titLab = [[UILabel alloc] initWithFrame:CGRectMake(80+15+11, 15, 200, 20)];
    self.titLab.textColor = [UIColor brokerBlackColor];
    self.titLab.backgroundColor = [UIColor clearColor];
    self.titLab.font = [UIFont ajkH3Font];
    [self.contentView addSubview:self.titLab];

    
    for (int i = 0; i < 3; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 6 - 51 -15 + 20*i, 15 , 17, 17)];
        imgView.tag = 1000 + i;
        imgView.hidden = YES;
        [self.contentView addSubview:imgView];
    }
    
    self.commNameLab = [[UILabel alloc] initWithFrame:CGRectMake(80+15+11, 45, 200, 15)];
    self.commNameLab.textColor = [UIColor brokerLightGrayColor];
    self.commNameLab.backgroundColor = [UIColor clearColor];
    self.commNameLab.font = [UIFont ajkH4Font];
    [self.contentView addSubview:self.commNameLab];

    self.houseDetailLab = [[UILabel alloc] initWithFrame:CGRectMake(80+15+11, 70, 130, 15)];
    self.houseDetailLab.textColor = [UIColor brokerLightGrayColor];
    self.houseDetailLab.backgroundColor = [UIColor clearColor];
    self.houseDetailLab.font = [UIFont ajkH4Font];
    [self.contentView addSubview:self.houseDetailLab];

    self.totalClickTitLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-15, 70, 50, 15)];
    self.totalClickTitLab.textColor = [UIColor brokerLightGrayColor];
    self.totalClickTitLab.backgroundColor = [UIColor clearColor];
    self.totalClickTitLab.textAlignment = NSTextAlignmentRight;
    self.totalClickTitLab.font = [UIFont ajkH4Font];
    self.totalClickTitLab.text = @"总点击";
    [self.contentView addSubview:self.totalClickTitLab];

    self.totalClickLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-15-60, 70 - 3, 60, 15)];
    self.totalClickLab.textColor = [UIColor brokerLightGrayColor];
    self.totalClickLab.backgroundColor = [UIColor clearColor];
    self.totalClickLab.font = [UIFont ajkH3Font];
    self.totalClickLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.totalClickLab];
}

- (BOOL)configureCell:(id)dataModel withIndex:(int)index {
    PPCPriceingListModel *model = (PPCPriceingListModel *)dataModel;
    
    [self.mainImgView setImageUrl:model.imgURL];
    self.titLab.text = model.title;
    self.commNameLab.text = model.commName;
    self.detailTextLabel.text = [NSString stringWithFormat:@"%@室%@厅%@卫 %@平 %@%@",model.roomNum,model.hallNum,model.toiletNum,model.area,model.price,model.priceUnit];
    self.totalClickLab.text = model.fixClickNum;
    
    CGSize size = [Util_UI sizeOfString:model.fixClickNum maxWidth:60 withFontSize:15];
    self.totalClickLab.frame = CGRectMake(ScreenWidth-15-60 - 5 - size.width, 70 - 3, 60, 15);
    
    int i = 0;
    if ([model.isMoreImg isEqualToString:@"1"]) {
        i++;
        
        UIImageView *imgView = (UIImageView *)[self.contentView viewWithTag:1000+0];
        imgView.hidden = NO;
    }else if (model.isChoice){
        i++;

        UIImageView *imgView = (UIImageView *)[self.contentView viewWithTag:1000+1];
        imgView.hidden = NO;
    }else if (model.isPhonePub){
        i++;
        
        UIImageView *imgView = (UIImageView *)[self.contentView viewWithTag:1000+2];
        imgView.hidden = NO;
    }
    self.titLab.frame = CGRectMake(80+15+11, 15, 200 - i*20, 20);
    
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
