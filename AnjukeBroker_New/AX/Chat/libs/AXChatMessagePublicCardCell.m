//
//  AJKChatMessagePublicCardCell.m
//  X
//
//  Created by 杨 志豪 on 2/13/14.
//  Copyright (c) 2014 williamYang. All rights reserved.
//

#import "AXChatMessagePublicCardCell.h"
#import "AXChatImageLoader.h"


@interface AXChatMessagePublicCardCell ()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *dateLable;
@property (nonatomic, strong) UILabel *descLable;
@property (nonatomic, strong) UILabel *moreLable;
@property (nonatomic, strong) UIImageView *cardImageView;
@property (nonatomic, strong) NSDictionary *dataDict;
@property (nonatomic, strong) UIImageView *iconView;
@end

@implementation AXChatMessagePublicCardCell

static CGFloat const AXChatPublicCardMarginLeft = 10;

#pragma mark - setters and getters
- (UIView *)cardBgView
{
    if (!_cardBgView) {
        _cardBgView = [[UIView alloc] initWithFrame:CGRectZero];
        _cardBgView.backgroundColor = [UIColor whiteColor];
        _cardBgView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _cardBgView.layer.borderWidth = 1;
        _cardBgView.layer.masksToBounds = YES;
        _cardBgView.layer.cornerRadius = 6;
        [self.contentView addSubview:_cardBgView];
    }
    return _cardBgView;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 253, 270, 1)];
        _lineView.backgroundColor = [UIColor colorWithHex:0xcccccc alpha:1];
        [self.cardBgView addSubview:_lineView];
    }
    return _lineView;
}

- (UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(AXChatPublicCardMarginLeft, 20, 270, 20)];
        _titleLable.font = [UIFont boldSystemFontOfSize:16];
        _titleLable.textColor = [UIColor colorWithHex:0x000000 alpha:1];
        _titleLable.backgroundColor = [UIColor clearColor];
        [self.cardBgView addSubview:_titleLable];
    }
    return _titleLable;
}

- (UILabel *)dateLable
{
    if (!_dateLable) {
        _dateLable = [[UILabel alloc] initWithFrame:CGRectMake(AXChatPublicCardMarginLeft, 45, 200, 20)];
        _dateLable.font = [UIFont systemFontOfSize:12];
        _dateLable.textColor = [UIColor blackColor];
        _dateLable.backgroundColor = [UIColor clearColor];
        [self.cardBgView addSubview:_dateLable];
    }
    return _dateLable;
}

- (UILabel *)descLable
{
    if (!_descLable) {
        _descLable = [[UILabel alloc] initWithFrame:CGRectMake(AXChatPublicCardMarginLeft, 210, 270, 40)];
        _descLable.font = [UIFont systemFontOfSize:14];
        _descLable.textColor = [UIColor colorWithHex:0x777777 alpha:1];
        _descLable.backgroundColor = [UIColor clearColor];
        _descLable.numberOfLines = 2;
        [self.cardBgView addSubview:_descLable];
    }
    return _descLable;
}

- (UILabel *)moreLable
{
    if (!_moreLable) {
        _moreLable = [[UILabel alloc] initWithFrame:CGRectMake(AXChatPublicCardMarginLeft, 262, 200, 20)];
        _moreLable.font = [UIFont systemFontOfSize:14];
        _moreLable.textColor = [UIColor colorWithHex:0x000000 alpha:1];
        _moreLable.backgroundColor = [UIColor clearColor];
        _moreLable.text = @"查看详情";
        [self.cardBgView addSubview:_moreLable];
    }
    return _moreLable;
}

- (UIImageView *)cardImageView
{
    if (!_cardImageView) {
        _cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(AXChatPublicCardMarginLeft, 65, 270, 135)];
        [self.cardBgView addSubview:_cardImageView];
    }
    return _cardImageView;
}

- (UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(270, 266, 7, 11)];
        _iconView.image = [UIImage imageNamed:@"xproject_dialogue_articalcard_backicon.png"];
        [self.cardBgView addSubview:_iconView];
    }
    return _iconView;
}

#pragma mark - View Lifecycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

#pragma mark - Public Method

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (selected) {
        NSLog(@"selected");
    } else {
        NSLog(@"unselected");
    }
    [super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
    if (highlighted) {
        NSLog(@"highlighted");
        self.cardBgView.backgroundColor = [UIColor grayColor];
    } else {
        NSLog(@"unhighlighted");
        self.cardBgView.backgroundColor = [UIColor whiteColor];
    }
    [super setHighlighted:highlighted animated:animated];
}

- (void)initUI
{
    [super initUI];
}

- (void)configWithData:(NSDictionary *)data
{
    [super configWithData:data];
    self.dataDict = [data[@"content"] JSONValue];
    if (!self.dataDict || ![self.dataDict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    self.cardBgView.frame = CGRectMake(15, 10, 290, 290);
    self.lineView.frame = CGRectMake(10, 253, 270, 1);

    self.dateLable.text = self.dataDict[@"date"];
    self.titleLable.text = self.dataDict[@"title"];
    self.descLable.text = self.dataDict[@"desc"];
    self.moreLable.hidden = NO;
    self.iconView.hidden = NO;
    
    self.cardImageView.image = [UIImage imageNamed:@"no_photo_list.png"];
    //开始图片下载
    NSURL *url = [NSURL URLWithString:self.dataDict[@"img"]];
    @try {
        [[AXChatImageLoader shareCenter] autoLoadImageWithURL:url toImageView:self.cardImageView];
    } @catch (NSException *exception) {
        //do nothing
    }
}


@end
