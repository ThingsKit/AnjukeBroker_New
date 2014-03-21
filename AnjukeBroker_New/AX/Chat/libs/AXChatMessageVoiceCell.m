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

@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIImageView *voiceIMG;
@property (nonatomic, strong) UIControl *voiceControl;
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
    self.voiceIMG = [[UIImageView alloc] init];
    self.voiceIMG.image = [UIImage imageNamed:@""];
    [self.contentView addSubview:self.voiceIMG];
    
    self.timeLab = [[UILabel alloc] init];
    self.timeLab.backgroundColor = [UIColor clearColor];
    self.timeLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.timeLab];

    self.voiceControl = [[UIControl alloc] init];
    self.voiceControl.backgroundColor = [UIColor clearColor];
    [self.voiceControl addTarget:self action:@selector(didclickVoice) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.voiceControl];
    
}

- (void)configWithData:(NSDictionary *)data
{
    [super configWithData:data];
    self.timeLab.text = @"2\"";
    CGSize size = CGSizeMake(50, 20);//算出语音条的宽度
    [self setBubbleImg:size];
}

- (void)setBubbleImg:(CGSize )size {
    
    if (self.messageSource == AXChatMessageSourceDestinationIncoming) {
        self.bubbleIMG.frame = CGRectMake(kJSAvatarSize + 20, axTagMarginTop, size.width + 30.0f , size.height + 20.0f);
        CGRect rect = self.bubbleIMG.frame;
        self.voiceIMG.frame = CGRectMake(rect.origin.x + 15, rect.origin.y + 10, 20, 20);
        self.voiceIMG.image = [UIImage imageNamed:@"anjuke_icon_say_voice_b.png"];
        self.timeLab.textAlignment = NSTextAlignmentLeft;
        self.timeLab.frame = CGRectMake(rect.origin.x + rect.size.width +5, rect.origin.y + 5, 40.0f, 20.0f);
    } else {

        self.bubbleIMG.frame = CGRectMake(320 - kJSAvatarSize - size.width - 50, axTagMarginTop, size.width + 30.0f , size.height + 20.0f);
        CGRect rect = self.bubbleIMG.frame;
        self.voiceIMG.frame = CGRectMake(rect.origin.x + rect.size.width - 25, rect.origin.y + 10, 20, 20);
        self.voiceIMG.image = [UIImage imageNamed:@"anjuke_icon_say_voice_a.png"];
        self.timeLab.textAlignment = NSTextAlignmentRight;
        self.timeLab.frame = CGRectMake(rect.origin.x - 40, rect.origin.y + 5, 40.0f, 20.0f);
    }
}

- (void)didclickVoice {
    NSDictionary* dict = [[KKAudioComponent sharedAudioComponent].data objectAtIndex:0];
    NSString* fileName = [dict objectForKey:@"FILE_NAME"];
    [[KKAudioComponent sharedAudioComponent] playRecordingWithFileName:fileName];
}
@end
