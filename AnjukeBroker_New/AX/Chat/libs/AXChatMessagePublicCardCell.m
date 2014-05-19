//
//  AJKChatMessagePublicCardCell.m
//  X
//
//  Created by 杨 志豪 on 2/13/14.
//  Copyright (c) 2014 williamYang. All rights reserved.
//

#import "AXChatMessagePublicCardCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "RTLineView.h"
#import "BK_WebImageView.h"

@interface AXChatMessagePublicCardCell ()

@property (nonatomic, strong) RTLineView *lineView;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *dateLable;
@property (nonatomic, strong) UILabel *descLable;
@property (nonatomic, strong) UILabel *moreLable;
@property (nonatomic, strong) UIControl *cardControl;
@property (nonatomic, strong) UIImageView *cardBgImageView;
@property (nonatomic, strong) BK_WebImageView *cardImageView;
@property (nonatomic, strong) NSDictionary *dataDict;
@property (nonatomic, strong) UIImageView *iconView;
@end

@implementation AXChatMessagePublicCardCell

static CGFloat const AXChatPublicCardMarginLeft = 10;

#pragma mark - setters and getters

- (UIView *)cardBgImageView
{
    if (!_cardBgImageView) {
        _cardBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 290, 290)];
        _cardBgImageView.backgroundColor = [UIColor clearColor];
        _cardBgImageView.image = [[UIImage imageNamed:@"xproject_dialogue_articalcard.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    }
    return _cardBgImageView;
}

- (UIView *)cardBgView
{
    if (!_cardBgView) {
        _cardBgView = [[UIView alloc] initWithFrame:CGRectZero];
        _cardBgView.backgroundColor = [UIColor clearColor];
        [_cardBgView addSubview:self.cardBgImageView];
        [self.contentView addSubview:_cardBgView];
    }
    return _cardBgView;
}

- (UIControl *)cardControl
{
    if (!_cardControl) {
        _cardControl = [[UIControl alloc] init];
        _cardControl.backgroundColor = [UIColor clearColor];
        [_cardControl addTarget:self action:@selector(didClickPublicCard) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_cardControl];
    }
    return _cardControl;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[RTLineView alloc] initWithFrame:CGRectMake(10, 253, 270, 1)];
        _lineView.backgroundColor = [UIColor axChatInputBorderColor:self.isBroker];
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
        _dateLable = [[UILabel alloc] initWithFrame:CGRectMake(AXChatPublicCardMarginLeft, 40, 200, 20)];
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
        _cardImageView = [[BK_WebImageView alloc] initWithFrame:CGRectMake(AXChatPublicCardMarginLeft, 65, 270, 135)];
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
- (void)cellHighlighted:(BOOL)highlighted
{

}

- (void)initUI
{
    [super initUI];
}

- (void)configWithData:(NSDictionary *)data
{
    self.avatar.hidden = YES;
    self.avatarButton.hidden = YES;
    self.bubbleIMG.hidden = YES;
    [super configWithData:data];
    self.dataDict = [data[@"content"] JSONValue];
    if (!self.dataDict || ![self.dataDict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    self.cardBgView.frame = CGRectMake(15, 10, 290, 290);
    self.cardControl.frame = self.cardBgView.frame;
    self.lineView.frame = CGRectMake(10, 253, 270, 1);

    self.dateLable.text = self.dataDict[@"date"];
    self.titleLable.text = self.dataDict[@"title"];
    self.descLable.text = self.dataDict[@"desc"];
    self.moreLable.hidden = NO;
    self.iconView.hidden = NO;
    
    self.cardImageView.image = [UIImage imageNamed:@"no_photo_list.png"];
    //开始图片下载
    NSURL *url = [NSURL URLWithString:self.dataDict[@"img"]];
    [self.cardImageView setImageUrl:self.dataDict[@"img"]];
    [self setBubbleIMGByMessageSorce];
    
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                             action:@selector(handleLongPressGesture:)];
    [recognizer setMinimumPressDuration:0.4f];
    [self.cardControl addGestureRecognizer:recognizer];
}

- (void)setBubbleIMGByMessageSorce {
    self.bubbleIMG.frame = self.cardBgView.frame;
}

- (void)didClickPublicCard
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickPublicCardWithUrl:)]) {
        if (self.dataDict[@"url"]) {
            [self.delegate didClickPublicCardWithUrl:self.dataDict[@"url"]];
        }
    }
}

@end
