//
//  AJKChatMessageRoomSourceCell.m
//  X
//
//  Created by 杨 志豪 on 2/13/14.
//  Copyright (c) 2014 williamYang. All rights reserved.
//

#import "AXChatMessageRoomSourceCell.h"
#import "AXChatImageLoader.h"

static CGFloat const AXPropertyCardHeight = 105.0f;
static CGFloat const AXPropertyCardWidth = 220.0f;

static CGFloat const AXPropertyCardInImgMarginLeft = 9.0f;
static CGFloat const AXPropertyCardInLableMarginLeft = 81.0f;

static CGFloat const AXPropertyCardOutImgMarginLeft = 22.0f;
static CGFloat const AXPropertyCardOutLableMarginLeft = 94.0f;

@interface AXChatMessageRoomSourceCell ()
@property (nonatomic, strong) UILabel *tagLable;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *priceLable;
@property (nonatomic, strong) UILabel *roomTypeLabel;
@property (nonatomic, strong) UIImageView *roomImage;
@property (nonatomic, strong) UIView *whiteBackGround;
@property (nonatomic, strong) UIView *tagLineView;
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
    
    self.tagLable = [[UILabel alloc] init];
    self.tagLable.text = @"";
    self.tagLable.textColor = [UIColor axChatPropTagColor:self.isBroker];
    self.tagLable.font = [UIFont axChatPropTagFont:self.isBroker];
    self.tagLable.frame = CGRectMake(20, 7, AXPropertyCardWidth - 40, 20.0f);
    [self.whiteBackGround addSubview:self.tagLable];
    
    self.tagLineView = [[UIView alloc] initWithFrame:CGRectMake(20, 28, AXPropertyCardWidth - 30, 1)];
    self.tagLineView.backgroundColor = [UIColor axChatInputBorderColor:self.isBroker];
    [self.whiteBackGround addSubview:self.tagLineView];
    
    self.roomImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 37, 60, 60)];
    self.roomImage.backgroundColor = [UIColor blueColor];
    [self.whiteBackGround addSubview:self.roomImage];
    
    self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(92, 30, 120, 30)];
    self.titleLable.textColor = [UIColor blackColor];
    self.titleLable.font = [UIFont axChatPropDetailTimeFont:self.isBroker];
    [self.whiteBackGround addSubview:self.titleLable];
    
    self.roomTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(92, 30 + 20, 120, 30)];
    self.roomTypeLabel.textColor = [UIColor blackColor];
    self.roomTypeLabel.font = [UIFont axChatPropDetailTimeFont:self.isBroker];
    [self.whiteBackGround addSubview:self.roomTypeLabel];
    
    self.priceLable = [[UILabel alloc] initWithFrame:CGRectMake(92, 30 + 20 + 20, 120, 30)];
    self.priceLable.textColor = [UIColor blackColor];
    self.priceLable.font = [UIFont axChatPropDetailTimeFont:self.isBroker];
    [self.whiteBackGround addSubview:self.priceLable];
    
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
}

- (void)configWithData:(NSDictionary *)data
{
    [super configWithData:data];
    self.propDict = [data[@"content"] JSONValue];
    if ([data[@"messageSource"] isEqualToNumber:[NSNumber numberWithInteger:AXChatMessageSourceDestinationOutPut]]) {
        self.messageSource = AXChatMessageSourceDestinationOutPut;
    }else {
        self.messageSource = AXChatMessageSourceDestinationIncoming;
    }

    [self setBubbleIMGByMessageSorce];
    if ([self.propDict[@"tradeType"] isEqualToNumber:[NSNumber numberWithInteger:AXMessagePropertySourceErShouFang]]) {
        self.tagLable.text = @"二手房";
    }
    
    self.titleLable.text = self.propDict[@"name"];
    self.roomTypeLabel.text = self.propDict[@"des"];
    self.priceLable.text = self.propDict[@"price"];
    NSURL *url = [NSURL URLWithString:self.propDict[@"img"]];
    @try {
        [[AXChatImageLoader shareCenter] autoLoadImageWithURL:url toImageView:self.roomImage];
    } @catch (NSException *exception) {
        //do nothing
    }
}

- (void)setBubbleIMGOutcomeIncome {
    if (self.messageSource == AXChatMessageSourceDestinationIncoming) {
        self.bubbleIMG.image = [[UIImage axInChatPropBubbleBg:self.isBroker highlighted:NO] stretchableImageWithLeftCapWidth:40/2 topCapHeight:30/2];
    }else{
        self.bubbleIMG.image = [[UIImage axOutChatPropBubbleBg:self.isBroker highlighted:NO] stretchableImageWithLeftCapWidth:40/2 topCapHeight:30.0f / 2.0f];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
    if (self.messageSource == AXChatMessageSourceDestinationIncoming) {
        if (self.messageType == AXMessageTypeText) {
            self.bubbleIMG.image = [[UIImage axInChatPropBubbleBg:self.isBroker highlighted:highlighted] stretchableImageWithLeftCapWidth:40/2 topCapHeight:30.0f / 2.0f];
        }
    } else {
        self.bubbleIMG.image = [[UIImage axOutChatPropBubbleBg:self.isBroker highlighted:highlighted] stretchableImageWithLeftCapWidth:40/2 topCapHeight:30.0f / 2.0f];
    }
}

@end
