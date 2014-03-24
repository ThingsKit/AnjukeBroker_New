//
//  ComponentAudioRecord.h
//  AudioRecorder
//
//  Created by leozhu on 14-3-18.
//  Copyright (c) 2014年 leozhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

//告知调用者播放结束
#define AUDIOPLAYER_DID_FINISH_PLAYING @"audioPlayerDidFinishPlaying"


@interface KKAudioComponent : NSObject <AVAudioPlayerDelegate, AVAudioRecorderDelegate>

//返回录音文件名, 录音时间, 录音文件路径的字典, 字典在组数的0号索引处, 数组方便以后扩展
@property (nonatomic, retain) NSArray* data;

+ (KKAudioComponent*) sharedAudioComponent;

// - wav转amr, 需要文件名 (不带后缀)
+ (NSString*)wavToAmrWithWavFilePath:(NSString*)wavFilePath;

// - amr转wav, 需要文件名 (不带后缀)
+ (NSString*)amrToWavWithNSData:(NSData*)data;

// 根据文件名获取绝对路径
+ (NSString*)filePathWithFileName:(NSString *)fileName ofType:(NSString *)type;



//按下录音按钮不放
- (void)beginRecording;

//松开录音按钮, 录音完成, 返回录音时间
- (double)finishRecording;

//取消录音
- (void)cancelRecording;

//获取实时的录音音量
- (CGFloat)volumnUpdated;

//播放指定的文件(wav格式, 参数 文件名不带后缀)
- (void)playRecordingWithFileName:(NSString*)fileName;
//播放指定的文件(wav格式, 参数 文件绝对路径)
- (void)playRecordingWithFilePath:(NSString*)filePath;

@end
