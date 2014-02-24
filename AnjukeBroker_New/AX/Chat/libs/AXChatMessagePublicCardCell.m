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
@property (nonatomic, strong) UILabel *descLable;
@property (nonatomic, strong) UILabel *moreLable;
@property (nonatomic, strong) UIImageView *cardImageView;
@property (nonatomic, strong) NSDictionary *dataDict;

@end

@implementation AXChatMessagePublicCardCell

//static NSInteger const AXChatPublicCardImageTag = 300;

#pragma mark - setters and getters
- (UIView *)cardBgView
{
    if (!_cardBgView) {
        _cardBgView = [[UIView alloc] initWithFrame:CGRectZero];
        _cardBgView.backgroundColor = [UIColor greenColor];
        _cardBgView.layer.borderColor = [[UIColor blackColor] CGColor];
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
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _titleLable.backgroundColor = [UIColor blackColor];
        [self.cardBgView addSubview:_lineView];
    }
    return _lineView;
}

- (UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 200, 20)];
        _titleLable.font = [UIFont boldSystemFontOfSize:16];
        _titleLable.textColor = [UIColor blackColor];
        _titleLable.backgroundColor = [UIColor blueColor];
        [self.cardBgView addSubview:_titleLable];
    }
    return _titleLable;
}

- (UILabel *)descLable
{
    if (!_descLable) {
        _descLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 140, 200, 20)];
        _descLable.font = [UIFont systemFontOfSize:14];
        _descLable.textColor = [UIColor blackColor];
        _descLable.backgroundColor = [UIColor redColor];
        [self.cardBgView addSubview:_descLable];
    }
    return _descLable;
}

- (UILabel *)moreLable
{
    if (!_moreLable) {
        _moreLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 165, 200, 20)];
        _moreLable.font = [UIFont systemFontOfSize:14];
        _moreLable.textColor = [UIColor blackColor];
        _moreLable.backgroundColor = [UIColor yellowColor];
        _moreLable.text = @"查看详情";
        [self.cardBgView addSubview:_moreLable];
    }
    return _moreLable;
}

- (UIImageView *)cardImageView
{
    if (!_cardImageView) {
        _cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 30, 200, 100)];
        [self.cardBgView addSubview:_cardImageView];
    }
    return _cardImageView;
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
        self.cardBgView.backgroundColor = [UIColor redColor];
    } else {
        NSLog(@"unhighlighted");
        self.cardBgView.backgroundColor = [UIColor greenColor];
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
    
    if (self.messageSource == AXChatMessageSourceDestinationIncoming) {
        self.cardBgView.frame = CGRectMake(10, 10, 210, 190);
    } else {
        self.cardBgView.frame = CGRectMake(10, 10, 210, 190);
    }
    
    self.titleLable.text = self.dataDict[@"title"];
    self.descLable.text = self.dataDict[@"desc"];
    self.moreLable.hidden = NO;
    
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
