//
//  MultipleChoiceAndEditListCell.m
//  AnjukeBroker_New
//
//  Created by xubing on 14-7-1.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "MultipleChoiceAndEditListCell.h"
#import "PropertyDetailCellModel.h"
#import "UIImageView+WebCache.h"
#import "UIViewExt.h"

#define GAP_H 4
#define GAP_V 5

@interface MultipleChoiceAndEditListCell ()

//cell配置
@property (nonatomic, strong) UIImageView* selectImage;
@property (nonatomic, strong) UIButton *selectStylebutton;
@property (nonatomic, strong) UIImageView* propertyIcon; //房源图片
@property (nonatomic, strong) UILabel* propertyTitle; //房源标题
@property (nonatomic, strong) UILabel* community; //小区名称
@property (nonatomic, strong) UILabel* houseType; //户型
@property (nonatomic, strong) UILabel* area; //面积
@property (nonatomic, strong) UILabel* price; //售价
@property (nonatomic, strong) NSString *propertyId;//房源Id
@property (nonatomic, strong) UIImageView* multiPictureIcon; //多图图标
@property (nonatomic, strong) UIImageView* violationIcon; //违规图标
@property (nonatomic, strong) UIImageView* mobileIcon; //手机发图图标
@property (nonatomic) int propTitleLength;

//cell画线
@property (strong, nonatomic) UIView *shortLineView;
@property (strong, nonatomic) BrokerLineView *lineView;

@property (nonatomic)BOOL isSelected;

@end

@implementation MultipleChoiceAndEditListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier containingTableView:containingTableView leftUtilityButtons:leftUtilityButtons rightUtilityButtons:rightUtilityButtons];
    
    if (self) {
//        self.frame = CGRectMake(0, 0, ScreenWidth, 90);
        [self initCell];
        self.isSelected = false;
    }
    return self;
}

#pragma mark UI相关
- (void)initCell {
    
    UIButton *selectStylebutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56, 90)];
    UIImageView *imageView      = [[UIImageView alloc] initWithFrame:CGRectMake((56 - 22)/2 , (90 - 22)/2 , 22, 22)];
    imageView.image             = [UIImage imageNamed:@"broker_property_control_select_gray"];
    [selectStylebutton addTarget:self action:@selector(propChoiceTap:) forControlEvents:UIControlEventTouchUpInside];
    [selectStylebutton addSubview:imageView];
    [self addSubview:selectStylebutton];
    self.selectImage       = imageView;
    self.selectStylebutton = selectStylebutton;
    
    self.shortLineView = [[BrokerLineView alloc] initWithFrame:CGRectMake(56, 89.5, ScreenWidth - 56, 0.5)];
    self.shortLineView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.shortLineView];
    
    //房源图像
    _propertyIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    _propertyIcon.backgroundColor = [UIColor clearColor];
//    _propertyIcon.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_propertyIcon];
//    [self.contentView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    
    //房源标题
    _propertyTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    _propertyTitle.backgroundColor = [UIColor clearColor];
    _propertyTitle.font = [UIFont ajkH2Font];
    [_propertyTitle setTextColor:[UIColor brokerBlackColor]];
    [self.contentView addSubview:_propertyTitle];
    
    
    //违规,多图,手机
    _violationIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_violationIcon];
    
    _multiPictureIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_multiPictureIcon];
    
    _mobileIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_mobileIcon];
    
    //小区名称
    _community = [[UILabel alloc] initWithFrame:CGRectZero];
    _community.backgroundColor = [UIColor clearColor];
    _community.font = [UIFont ajkH4Font];
    _community.textColor = [UIColor brokerLightGrayColor];
    [self.contentView addSubview:_community];
    
    //户型
    _houseType = [[UILabel alloc] initWithFrame:CGRectZero];
    _houseType.backgroundColor = [UIColor clearColor];
    _houseType.font = [UIFont ajkH4Font];
    [_houseType setTextColor:[UIColor brokerLightGrayColor]];
    [self.contentView addSubview:_houseType];
    
    //面积
    if (!self.isHaozu) {
        _area = [[UILabel alloc] initWithFrame:CGRectZero];
        _area.backgroundColor = [UIColor clearColor];
        _area.font = [UIFont ajkH4Font];
        _area.textColor = [UIColor brokerLightGrayColor];
        [self.contentView addSubview:_area];
    }
    
    //租金或售价
    _price = [[UILabel alloc] initWithFrame:CGRectZero];
    _price.backgroundColor = [UIColor clearColor];
    _price.font = [UIFont ajkH4Font];
    [_price setTextColor:[UIColor brokerLightGrayColor]];
    [self.contentView addSubview:_price];
    
    //cell的背景视图, 默认选中是蓝色
    //    UIView* backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    //    backgroundView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
    //    self.selectedBackgroundView = backgroundView;
    
    self.contentView.backgroundColor = [UIColor brokerWhiteColor];
    
    [self.cellScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)dealloc
{
    [self.cellScrollView removeObserver:self forKeyPath:@"contentOffset"];
}

//cell下划线
- (void)showBottonLineWithCellHeight:(CGFloat)cellH andOffsetX:(CGFloat)offsetX {
    if (self.lineView == nil) {
        self.lineView = [[BrokerLineView alloc] initWithFrame:CGRectMake(offsetX, cellH -0.5, 320 - offsetX, 0.5)];
        [self.contentView addSubview:self.lineView];
    }
    else {
        self.lineView.frame = CGRectMake(offsetX, cellH -0.5, 320 - offsetX, 0.5);
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGRect frame = self.selectStylebutton.frame;
    self.selectStylebutton.frame = CGRectMake(- self.cellScrollView.contentOffset.x , 0, frame.size.width, frame.size.height);
    
}

////send log
//- (void)sendLeftDeleteLogAndPropId:(NSString *)propId
//{
//    if (self.isHaozu) {
//        [[BrokerLogger sharedInstance] logWithActionCode:ZF_DT_LIST_LEFT_DELETE page:ZF_DT_LIST_PAGE note:@{@"ot":[Util_TEXT logTime], @"propId":propId}];
//    } else {
//        [[BrokerLogger sharedInstance] logWithActionCode:ESF_DT_LIST_LEFT_DELETE page:ESF_DT_LIST_PAGE note:@{@"ot":[Util_TEXT logTime], @"propId":propId}];
//    }
//}


#pragma mark - selectCellStyle
- (void)propChoiceTap:(id)tapGR
{
    if (!self.isSelected) {
        [self cellSelected];
    } else {
        [self cellUnSelected];
    }
    [self.cellSelectstatusDelegate cellStatusChanged:self.isSelected atRowIndex:self.rowIndex];
    
}

- (void)changeCellSelectStatus:(BOOL)isSelected
{
    if (isSelected) {
        [self cellSelected];
    } else {
        [self cellUnSelected];
    }

}

- (void)cellSelected
{
    self.isSelected = true;
    [self.selectImage setImage:[UIImage imageNamed:@"broker_property_control_selected"]];
}

- (void)cellUnSelected
{
    self.isSelected = false;
    [self.selectImage setImage:[UIImage imageNamed:@"broker_property_control_select_gray"]];
}


#pragma mark - layout
//加载数据
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //注意：图标显示逻辑
    //如果“违规”存在，则不显示“多图”和“手机”图标
    //如果违规不存在，多图存在，则多图靠最右边显示；手机存在，则手机在多图的左边，靠近房源标题显示
    //房源标题的长短：首先判断是否违规，然后判断手机是否存在
    //房源图片
    _propertyIcon.frame = CGRectMake(56, 15, 80, 60);
    NSString* iconPath = self.propertyDetailTableViewCellModel.imgUrl;
    if (iconPath != nil && ![@"" isEqualToString:iconPath]) {
        //加载图片
        [_propertyIcon setImageWithURL:[NSURL URLWithString:iconPath] placeholderImage:[UIImage imageNamed:@"anjuke61_bg4"]];
    }else{
        _propertyIcon.image = [UIImage imageNamed:@"anjuke61_bg4"]; //默认图片
    }
    
    //违规
    if ([@"0" isEqualToString:self.propertyDetailTableViewCellModel.isVisible]) {
        DLog(@"违规存在");
        
        _violationIcon.frame = CGRectMake(0, 16, 17, 17);
        _violationIcon.right = 320 - 15;
        _violationIcon.left = _violationIcon.right - 17;
        _violationIcon.image = [UIImage imageNamed:@"broker_property_icon_wg"];
        _violationIcon.hidden = NO;
        
    } else {
        _violationIcon.width = 0;
        _violationIcon.hidden = YES;
    }

    //多图
    if (_violationIcon.hidden == YES) {
        DLog(@"违规不存在");
        if ([@"1" isEqualToString:self.propertyDetailTableViewCellModel.isMoreImg]) {
            DLog(@"多图存在");
            _multiPictureIcon.frame = CGRectMake(0, 16, 17, 17);
            _multiPictureIcon.right = 320 - 15;
            _multiPictureIcon.left = _multiPictureIcon.right -17;
            _multiPictureIcon.hidden = NO;
            _multiPictureIcon.image = [UIImage imageNamed:@"broker_property_icon_pic"];
        } else {
            _multiPictureIcon.width = 0;
            _multiPictureIcon.hidden = YES;
        }
        //手机
        if ([@"1" isEqualToString:self.propertyDetailTableViewCellModel.isPhonePub]) {
            DLog(@"手机存在");
            
            _mobileIcon.frame = CGRectMake(0, 16, 17, 17);
            if (_multiPictureIcon.hidden == YES) {
                _mobileIcon.right = 320 - 15;
            } else {
                _mobileIcon.right = 320 - 15 - (17 + 2);
            }
            _mobileIcon.left = _mobileIcon.right - 17;
            _mobileIcon.image = [UIImage imageNamed:@"broker_property_icon_tel"];
            _mobileIcon.hidden = NO;
            
        } else {
            _mobileIcon.width = 0;
            _mobileIcon.hidden = YES;
        }
    }
    
    //房源标题
    if (_violationIcon.hidden == NO) {
        self.propTitleLength = _violationIcon.left - 2 - (_propertyIcon.right + 12);
    } else if (_mobileIcon.hidden == NO){
        self.propTitleLength = _mobileIcon.left - 2 - (_propertyIcon.right + 12);
    } else if (_multiPictureIcon.hidden == NO){
        self.propTitleLength = _multiPictureIcon.left - 2  - (_propertyIcon.right + 12);
    } else {
        self.propTitleLength = 320 - 15 - (_propertyIcon.right + 12);
    }
    
    _propertyTitle.frame = CGRectMake(56 + 80 + 12, 15, self.propTitleLength, 20);
    _propertyTitle.text = self.propertyDetailTableViewCellModel.title;
    
    if (_violationIcon.hidden == NO) {
        _propertyTitle.right = _violationIcon.left - 2;
    } else if (_mobileIcon.hidden == NO) {
        _propertyTitle.right = _mobileIcon.left - 2;
    } else if (_multiPictureIcon.hidden == NO){
        _propertyTitle.right = _multiPictureIcon.left - 2;
    } else {
        _propertyTitle.right = 320 - 15;
    }
    
    _propertyTitle.left =_propertyIcon.right + 12;
//    _propertyTitle.backgroundColor = [UIColor redColor];
    
    
    //小区名称
    _community.frame = CGRectMake(_propertyIcon.right + 12, _propertyTitle.bottom + GAP_V, 100, 16);
    _community.text = self.propertyDetailTableViewCellModel.commName;
    //    _community.backgroundColor = [UIColor redColor];
    //    [_community sizeToFit];
    
    
    //房源ID
    _propertyId = self.propertyDetailTableViewCellModel.propertyId;
    
    //户型
    _houseType.frame = CGRectMake(_propertyIcon.right + 12, _community.bottom + GAP_V, 100, 20);
    _houseType.text = [NSString stringWithFormat:@"%@室%@厅", self.propertyDetailTableViewCellModel.roomNum, self.propertyDetailTableViewCellModel.hallNum];
    [_houseType sizeToFit];
    
    
    //面积
    if (!self.isHaozu) {
        NSString *area = self.propertyDetailTableViewCellModel.area;
        NSRange range = [area rangeOfString:@".00"];
        area = range.location == INT32_MAX ? area : [area substringToIndex:range.location];
        _area.frame = CGRectMake(_houseType.right + GAP_H, _community.bottom + GAP_V, 50, 20);
        _area.text = [NSString stringWithFormat:@"%@平",area];
        [_area sizeToFit];
    } else {
        _area.width = 0;
    }
    
    //租金或售价
    NSString *price = self.propertyDetailTableViewCellModel.price;
    if (!self.isHaozu) {
        _price.frame = CGRectMake(_area.right + GAP_H, _community.bottom + GAP_V - 1, 70, 20);
    } else {
        _price.frame = CGRectMake(_houseType.right + GAP_H, _community.bottom + GAP_V - 1, 70, 20);
    }
    
    _price.textAlignment = NSTextAlignmentRight;
    _price.text = [NSString stringWithFormat:@"%@%@",price,self.propertyDetailTableViewCellModel.priceUnit];
    [_price sizeToFit];
    //    _price.backgroundColor = [UIColor redColor];
    
}

@end
