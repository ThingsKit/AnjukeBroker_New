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

// - wav转amr, 需要文件名 (不带后缀)
+ (void)wavToAmrWithWavFileName:(NSString*)wavFileName amrFileName:(NSString*)amrFileName;

// - amr转wav, 需要文件名 (不带后缀)
+ (void)amrToWavWithAmrFileName:(NSString*)amrFileName wavFileName:(NSString*)wavFileName;

// - 获取文件路径 (需要文件名, 文件类型)
+ (NSString*)filePathWithFileName:(NSString *)fileName ofType:(NSString *)type;







//按下录音按钮不放
- (void)beginRecording;

//松开录音按钮, 录音完成, 返回录音时间
- (double)finishRecording;

//取消录音
- (void)cancelRecording;

//获取实时的录音音量
- (CGFloat)volumnUpdated;

//播放指定的文件(wav格式, 文件名不带后缀)
- (void)playRecordingWithFileName:(NSString*)fileName;

@end
