//
//  AJKChatMessageTimeCell.m
//  X
//
//  Created by jianzhongliu on 2/19/14.
//  Copyright (c) 2014 williamYang. All rights reserved.
//

#import "AXChatMessageSystemTimeCell.h"
#import "NSString+AXChatMessage.h"

static CGFloat const userLeftMargin = 10.0f;
static CGFloat const brokerLeftMargin = 10.0f;

@interface AXChatMessageSystemTimeCell ()

@property (nonatomic) AXMessageType messageType;

@end

@implementation AXChatMessageSystemTimeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.systemBgView = [[UIView alloc] initWithFrame:CGRectZero];
    self.systemBgView.backgroundColor = [UIColor axChatSystemBGColor:self.isBroker];
    self.systemBgView.layer.masksToBounds = YES;
    self.systemBgView.layer.cornerRadius = 4;
    self.systemBgView.hidden = YES;
    if (self.isBroker) {
        self.systemBgView.alpha = 0.1;
    }
    [self.contentView addSubview:self.systemBgView];
    
    self.systemLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.systemLab.textAlignment = NSTextAlignmentLeft;
    self.systemLab.backgroundColor = [UIColor clearColor];
    self.systemLab.textColor = [UIColor grayColor];
    self.systemLab.font = [UIFont systemFontOfSize:12];
    self.systemLab.numberOfLines = 0;
    [self.contentView addSubview:self.systemLab];
    
    self.systemBut = [UIButton buttonWithType:UIButtonTypeCustom];
    self.systemBut.frame = CGRectZero;
    self.systemBut.backgroundColor = [UIColor clearColor];
    [self.systemBut setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.systemBut addTarget:self action:@selector(clickBut:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.systemBut];
    

    self.backgroundColor = [UIColor clearColor];
}

- (void)configWithData:(NSDictionary *)data
{
    self.systemBut.frame = CGRectZero;
    [self.systemBut setTitle:@"" forState:UIControlStateNormal];
    [self.systemBut setTitleColor:[UIColor axChatSystemLinkColor:self.isBroker] forState:UIControlStateNormal];
    [self.systemBut setTitleColor:[UIColor axChatSystemLinkHighlightedColor:self.isBroker] forState:UIControlStateHighlighted];

    if ([data[@"messageType"] isEqualToNumber:@(AXMessageTypeSystemTime)]) {
        self.systemLab.text = data[@"content"];
        self.systemLab.font = [UIFont axChatSystemTimeFont:self.isBroker];
        self.systemLab.textColor = [UIColor axChatSystemTextColor:self.isBroker];
        CGSize size = [self sizeOfString:self.systemLab.text maxWidth:180.0f withFontSize:self.systemLab.font];
        self.systemLab.frame = CGRectMake(160.0f - size.width / 2.0f, 10, size.width, size.height);
        self.systemBgView.hidden = YES;
    } else if ([data[@"messageType"] isEqualToNumber:@(AXMessageTypeSystemForbid)]) {
        self.systemLab.text = @"对方已拒收了你的消息";
        self.systemLab.font = [UIFont axChatSystemFont:self.isBroker];
        self.systemLab.textColor = [UIColor axChatSystemTextColor:self.isBroker];
        CGSize size = [self sizeOfString:self.systemLab.text maxWidth:180.0f withFontSize:self.systemLab.font];
        self.systemLab.frame = CGRectMake(160.0f - size.width / 2.0f, 14, size.width, size.height);
        self.systemBgView.frame = CGRectMake(160.0f - size.width / 2.0f - 10, 10, size.width + 20, 25);
        self.systemBgView.hidden = NO;
    } else if ([data[@"messageType"] isEqualToNumber:@(AXMessageTypeAddNuckName)]) {
        self.systemLab.text = @"设置昵称会方便经纪人服务您";
        self.systemLab.font = [UIFont axChatSystemFont:self.isBroker];
        self.systemLab.textColor = [UIColor axChatSystemTextColor:self.isBroker];
        CGSize size = [self sizeOfString:self.systemLab.text maxWidth:270.0f withFontSize:self.systemLab.font];
        self.systemLab.frame = CGRectMake(25 + 15, 14, size.width, size.height);
        CGRect labRect = self.systemLab.frame;
        self.systemBut.frame = CGRectMake(labRect.origin.x + labRect.size.width + 5, labRect.origin.y, 60, labRect.size.height);
        self.systemBut.titleLabel.textColor = [UIColor axChatSystemLinkColor:self.isBroker];
        self.systemBut.titleLabel.font = [UIFont axChatSystemFont:self.isBroker];
        [self.systemBut setTitle:@"设置昵称" forState:UIControlStateNormal];
        self.systemBgView.frame = CGRectMake( (self.width - 270) / 2, 10, 270, 25);
        self.systemBgView.hidden = NO;
    } else if ([data[@"messageType"] isEqualToNumber:@(AXMessageTypeSettingNotifycation)]) {
        self.systemLab.text = @"你已关闭消息提醒。打开消息提醒能够及时得到经纪人的反馈。";
        self.systemLab.font = [UIFont axChatSystemFont:self.isBroker];
        self.systemLab.textColor = [UIColor axChatSystemTextColor:self.isBroker];
        CGSize size = [self sizeOfString:self.systemLab.text maxWidth:250.0f withFontSize:self.systemLab.font];
        self.systemLab.frame = CGRectMake(25 + 15, 14, size.width, size.height);
        CGRect labRect = self.systemLab.frame;
        self.systemBut.frame = CGRectMake(200 - 3, 24, 90, labRect.size.height);
        self.systemBut.titleLabel.textColor = [UIColor axChatSystemLinkColor:self.isBroker];
        self.systemBut.titleLabel.font = [UIFont axChatSystemFont:self.isBroker];
        [self.systemBut setTitle:@"打开消息提醒" forState:UIControlStateNormal];
        self.systemBgView.frame = CGRectMake( (self.width - 270) / 2, 10, 270, 41);
        self.systemBgView.hidden = NO;
    } else if ([data[@"messageType"] isEqualToNumber:@(AXMessageTypeAddNote)]) {
        self.systemLab.text = @"为了更好的管理客户，请";
        self.systemLab.font = [UIFont axChatSystemFont:self.isBroker];
        self.systemLab.textColor = [UIColor axChatSystemTextColor:self.isBroker];
        CGSize size = [self sizeOfString:self.systemLab.text maxWidth:180.0f withFontSize:self.systemLab.font];
        self.systemLab.frame = CGRectMake(120.0f - size.width / 2.0f, 14, size.width, size.height);
        CGRect labRect = self.systemLab.frame;
        self.systemBut.frame = CGRectMake(labRect.origin.x + labRect.size.width + 10, labRect.origin.y, 80, labRect.size.height);
        self.systemBut.titleLabel.textColor = [UIColor axChatSystemLinkColor:self.isBroker];
        self.systemBut.titleLabel.font = [UIFont axChatSystemFont:self.isBroker];
        [self.systemBut setTitle:@"添加备注" forState:UIControlStateNormal];
        self.systemBgView.hidden = NO;
    } else if ([data[@"messageType"] isEqualToNumber:@(AXMessageTypeSendProperty)]) {
        self.systemLab.text = @"可以把刚才看到的房源发给经纪人";
        self.systemLab.font = [UIFont axChatSystemFont:self.isBroker];
        self.systemLab.textColor = [UIColor axChatSystemTextColor:self.isBroker];
        CGSize size = [self sizeOfString:self.systemLab.text maxWidth:240.0f withFontSize:self.systemLab.font];
        self.systemLab.frame = CGRectMake(25 + 15, 14, size.width, size.height);
        CGRect labRect = self.systemLab.frame;
        self.systemBut.frame = CGRectMake(labRect.origin.x + labRect.size.width + 5, labRect.origin.y , 30, labRect.size.height);
        self.systemBut.titleLabel.textColor = [UIColor axChatSystemLinkColor:self.isBroker];
        self.systemBut.titleLabel.font = [UIFont axChatSystemFont:self.isBroker];
        [self.systemBut setTitle:@"发送" forState:UIControlStateNormal];
        self.systemBgView.frame = CGRectMake( (self.width - 270) / 2, 10, 270, 25);
        self.systemBgView.hidden = NO;
    } else if ([data[@"messageType"] isEqualToNumber:@(AXMessageTypeSafeMessage)]) {
        self.systemLab.text = @"提示：对话中如涉及电话号码、微信号码等信息，请近所提供。";
        self.systemLab.font = [UIFont axChatSystemFont:self.isBroker];
        self.systemLab.textColor = [UIColor axChatSystemTextColor:self.isBroker];
        CGSize size = [self sizeOfString:self.systemLab.text maxWidth:240.0f withFontSize:self.systemLab.font];
        self.systemLab.frame = CGRectMake(25 + 15, 14, size.width, size.height);
        self.systemBgView.frame = CGRectMake( (self.width - 270) / 2, 10, 270, 41);
        self.systemBgView.hidden = NO;
    }
    self.messageType = [data[@"messageType"] integerValue];
}

- (void)configWithIndexPath:(NSIndexPath *)indexPath {
    self.currentIndexPath = indexPath;
}

- (CGSize)sizeOfString:(NSString *)string maxWidth:(float)width withFontSize:(UIFont *)fontSize
{
    return [string rtSizeWithFont:fontSize constrainedToSize:CGSizeMake(width, 10000.0f) lineBreakMode:NSLineBreakByCharWrapping];
}

- (void)clickBut:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickSystemButton:)]) {
        [self.delegate didClickSystemButton:self.messageType];
    }
}

@end
