//
//  AXChatMessageVoiceCell.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 3/19/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import "AXChatMessageVoiceCell.h"
#import "KKAudioComponent.h"

@interface AXChatMessageVoiceCell ()

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *voiceImageView;
@property (nonatomic, strong) UIControl *voiceControl;
@property (nonatomic, strong) UIImageView *voiceStatusImageView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) NSInteger index;
@end

@implementation AXChatMessageVoiceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // Initialization code
    }
    return self;
}
- (void)initUI {
    [super initUI];
    self.index = 0;
    
    self.voiceStatusImageView = [[UIImageView alloc] init];
    self.voiceStatusImageView.image = [UIImage imageNamed:@"wl_voice_icon_reddot.png"];
    self.voiceStatusImageView.frame = CGRectMake(0, 10, 8, 8);
    [self.contentView addSubview:self.voiceStatusImageView];
    
    self.voiceImageView = [[UIImageView alloc] init];
    self.voiceImageView.image = [UIImage imageNamed:@"wl_chat_icon_uservoice.png"];
    self.voiceImageView.frame = CGRectMake(0, 21, 12, 19);
    [self.contentView addSubview:self.voiceImageView];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.frame = CGRectMake(0, 20, 40, 21);
    self.timeLabel.font = [UIFont systemFontOfSize:14];
    self.timeLabel.textColor = [UIColor colorWithHex:0x343434 alpha:1];
    [self.contentView addSubview:self.timeLabel];
    
    self.voiceControl = [[UIControl alloc] init];
    self.voiceControl.backgroundColor = [UIColor clearColor];
    [self.voiceControl addTarget:self action:@selector(didClickVoice) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.voiceControl];
}

- (void)dealloc {
    [self endPlay];
//    [self.timer invalidate];
//    self.timer = nil;
}

- (void)configWithData:(NSDictionary *)data
{
    [super configWithData:data];
    NSDictionary *content = [data[@"content"] JSONValue];
    [self endPlay];
    if (self.messageSource == AXChatMessageSourceDestinationIncoming) {
        if ([content[@"hadDone"] isEqualToString:@"0"]) {
            self.voiceStatusImageView.hidden = YES;
        } else {
            self.voiceStatusImageView.hidden = NO;
        }
    }else {
        self.voiceStatusImageView.hidden = YES;
    }
    NSInteger length = MIN([content[@"length"] doubleValue], 60);
    self.timeLabel.text = [NSString stringWithFormat:@"%d\"", length];
    CGSize size = CGSizeMake([self voiceCellLengthByTime:length], 20);
    [self setBubbleImg:size];
    if (self.timer) {
        [self.timer invalidate];
    }
    [self configWithStatus];
}

- (void)resetPlayer:(NSString *)playingIdentifier
{
    if ([playingIdentifier isEqualToString:self.identifyString]) {
        [self startPlay];
    }
}

- (void)setBubbleImg:(CGSize )size {
    if (self.messageSource == AXChatMessageSourceDestinationIncoming) {
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        self.voiceImageView.contentMode = UIViewContentModeLeft;
        self.voiceImageView.image = [UIImage imageNamed:@"wl_chat_icon_agentvoice.png"];
        self.voiceImageView.left = kJSAvatarSize + 19 + 15;
        self.bubbleIMG.frame = CGRectMake(kJSAvatarSize + 19, axTagMarginTop, size.width + 30.0f , size.height + 20.0f);
        self.voiceStatusImageView.left = self.bubbleIMG.right + 7;
        self.timeLabel.left = self.bubbleIMG.right + 7;
        self.voiceControl.frame = self.bubbleIMG.frame;
    } else {
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        self.bubbleIMG.frame = CGRectMake(320 - kJSAvatarSize - size.width - kAvatarMargin - 37, axTagMarginTop, size.width + 30.0f , size.height + 20.0f);
        self.voiceImageView.image = [UIImage imageNamed:@"wl_chat_icon_uservoice.png"];
        self.voiceImageView.contentMode = UIViewContentModeRight;
        self.voiceImageView.left = self.bubbleIMG.right - 25;
        self.voiceStatusImageView.left = self.bubbleIMG.left - 7 - self.voiceStatusImageView.width;
        self.timeLabel.left = self.bubbleIMG.left - 7 - self.timeLabel.width;
        self.voiceControl.frame = self.bubbleIMG.frame;
    }
}

- (void)didClickVoice {
    [self startPlay];
    self.voiceStatusImageView.hidden = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickVoice:)]) {
        [self.delegate didClickVoice:self];
    }
}

- (void)startPlay
{
    self.index = 0;
    if (self.timer) {
        [self.timer invalidate];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(playAnimation) userInfo:nil repeats:YES];
}

- (void)endPlay
{
    if (self.timer) {
        [self.timer invalidate];
    }
}

- (void)playAnimation
{
    [UIView animateWithDuration:0.2 animations:^{
        NSString *type;
        if (self.messageSource == AXChatMessageSourceDestinationIncoming) {
            type = @"agent";
        } else {
            type = @"user";
        }
        
        if (self.index == 0) {
            self.voiceImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"wl_chat_icon_%@voice_play1.png", type]];
            self.index = 1;
        } else if (self.index == 1) {
            self.voiceImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"wl_chat_icon_%@voice_play2.png", type]];
            self.index = 2;
        } else if (self.index == 2) {
            self.voiceImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"wl_chat_icon_%@voice_play3.png", type]];
            self.index = 3;
        } else if (self.index == 3) {
            self.voiceImageView.image = [UIImage createImageWithColor:[UIColor clearColor]];
            self.index = 0;
        }
    }];
}

- (double )voiceCellLengthByTime:(double) time{
    double length = log10(time)/log10(1.0165);
    return (length + 120.0f) / 2.0f;
}

@end
