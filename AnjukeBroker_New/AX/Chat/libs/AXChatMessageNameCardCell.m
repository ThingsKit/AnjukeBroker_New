//
//  AJKChatMessageNameCardCell.m
//  X
//
//  Created by 杨 志豪 on 14-2-15.
//  Copyright (c) 2014年 williamYang. All rights reserved.
//

#import "AXChatMessageNameCardCell.h"

@interface AXChatMessageNameCardCell ()
@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong) UILabel *personID;
@property (nonatomic, strong) UIImageView *personImage;

@end
@implementation AXChatMessageNameCardCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _nameLable = [[UILabel alloc] init];
        _nameLable.font = [UIFont systemFontOfSize:14];
        _nameLable.textAlignment = NSTextAlignmentRight;
    }
    return self;
}

- (void)configWithData:(NSDictionary *)data
{
    [super configWithData:data];
    
    UIView *whiteView = [[UILabel alloc] init];
    whiteView.layer.cornerRadius = 6.0f;
    whiteView.layer.masksToBounds = YES;
    whiteView.layer.borderColor = [UIColor greenColor].CGColor;
    whiteView.layer.borderWidth = 3.0f;
    CGRect rect;
    if (self.messageSource == AXChatMessageSourceDestinationIncoming) {
        rect = CGRectMake(kJSAvatarSize+40, 10, 200, 90);
    }else
    {
        rect = CGRectMake(320 - kJSAvatarSize - 40 - 200, 10, 200, 90);
    }
    whiteView.frame = rect;
    [whiteView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:whiteView];
    
    self.nameLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.personID = [[UILabel alloc] initWithFrame:CGRectMake(80, 40,100 , 30)];
    self.personImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 70, 70)];
    
    self.nameLable.text = [NSString stringWithFormat:@"      %@",data[@"name"]];
    self.personID.text = data[@"personID"];
    self.personImage.image = data[@"image"];
    
    [whiteView addSubview:self.nameLable];
    [whiteView addSubview:self.personID];
    [whiteView addSubview:self.personImage];
    
}
@end
