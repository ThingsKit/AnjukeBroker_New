//
//  AJKChatMessageRoomSourceCell.m
//  X
//
//  Created by 杨 志豪 on 2/13/14.
//  Copyright (c) 2014 williamYang. All rights reserved.
//

#import "AXChatMessageRoomSourceCell.h"

#define PROPERTYCARDHEIGHT 126.0f
#define PROPERTYCARDWIDTH 210.0f

@interface AXChatMessageRoomSourceCell ()
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *price;
@property (nonatomic, strong) UILabel *roomType;
@property (nonatomic, strong) UILabel *area;
@property (nonatomic, strong) UILabel *floor;
@property (nonatomic, strong) UIImageView *roomImage;
@property (nonatomic, strong) UIView *whiteBackGround;
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
    self.titleLable = [[UILabel alloc] init];
    self.titleLable.text = @"中原两湾城";
    self.titleLable.frame = CGRectMake(0, 0, PROPERTYCARDWIDTH, 20.0f);
    [self.whiteBackGround addSubview:self.titleLable];
    
    [self.whiteBackGround addSubview:self.titleLable];
    self.roomImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, 70, 70)];
    self.roomImage.backgroundColor = [UIColor blueColor];
    [self.whiteBackGround addSubview:self.roomImage];
    
    self.floor = [[UILabel alloc] initWithFrame:CGRectMake(80, 40, 130, 30)];
    [self.whiteBackGround addSubview:self.floor];
    

    self.price = [[UILabel alloc] initWithFrame:CGRectMake( 80, 70, 90, 30)];
    [self.whiteBackGround addSubview:self.price];
    
}
- (void)setBubbleIMGByMessageSorce {
    if (self.messageSource == AXChatMessageSourceDestinationIncoming) {
        self.bubbleIMG.frame = CGRectMake(kJSAvatarSize + 10, 5, PROPERTYCARDWIDTH + 30.0f, PROPERTYCARDHEIGHT + 20);
        self.whiteBackGround.frame = CGRectMake(kJSAvatarSize + 30, 10, PROPERTYCARDWIDTH, PROPERTYCARDHEIGHT);
    }else
    {
        self.bubbleIMG.frame = CGRectMake(320 - kJSAvatarSize - 20 - PROPERTYCARDWIDTH -20, 5, PROPERTYCARDWIDTH + 30.0f, PROPERTYCARDHEIGHT + 20);
        self.whiteBackGround.frame = CGRectMake(320 - kJSAvatarSize - 20 - PROPERTYCARDWIDTH - 10, 10, PROPERTYCARDWIDTH, PROPERTYCARDHEIGHT);
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
    self.titleLable.text = self.propDict[@"title"];
    self.floor.text = [NSString stringWithFormat:@"%@   %@", self.propDict[@"roomType"], self.propDict[@"area"]];
    self.price.text = self.propDict[@"price"];
    
}

@end
