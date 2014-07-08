//
//  AboutAJKListTableViewCell.m
//  Anjuke2
//
//  Created by xubing on 14-4-29.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import "AJKListTableViewCell.h"

#define retinaLineHeigth 0.5
#define ordinaryLineHeight 1.0

@interface AJKListTableViewCell ()

@property (strong, nonatomic) BrokerLineView *topLineView;
@property (strong, nonatomic) BrokerLineView *bottomLineView;
@property (strong, nonatomic) BrokerLineView *shortLineView;

@property (strong, nonatomic) UILabel *cellName;
@property (nonatomic, assign) NSInteger totalRow;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation AJKListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.selectedBackgroundView.backgroundColor = [UIColor lightGrayColor];
        self.cellName = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth - 15, 44)];
        [self.contentView addSubview:self.cellName];
    }
    return self;
}

#pragma mark - configData
- (void)configWithData:(NSDictionary *)dic
{
    self.cellName.text = dic[@"title"];
    self.cellName.font = [UIFont ajkH2Font];
}

#pragma mark - 划cell线
- (UIView *)topLineView
{
    if (!_topLineView) {
        _topLineView = [[BrokerLineView alloc] init];
        _topLineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _topLineView;
}

- (UIView *)bottomLineView
{
    if (!_bottomLineView) {
        _bottomLineView = [[BrokerLineView alloc] init];
        _bottomLineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _bottomLineView;
}

- (UIView *)shortLineView
{
    if (!_shortLineView) {
        _shortLineView = [[BrokerLineView alloc] init];
        _shortLineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _shortLineView;
}

- (void)didSelected:(BOOL)selected
{
    self.accessoryType = selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

- (void)drawLineWithIndexPath:(NSIndexPath *)indexPath sectionTotalRow:(NSInteger)totalRow
{
    self.indexPath = indexPath;
    self.totalRow = totalRow;
    if (indexPath.row == 0 && totalRow != 1) {
        [self.contentView addSubview:self.topLineView];
    } else if(indexPath.row == 0 && totalRow == 1){
        [self.contentView addSubview:self.topLineView];
        [self.contentView addSubview:self.bottomLineView];
    }
    [self.contentView addSubview:self.shortLineView ];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.topLineView.superview) {
        self.topLineView.frame = CGRectMake(0, 0, 320, 0.5);
    }
    
    if (self.bottomLineView.superview) {
        self.bottomLineView.frame = CGRectMake(0, 44, 320, 0.5);    }
    
    if (self.shortLineView.superview) {
        self.shortLineView.frame = CGRectMake(15, 0, ScreenWidth - 15, 0.5);    }
    
}

@end