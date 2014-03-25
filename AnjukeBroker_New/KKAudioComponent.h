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
//#define AUDIOPLAYER_DID_FINISH_PLAYING @"audioPlayerDidFinishPlaying"

typedef void(^PlayDidFinishBlock) (void);

@interface KKAudioComponent : NSObject <AVAudioPlayerDelegate, AVAudioRecorderDelegate>

@property (nonatomic, copy) PlayDidFinishBlock playDidFinishBlock;

+ (KKAudioComponent*) sharedAudioComponent;

// - wav转amr, 需要文件名 (不带后缀), 返回amr文件的相对路径
+ (NSString*)wavToAmrWithWavFileName:(NSString*)wavFileName;

// - wav转amr, 需要文件路径, 返回amr文件的相对路径
+ (NSString*)wavToAmrWithWavFilePath:(NSString*)wavFilePath;

// - amr转wav, 需要文件名 (不带后缀), 返回wav文件的相对路径
+ (NSString*)amrToWavWithNSData:(NSData*)data;

// 需要文件名, 返回文件的绝对路径
+ (NSString*)filePathWithFileName:(NSString *)fileName ofType:(NSString *)type;

// 返回library路径,用于拼合绝对路径
+ (NSString*)libraryPath;


//按下录音按钮不放
- (void)beginRecording;

//松开录音按钮, 录音完成, 返回录音文件名, 录音文件相对路径, 录音文件大小, 录音时间的字典
- (NSDictionary*)finishRecording;

//取消录音
- (void)cancelRecording;

//获取实时的录音音量
- (CGFloat)volumnUpdated;

//播放指定的文件(wav格式, 参数 文件名不带后缀)
- (void)playRecordingWithFileName:(NSString*)fileName;
//播放指定的文件(wav格式, 参数 文件绝对路径, 需要lib+相对路径)
- (void)playRecordingWithFilePath:(NSString*)filePath;

@end
