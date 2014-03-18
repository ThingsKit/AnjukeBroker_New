//
//  AJKChatMessageRoomSourceCell.m
//  X
//
//  Created by 杨 志豪 on 2/13/14.
//  Copyright (c) 2014 williamYang. All rights reserved.
//

#import "AXChatMessageRoomSourceCell.h"
#import "RTLineView.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

static CGFloat const AXPropertyCardHeight = 105.0f;
static CGFloat const AXPropertyCardWidth = 220.0f;

static CGFloat const AXPropertyCardInImgMarginLeft = 9.0f;
static CGFloat const AXPropertyCardInLableMarginLeft = 81.0f;

//static CGFloat const AXPropertyCardOutImgMarginLeft = 22.0f;
//static CGFloat const AXPropertyCardOutLableMarginLeft = 94.0f;

@interface AXChatMessageRoomSourceCell ()
@property (nonatomic, strong) UILabel *tagLable;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *priceLable;
@property (nonatomic, strong) UILabel *roomTypeLabel;
@property (nonatomic, strong) UIControl *propControl;
@property (nonatomic, strong) UIImageView *roomImage;
@property (nonatomic, strong) UIView *whiteBackGround;
@property (nonatomic, strong) RTLineView *tagLineView;
@property (nonatomic, strong) NSDictionary *propDict;
@end

@implementation AXChatMessageRoomSourceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)initUI {
    [super initUI];
    
    self.whiteBackGround = [[UIView alloc] init];
    self.whiteBackGround.backgroundColor = [UIColor clearColor];
    self.whiteBackGround.layer.cornerRadius = 6.0f;
    self.whiteBackGround.layer.masksToBounds = YES;
    [self.contentView addSubview:self.whiteBackGround];
    
    self.propControl = [[UIControl alloc] init];
    self.propControl.backgroundColor = [UIColor clearColor];
    [self.propControl addTarget:self action:@selector(didClickProperty) forControlEvents:UIControlEventTouchUpInside];
    
    self.tagLable = [[UILabel alloc] init];
    self.tagLable.text = @"";
    self.tagLable.textColor = [UIColor axChatPropTagColor:self.isBroker];
    self.tagLable.font = [UIFont axChatPropTagFont:self.isBroker];
    self.tagLable.frame = CGRectMake(20, 7, AXPropertyCardWidth - 40, 20.0f);
    self.tagLable.backgroundColor = [UIColor clearColor];
    [self.whiteBackGround addSubview:self.tagLable];
    
    self.tagLineView = [[RTLineView alloc] initWithFrame:CGRectMake(20, 28, AXPropertyCardWidth - 30, 1)];
    self.tagLineView.backgroundColor = [UIColor axChatInputBorderColor:self.isBroker];
    [self.whiteBackGround addSubview:self.tagLineView];
    
    self.roomImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 37, 60, 60)];
    self.roomImage.backgroundColor = [UIColor clearColor];
    [self.whiteBackGround addSubview:self.roomImage];
    
    self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(92, 30, 120, 30)];
    self.titleLable.textColor = [UIColor blackColor];
    self.titleLable.font = [UIFont axChatPropDetailTimeFont:self.isBroker];
    self.titleLable.backgroundColor = [UIColor clearColor];
    [self.whiteBackGround addSubview:self.titleLable];
    
    self.roomTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(92, 30 + 22, 120, 30)];
    self.roomTypeLabel.textColor = [UIColor axChatPropDescColor:self.isBroker];
    self.roomTypeLabel.font = [UIFont axChatPropDetailTimeFont:self.isBroker];
    self.roomTypeLabel.backgroundColor = [UIColor clearColor];
    [self.whiteBackGround addSubview:self.roomTypeLabel];
    
    self.priceLable = [[UILabel alloc] initWithFrame:CGRectMake(92, 30 + 22 + 22, 120, 30)];
    self.priceLable.textColor = [UIColor blackColor];
    self.priceLable.font = [UIFont axChatPropDetailTimeFont:self.isBroker];
    self.priceLable.backgroundColor = [UIColor clearColor];
    [self.whiteBackGround addSubview:self.priceLable];
    
    [self.contentView addSubview:self.propControl];
}

- (void)setBubbleIMGByMessageSorce {
    if (self.messageSource == AXChatMessageSourceDestinationIncoming) {
        self.bubbleIMG.frame = CGRectMake(kJSAvatarSize + 10 + 12, axTagMarginTop, AXPropertyCardWidth, AXPropertyCardHeight);
        self.whiteBackGround.frame = CGRectMake(kJSAvatarSize + 30, axTagMarginTop, AXPropertyCardWidth, AXPropertyCardHeight);
        self.tagLable.left = AXPropertyCardInImgMarginLeft;
        self.tagLineView.left = AXPropertyCardInImgMarginLeft;
        self.roomImage.left = AXPropertyCardInImgMarginLeft;
        self.titleLable.left = AXPropertyCardInLableMarginLeft;
        self.roomTypeLabel.left = AXPropertyCardInLableMarginLeft;
        self.priceLable.left = AXPropertyCardInLableMarginLeft;
    } else {
        self.bubbleIMG.frame = CGRectMake(320 - kJSAvatarSize - 20 - AXPropertyCardWidth, axTagMarginTop, AXPropertyCardWidth, AXPropertyCardHeight);
        self.whiteBackGround.frame = CGRectMake(320 - kJSAvatarSize - 20 - AXPropertyCardWidth - 10, axTagMarginTop, AXPropertyCardWidth, AXPropertyCardHeight);
        self.tagLable.left = 22;
        self.tagLineView.left = 22;
        self.roomImage.left = 22;
        self.titleLable.left = 94;
        self.roomTypeLabel.left = 94;
        self.priceLable.left = 94;
    }
    self.propControl.frame = self.bubbleIMG.frame;
}

- (void)configWithData:(NSDictionary *)data
{
    [super configWithData:data];
    self.propDict = [data[@"content"] JSONValue];
    if ([data[@"messageSource"] isEqualToNumber:@(AXChatMessageSourceDestinationOutPut)]) {
        self.messageSource = AXChatMessageSourceDestinationOutPut;
    }else {
        self.messageSource = AXChatMessageSourceDestinationIncoming;
    }

    [self setBubbleIMGByMessageSorce];
    if ([self.propDict[@"tradeType"] isEqualToNumber:@(AXMessagePropertySourceErShouFang)]) {
        self.tagLable.text = @"二手房";
    } else {
        self.tagLable.text = @"租房";
    }
    
    self.titleLable.text = self.propDict[@"name"];
    self.roomTypeLabel.text = self.propDict[@"des"];
    self.priceLable.text = self.propDict[@"price"];
    NSURL *url = [NSURL URLWithString:self.propDict[@"img"]];
    [self.roomImage setImageWithURL:url placeholderImage:nil];
    [self configWithStatus];
}

- (void)setBubbleIMGOutcomeIncome {
    if (self.messageSource == AXChatMessageSourceDestinationIncoming) {
        self.bubbleIMG.image = [[UIImage axInChatPropBubbleBg:self.isBroker highlighted:NO] stretchableImageWithLeftCapWidth:40/2 topCapHeight:30/2];
    }else{
        if (self.isBroker) {
            self.bubbleIMG.image = [[UIImage axOutChatPropBubbleBg:self.isBroker highlighted:NO] stretchableImageWithLeftCapWidth:40/2 topCapHeight:30.0f / 2.0f];
        } else {
            self.bubbleIMG.image = [[UIImage axOutChatPropBubbleBg:self.isBroker highlighted:NO] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
        }
    }
}

- (void)cellHighlighted:(BOOL)highlighted
{
    if (self.messageSource == AXChatMessageSourceDestinationIncoming) {
        self.bubbleIMG.image = [[UIImage axInChatPropBubbleBg:self.isBroker highlighted:highlighted] stretchableImageWithLeftCapWidth:40/2 topCapHeight:30.0f / 2.0f];
    } else {
        if (self.isBroker) {
            self.bubbleIMG.image = [[UIImage axOutChatPropBubbleBg:self.isBroker highlighted:highlighted] stretchableImageWithLeftCapWidth:40/2 topCapHeight:30.0f / 2.0f];
        } else {
            self.bubbleIMG.image = [[UIImage axOutChatPropBubbleBg:self.isBroker highlighted:highlighted] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
        }
    }
}

- (void)didClickProperty
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickPropertyWithUrl:withTitle:)]) {
        if (self.propDict[@"url"]) {
            [self.delegate didClickPropertyWithUrl:self.propDict[@"url"] withTitle:self.propDict[@"name"]];
        }
    }
}

@end
