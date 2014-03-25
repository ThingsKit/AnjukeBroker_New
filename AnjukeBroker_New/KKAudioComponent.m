//
//  ComponentAudioRecord.m
//  AudioRecorder
//
//  Created by leozhu on 14-3-18.
//  Copyright (c) 2014年 leozhu. All rights reserved.
//

#import "KKAudioComponent.h"
#import "VoiceConverter.h"


@interface KKAudioComponent ()
@property (nonatomic, retain) AVAudioPlayer* player;
@property (nonatomic, retain) AVAudioRecorder* recorder;
@property (nonatomic, retain) NSTimer* timer;

@property (nonatomic, copy) NSString* recordFileName;

@end


@implementation KKAudioComponent

static KKAudioComponent* defaultAudioComponent;

+ (KKAudioComponent*)sharedAudioComponent{
    @synchronized(self){
        if (defaultAudioComponent == nil) {
            defaultAudioComponent = [[KKAudioComponent alloc] init];
        }
    }
    return defaultAudioComponent;
}

- (id)init{
    if (self = [super init]) {
        
        //建议在播放之前设置yes，播放结束设置NO，这个功能是开启近距离传感器
//        [[UIDevice currentDevice] setProximityMonitoringEnabled:NO]; //default is NO
        //添加近距离传感器的状态变化监听
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didSensorStateChanged:)
                                                     name:@"UIDeviceProximityStateDidChangeNotification"
                                                   object:nil];
        
    }
    
    return self;
}


#pragma mark -
#pragma mark API
//按下录音按钮不放
- (void)beginRecording{
    //1. init recorder
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    
    NSString* uniCode = [[NSProcessInfo processInfo] globallyUniqueString]; //唯一吗
    
    self.recordFileName = [NSString stringWithFormat:@"%@", uniCode]; //原录音文件名
    
    NSString* recordFileNamePath = [KKAudioComponent filePathWithFileName:self.recordFileName ofType:@"wav"];
    
    self.recorder = [[AVAudioRecorder alloc]
                     initWithURL:[NSURL URLWithString:recordFileNamePath]
                     settings:[KKAudioComponent audioRecorderSettingDict]
                     error:nil];
    _recorder.meteringEnabled = YES;  //开启音量检测
    _recorder.delegate = self;
    
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:nil]; //支持播放与录音
    [[AVAudioSession sharedInstance] setActive:YES error:nil]; //感觉没有作用
    
    //2. recording
    if ([_recorder prepareToRecord]) {
        [_recorder record];
    }
    
    
    //3. update volumn image
    //    self.timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(updateVolumn) userInfo:nil repeats:YES];
    NSLog(@"开始录音");
}


//松开录音按钮
- (NSDictionary*)finishRecording{
    if (_recorder == nil) {
        return 0;
    }
    
    double cTime = _recorder.currentTime; //录制时长
    
    if (cTime > 1) {//如果录制时间<1 不发送
        
        NSDictionary* dictRecordFile = [KKAudioComponent fileAttributesWithFileName:self.recordFileName FileType:@"wav" RecordTime:cTime];
        NSLog(@"%@", dictRecordFile);
        [_recorder stop];
        NSLog(@"发送");
        return dictRecordFile;
        
        
        
    }else {
        //删除记录的文件
        [_recorder deleteRecording];
        [_recorder stop];
        NSLog(@"时间太短");
        return nil;
    }
    //    [_timer invalidate];
}

//取消录音按钮
- (void)cancelRecording{
    if (_recorder == nil) {
        return;
    }
    
    [_recorder deleteRecording];
    [_recorder stop];
    //    [_timer invalidate];
    NSLog(@"取消发送");
    
}

//播放录音, 支持支 wav格式
- (void)playRecordingWithRelativeFilePath:(NSString*)relativeFilePath{
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];  //默认扬声器播放
    
    NSString* libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]; //lib路径
    NSString* filePath = [NSString stringWithFormat:@"%@/%@", libPath, relativeFilePath]; //绝对路径
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) { //文件存在
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:filePath] error:nil];
        _player.delegate = self;
        [_player play];
        
        NSLog(@"开始播放");
    }else {
        NSLog(@"文件不存在");
    }
    
}

- (void)cancelPlaying{
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    if (self.player != nil) {
        [self.player stop];
//        self.playDidCancelBlock();
    }
    
}

- (BOOL) isPlaying{
    if (self.player != nil) {
        return [self.player isPlaying];
    }
    return NO;
}

//返回音量更新,范围 [0 ~ 0.3]
- (CGFloat)volumnUpdated{
    if (_recorder == nil) {
        return 0;
    }
    
    if (_recorder.isRecording) { //如果正在录音
        [_recorder updateMeters];//刷新音量数据
        //获取音量的平均值  [recorder averagePowerForChannel:0];
        //音量的最大值  [recorder peakPowerForChannel:0];
        
        double lowPassResults = pow(10, (0.05 * [_recorder averagePowerForChannel:0]));
        return lowPassResults;
    }
    
    return 0;
}

#pragma mark -
#pragma mark - UIDeviceProximityStateDidChangeNotification 近距离传感器状态变化的回调
//近距离传感器状态改变
-(void)didSensorStateChanged:(NSNotificationCenter *)notification{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState] == YES){
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];  //听筒
    }else{
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];  //扬声器
    }
}

#pragma mark -
#pragma mark AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    
}

/* audioRecorderBeginInterruption: is called when the audio session has been interrupted while the recorder was recording. The recorded file will be closed. */
- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder{
    NSLog(@"录音中断, 录音文件断开??");
}

/* audioRecorderEndInterruption:withOptions: is called when the audio session interruption has ended and this recorder had been interrupted while recording. */
/* Currently the only flag is AVAudioSessionInterruptionFlags_ShouldResume. */
- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags{
    NSLog(@"录音中断结束");
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error{
    NSLog(@"%@", error);
}

#pragma mark -
#pragma mark AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    //建议在播放之前设置yes，播放结束设置NO，这个功能是开启近距离传感器
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
//    [[NSNotificationCenter defaultCenter] postNotificationName:AUDIOPLAYER_DID_FINISH_PLAYING object:nil userInfo:nil]; //告知调用者播放结束
    
    //或者使用block
    if (self.playDidFinishBlock != nil) {
        self.playDidFinishBlock();
    }
    
}

/* audioPlayerBeginInterruption: is called when the audio session has been interrupted while the player was playing. The player will have been paused. */
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    NSLog(@"暂停播放");
    if (_player != nil && _player.isPlaying) {
        [_player pause];
    }
}

/* audioPlayerEndInterruption:withOptions: is called when the audio session interruption has ended and this player had been interrupted while playing. */
/* Currently the only flag is AVAudioSessionInterruptionFlags_ShouldResume. */
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags{
    NSLog(@"继续播放");
    if (_player != nil && !_player.isPlaying) {
        [_player play];
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    NSLog(@"%@", error);
}

#pragma mark - 获取recorder设置属性
+ (NSDictionary*)audioRecorderSettingDict
{
    NSDictionary* recordSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                   
                                   [NSNumber numberWithFloat: 8000.0], AVSampleRateKey, //采样率
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM], AVFormatIDKey,
                                   [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey, //采样位数 默认 16
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey, //通道的数目
//                                   [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey, //大端还是小端 是内存的组织方式
//                                   [NSNumber numberWithBool:NO], AVLinearPCMIsFloatKey, //采样信号是整数还是浮点数
                                   [NSNumber numberWithInt: AVAudioQualityMedium], AVEncoderAudioQualityKey, //音频编码质量
                                   
                                   nil];
    return recordSetting;
}

#pragma mark - 根据文件路径获取 文件大小, 录制时间的字典
+ (NSDictionary*)fileAttributesWithFileName:(NSString*)fileName FileType:(NSString*)fileType RecordTime:(double)recordTime{
    
    NSString* fileRelativePath = [NSString stringWithFormat:@"Voice/%@.%@", fileName, fileType];
    NSString* filePath = [KKAudioComponent filePathWithFileName:fileName ofType:fileType];
    NSString* fileSize = [NSString stringWithFormat:@"%dkb", [KKAudioComponent fileSizeAtPath:filePath]/1024];
    NSString* cTime = [NSString stringWithFormat:@"%f", recordTime];
    
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          fileName, @"FILE_NAME",
                          fileRelativePath, @"FILE_RELATIVE_PATH",
                          fileSize, @"FILE_SIZE",
                          cTime, @"RECORD_TIME",
                          nil];
    
    return  dict;
}

#pragma mark - wav转amr
+ (NSString*)wavToAmrWithWavFileName:(NSString*)wavFileName{
    
    //    NSString* string = @"AD6162CA-644A-4682-91A2-BC90D4FD653C-696-000000739E21613B";
    NSString* wavFilePath = [KKAudioComponent filePathWithFileName:wavFileName ofType:@"wav"];
    NSString* amrFilePath = [KKAudioComponent filePathWithFileName:wavFileName ofType:@"amr"];
    int success = [VoiceConverter wavToAmr:wavFilePath amrSavePath:amrFilePath]; //amr写本地, 需要绝对路径
    if (success) {
//        [[NSFileManager defaultManager] removeItemAtPath:wavFilePath error:nil]; //删除wav文件
        NSString* relativeAmrFilePath = [NSString stringWithFormat:@"Voice/%@.amr", wavFileName];
        return relativeAmrFilePath; //返回amr文件相对路径
        
    }else{
        return nil;
    }
}

+ (NSString*)wavToAmrWithWavFilePath:(NSString*)wavFilePath{
    
//    NSString* string = @"/var/mobile/Applications/30213A8E-E3F2-4F3A-A419-36FEC2CF705D/Library/Voice/AD6162CA-644A-4682-91A2-BC90D4FD653C-696-000000739E21613B.wav";
    NSString* libPath = [KKAudioComponent libraryPath];
    wavFilePath = [NSString stringWithFormat:@"%@/%@", libPath, wavFilePath];
    NSString* fileNamePath = [[wavFilePath componentsSeparatedByString:@"/"] lastObject];
    NSString* fileName = [fileNamePath substringWithRange:NSMakeRange(0, fileNamePath.length - 4)];
    NSString* amrFilePath = [KKAudioComponent filePathWithFileName:fileName ofType:@"amr"];
    int success = [VoiceConverter wavToAmr:wavFilePath amrSavePath:amrFilePath]; //amr写本地, 需要绝对路径
    if (success) {
//        [[NSFileManager defaultManager] removeItemAtPath:wavFilePath error:nil]; //删除wav文件
        NSString* relativeAmrFilePath = [NSString stringWithFormat:@"Voice/%@.amr", fileName];
        return relativeAmrFilePath; //返回amr文件相对路径
    }else{
        return nil;
    }
}

#pragma mark - amr转wav
+ (NSString*)amrToWavWithNSData:(NSData*)data{
    
    NSString* fileName = [[NSProcessInfo processInfo] globallyUniqueString]; //唯一吗
    
    //这里data先写入本地文件, 再进行转码, data可以直接转码吗?
    NSString* amrFilePath = [KKAudioComponent filePathWithFileName:fileName ofType:@"amr"];
    [data writeToFile:amrFilePath atomically:YES]; //amr写本地
    
    NSString* wavFilePath = [KKAudioComponent filePathWithFileName:fileName ofType:@"wav"];
    int success = [VoiceConverter amrToWav:amrFilePath wavSavePath:wavFilePath]; //wav写本地,需要绝对路径
    if (success) {
        [[NSFileManager defaultManager] removeItemAtPath:amrFilePath error:nil]; //删除amr
        NSString* relativeWavFilePath = [NSString stringWithFormat:@"Voice/%@.wav", fileName];
        return relativeWavFilePath; //返回wav文件相对路径
    }else{
        return nil;
    }
}

#pragma mark - 获取文件路径
+ (NSString*)filePathWithFileName:(NSString *)fileName ofType:(NSString *)type
{
    if (fileName.length > 0 && type.length > 0) {
        NSString* path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString* voicePath = [NSString stringWithFormat:@"%@/Voice", path];
        if (![[NSFileManager defaultManager] fileExistsAtPath:voicePath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:voicePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString* filePath = [NSString stringWithFormat:@"%@/%@.%@", voicePath, fileName, type];
        
        return filePath;
    }
    
    return nil;
}

#pragma mark - 返回沙盒下的Library的路径
+ (NSString*)libraryPath{
     return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

#pragma mark - 获取文件大小, 单位字节
+ (NSInteger)fileSizeAtPath:(NSString*) path{
    //    NSFileManager * filemanager = [[[NSFileManager alloc]init] autorelease];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        NSDictionary * attributes = [fileManager attributesOfItemAtPath:path error:nil];
        NSNumber *theFileSize;
        if ( (theFileSize = [attributes objectForKey:NSFileSize]) )
            return  [theFileSize longValue]; //这里不用intValue用longValue, 防止太大intValue溢出
        else
            return -1;
    }
    else{
        return -1;
    }
}

#pragma mark -
#pragma mark 标准化单例对象
+ (id)allocWithZone:(struct _NSZone *)zone {
    if (defaultAudioComponent == nil) {
        defaultAudioComponent = [super allocWithZone:zone];
    }
    return defaultAudioComponent;
}

- (id)copyWithZone:(NSZone *)zone {
    return defaultAudioComponent;
}

//- (id)retain {
//    return defaultAudioComponent;
//}
//
//- (NSUInteger)retainCount {
//    return UINT_MAX;
//}
//
//- (oneway void) release{
//}
//
//- (id) autorelease{
//    return defaultAudioComponent;
//}
+ (NSString*)relativeFilePathWithFileName:(NSString *)fileName ofType:(NSString *)type
{
    if (fileName.length > 0 && type.length > 0) {
        NSString* voicePath = @"Voice";
        if (![[NSFileManager defaultManager] fileExistsAtPath:voicePath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:voicePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString* filePath = [NSString stringWithFormat:@"%@/%@.%@", voicePath, fileName, type];
        return filePath;
    }
    return nil;
}
@end
