//
//  AJKChatMessageImageCell.m
//  X
//
//  Created by 杨 志豪 on 2/13/14.
//  Copyright (c) 2014 williamYang. All rights reserved.
//

#import "AXChatMessageImageCell.h"

@interface AXChatMessageImageCell ()
@property (nonatomic, strong) UIImageView *receiveImage;

@end

@implementation AXChatMessageImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)initUI {
    [super initUI];
    self.receiveImage = [[UIImageView alloc] init];
    [self.contentView addSubview:self.receiveImage];
    
}

- (void)configWithData:(NSDictionary *)data
{
    [super configWithData:data];
    CGRect frame = [AXChatMessageImageCell sizeOFImg:data[@"content"]];
    if (self.messageSource == AXChatMessageSourceDestinationIncoming) {
        frame.origin.x = kJSAvatarSize +40;
    }else {
        frame.origin.x = 320 - kJSAvatarSize - 40 - frame.size.width;
    }
    [self setBubbleIMGByImgFrame:frame];
//    self.receiveImage.frame = frame;
    self.receiveImage.image = data[@"content"];
//    self.receiveImage.backgroundColor = [UIColor yellowColor];
    
//    self.receiveImage.layer.cornerRadius = 6.0f;
//    self.receiveImage.layer.masksToBounds = YES;
//    self.receiveImage.layer.borderWidth = 3.0f;
//    self.receiveImage.layer.borderColor = [UIColor greenColor].CGColor;
    
}

- (void)setBubbleIMGByImgFrame:(CGRect) rect{
    if (self.messageSource == AXChatMessageSourceDestinationIncoming) {
        self.bubbleIMG.frame = CGRectMake(kJSAvatarSize + 10, 5, rect.size.width + 30.0f, rect.size.height + 20);
        self.receiveImage.frame = CGRectMake(kJSAvatarSize +30, 10, rect.size.width, rect.size.height);
    }else
    {
        self.bubbleIMG.frame = CGRectMake(320 - kJSAvatarSize - 20 - rect.size.width -20, 5, rect.size.width + 30.0f, rect.size.height + 20);
        self.receiveImage.frame = CGRectMake(320 - kJSAvatarSize - 20 - rect.size.width - 10, 10, rect.size.width, rect.size.height);
    }
}


#pragma mark - class method
+ (CGRect)sizeOFImg:(UIImage *)img {
    CGRect rect = CGRectMake(0.0f, 0.0f, img.size.width, img.size.height);
    
    if (rect.size.height > 240.0f) {
        rect.size.height = 240.0f;
        rect.size.width = 240.0f / rect.size.height * rect.size.width;
    }
    
    if (rect.size.width > 240.0f) {
        rect.size.width = 240.0f;
        rect.size.height = 240.0f / rect.size.width * rect.size.height;
    }
    
    rect.size.height = rect.size.height / 2.0f;
    rect.size.width = rect.size.width / 2.0f;
    return rect;
}

@end
