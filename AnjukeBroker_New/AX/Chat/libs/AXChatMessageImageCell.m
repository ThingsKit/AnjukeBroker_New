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
    
    self.receiveImage.layer.cornerRadius = 8.0f;
    self.receiveImage.layer.masksToBounds = YES;
//    self.receiveImage.layer.borderWidth = 3.0f;
//    self.receiveImage.layer.borderColor = [UIColor greenColor].CGColor;
    
}

- (void)setBubbleIMGByImgFrame:(CGRect) rect{
    if (self.messageSource == AXChatMessageSourceDestinationIncoming) {
        self.receiveImage.frame = CGRectMake(kJSAvatarSize +30, 20, rect.size.width, rect.size.height);
        self.bubbleIMG.frame = CGRectMake(self.receiveImage.frame.origin.x - 8.0f, 19.0f, rect.size.width + 10.0f, rect.size.height + 2.0f);
        
    }else
    {
        self.receiveImage.frame = CGRectMake(320.0f - kJSAvatarSize - 20.0f - rect.size.width - 4.0f, 20.0f, rect.size.width, rect.size.height);
        self.bubbleIMG.frame = CGRectMake(self.receiveImage.frame.origin.x - 1, 19.0f, rect.size.width + 3.0f + 5.0f , rect.size.height + 2.0f);
        
    }
}


#pragma mark - class method
+ (CGRect)sizeOFImg:(UIImage *)img {
    CGRect rect = CGRectMake(0.0f, 0.0f, img.size.width, img.size.height);
    CGRect tempRect = rect;
    if (tempRect.size.height >= tempRect.size.width) {
        rect.size.height = 240.0f;
        rect.size.width = 240.0f / tempRect.size.height * tempRect.size.width;
        rect.size.height = rect.size.height / 2.0f;
        rect.size.width = rect.size.width / 2.0f;
        return rect;
    }
    
    if (tempRect.size.width > tempRect.size.height) {
        rect.size.width = 240.0f;
        rect.size.height = 240.0f / tempRect.size.width * tempRect.size.height;
        rect.size.height = rect.size.height / 2.0f;
        rect.size.width = rect.size.width / 2.0f;
        return rect;
    }
    
    return rect;
}

@end
