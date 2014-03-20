//
//  ComponentAudioRecord.h
//  AudioRecorder
//
//  Created by leozhu on 14-3-18.
//  Copyright (c) 2014年 leozhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@interface KKAudioComponent : NSObject <AVAudioPlayerDelegate, AVAudioRecorderDelegate>

@property (nonatomic, retain) NSArray* data;

+ (KKAudioComponent*) sharedAudioComponent;

//按下录音按钮不放
- (void)willBeginRecording;

//松开录音按钮, 录音完成
- (void)didFinishRecording;

//取消录音
- (void)willCancelRecording;

//获取实时的录音音量
- (CGFloat)volumnUpdated;

//播放指定的文件(wav格式, 文件名不带后缀)
- (void)willPlayRecordingWithFileName:(NSString*)fileName;

@end
