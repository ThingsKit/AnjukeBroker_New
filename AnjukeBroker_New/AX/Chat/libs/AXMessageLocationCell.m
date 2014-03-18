//
//  AXMessageLocationCell.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 3/18/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import "AXMessageLocationCell.h"

@implementation AXMessageLocationCell

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
    
    self.mapIMGView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.mapIMGView];
    
    self.locationLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.locationLabel];

}
- (void)configWithData:(NSDictionary *)data
{
    [super configWithData:data];
    
    CGRect frame = CGRectMake(0, 0, 100, 70);
    
    if (self.messageSource == AXChatMessageSourceDestinationIncoming) {
        frame.origin.x = kJSAvatarSize +40;
    }else {
        frame.origin.x = 320 - kJSAvatarSize - 40 - frame.size.width;
    }
    
    [self setBubbleIMGByImgFrame:frame];
    
    self.mapIMGView.image = [UIImage imageNamed:@"local.png"];
    self.mapIMGView.layer.cornerRadius = 6.0f;
    self.mapIMGView.layer.masksToBounds = YES;
    [self configWithStatus];
}

- (void)setBubbleIMGByImgFrame:(CGRect) rect{
    if (self.messageSource == AXChatMessageSourceDestinationIncoming) {
        
        self.mapIMGView.frame = CGRectMake(kJSAvatarSize +30, 20, rect.size.width, rect.size.height);
        if (self.isBroker) {
            self.bubbleIMG.frame = CGRectMake(self.mapIMGView.frame.origin.x - 8.0f, 19.0f, rect.size.width + 10.0f, rect.size.height + 2.0f);
        } else {
            self.bubbleIMG.frame = CGRectMake(self.mapIMGView.frame.origin.x - 7.0f, 18.0f, rect.size.width + 9.0f, rect.size.height + 4.0f);
        }
    } else {
        self.mapIMGView.frame = CGRectMake(320.0f - kJSAvatarSize - 20.0f - rect.size.width - 1.0f, 20.0f, rect.size.width, rect.size.height);
        self.bubbleIMG.frame = CGRectMake(self.mapIMGView.frame.origin.x - 1, 19.0f, rect.size.width + 3.0f + 5.0f , rect.size.height + 2.0f);
        
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
