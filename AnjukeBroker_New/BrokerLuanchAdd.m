//
//  BrokerLuanchAdd.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-4-23.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "BrokerLuanchAdd.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "RTLaunchImg.h"
#import "RTNetworkResponse.h"

#define LAUNCHIMGPATH @"brokerLaunchImg"

static BrokerLuanchAdd *defaultLaunchAdd;

@implementation BrokerLuanchAdd
@synthesize timer,launchAddView,lauchAddDic,lauchConfig;

+ (BrokerLuanchAdd *) sharedLuanchAdd{
    @synchronized(self){
        if (defaultLaunchAdd == nil) {
            defaultLaunchAdd = [[BrokerLuanchAdd alloc] init];
        }
        return defaultLaunchAdd;
    }
}
- (AXIMGDownloader *)imgDownloader {
    if (_imgDownloader == nil) {
        _imgDownloader = [[AXIMGDownloader alloc] init];
    }
    return _imgDownloader;
}

#pragma mark -- apiRequest
- (void)doRequst{
    self.lauchAddDic = [NSDictionary dictionaryWithContentsOfFile:[self filePath:@"lauchAdd.plist"]];
    BOOL isNeedCheck = YES;
    double currentTime = [[NSDate date] timeIntervalSince1970];

    if (self.lauchAddDic) {
        if (currentTime - [self.lauchAddDic[@"lastRequestTime"] doubleValue] < 24*3600) {
            isNeedCheck = NO;
        }else{
            isNeedCheck = YES;
        }
        
        if (self.lauchAddDic[@"results"]) {
            if (self.lauchAddDic[@"results"][@"welcome"]) {
                NSArray *dataArr = [self.lauchAddDic[@"results"][@"welcome"] objectForKey:@"items"];
                if (dataArr && dataArr.count > 0) {
                    self.lauchConfig = dataArr[0];
                    
                    NSString *launchDirectory = [self getLauchImgFile];
                    NSString *imgPath = [NSString stringWithFormat:@"%@/%@",launchDirectory,[self strReplace:[dataArr[0] objectForKey:@"image"]]];
                    UIImage *launchImg = [[UIImage alloc] initWithContentsOfFile:imgPath];
                    
                    if (launchImg) {
                        if (currentTime > [[self.lauchConfig objectForKey:@"begin"] doubleValue] && currentTime < [[self.lauchConfig objectForKey:@"end"] doubleValue]) {
                            [self showLaunchAdd:launchImg];
                        }
                    }
                }
            }
        }
    }
    
    if (isNeedCheck) {
        [[RTRequestProxy sharedInstance] asyncRESTGetWithServiceID:RTAnjukeRESTService4ID methodName:@"setting/client" params:nil target:self action:@selector(onGetFixedInfo:)];
    }
}


-(void)onGetFixedInfo:(RTNetworkResponse *)response{
    if([[response content] count] == 0){
        return ;
    }
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        return;
    }
    NSMutableDictionary *resultFromAPI = [NSMutableDictionary dictionaryWithDictionary:[response content]];
    double currentTime = [[NSDate date] timeIntervalSince1970];
    resultFromAPI[@"lastRequestTime"] = @(currentTime);
    
    //将配置文件写入lauchAdd.plist
    NSString *lauchAddFilePath = [self filePath:@"lauchAdd.plist"];
    [resultFromAPI writeToFile:lauchAddFilePath atomically:YES];
    
    
    NSString *imgUrl = nil;
    NSArray *itemsArr = [[[resultFromAPI objectForKey:@"results"] objectForKey:@"welcome"] objectForKey:@"items"];
    if ([itemsArr count] > 0 && [[[[itemsArr objectAtIndex:0] objectForKey:@"data"] objectAtIndex:0] objectForKey:@"image"]) {
        imgUrl = [[[[itemsArr objectAtIndex:0] objectForKey:@"data"] objectAtIndex:0] objectForKey:@"image"];
    }

    NSArray *fileList = [self getAllLaunchFileName];
    if (imgUrl && fileList.count > 0) {
        for (int i = 0; i < fileList.count; i++) {
            if ([[self strReplace:imgUrl] isEqualToString:[NSString stringWithFormat:@"%@",[fileList objectAtIndex:i]]]) {
                return;
            }
        }
    }
    
    if (imgUrl)
    {
        //删除文件
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (fileList.count > 0)
        {
            BOOL deleteSuc = [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@",[fileList objectAtIndex:0]] error:nil];
            if (deleteSuc) {
                [self fetchImageWithURL:imgUrl saveAtPath:imgUrl];
            }else{
                DLog(@"文件删除失败");
            }
        }else{
            [self fetchImageWithURL:imgUrl saveAtPath:imgUrl];
        }
    }
}
- (void)fetchImageWithURL:(NSString *)url saveAtPath:(NSString *)path
{
    [self.imgDownloader dowloadIMGWithURL:[NSURL URLWithString:url] resultBlock:^(RTNetworkResponse *response) {
        if (response.status == 2) {
            if (response.content && [response.content objectForKey:@"imagePath"]) {
                UIImage *image = [UIImage imageWithContentsOfFile:[response.content objectForKey:@"imagePath"]];
                 NSData *imageData = UIImagePNGRepresentation([image imageWithAspectFillStyle]);
                 NSFileManager *fileManager = [NSFileManager defaultManager];
                 NSString *launchDirectory = [self getLauchImgFile];
                 // 创建目录
                 [fileManager createDirectoryAtPath:launchDirectory withIntermediateDirectories:YES attributes:nil error:nil];

                 NSString *launchImgPath = [launchDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[self strReplace:path]]];
                 [fileManager createFileAtPath:launchImgPath contents:imageData attributes:nil];
            }
        }
    }];
}
- (NSString *)strReplace:(NSString *)str{
    str = [str stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return str;
}
- (NSString *)getLauchImgFile{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *launchDirectory = [documentsDirectory stringByAppendingPathComponent:@"launchImg"];
    
    return  launchDirectory;
}

- (NSArray *)getAllLaunchFileName{
    NSString *launchDirectory = [self getLauchImgFile];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *fileList = [[NSArray alloc] init];
    NSError *error = nil;
    fileList = [fileManager contentsOfDirectoryAtPath:launchDirectory error:&error];
    
    return fileList;
}
- (void)showLaunchAdd:(UIImage *)img{
    self.launchAddView = [RTLaunchImg loadLaunchAdd:img];
    
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    [window addSubview:self.launchAddView];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:[[self.lauchConfig[@"data"] objectForKey:@"duration"] floatValue] target:self selector:@selector(hideLaunchAdd:) userInfo:nil repeats:NO];
}
- (void)hideLaunchAdd:(NSTimer *)timer{
    [UIView animateWithDuration:1.0 animations:^{
        self.launchAddView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.launchAddView removeFromSuperview];
        self.launchAddView = nil;
        [self.timer invalidate];
    }];
}
#pragma mark -- filePath
- (NSString *)filePath:(NSString *)fileName {
    NSArray *myPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *myDocPath = [myPaths objectAtIndex:0];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:[myDocPath stringByAppendingString:@"/lauchAdd"]]) {
        [fm createDirectoryAtPath:[myDocPath stringByAppendingString:@"/lauchAdd"] withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    NSString *filePath = [NSString stringWithFormat:@"%@/lauchAdd%@",myDocPath,fileName];
    DLog(@"file--->>%@",fileName);
    return filePath;
}

+ (NSInteger)windowWidth {
    return [[[[UIApplication sharedApplication] windows] objectAtIndex:0] frame].size.width;
}

+ (NSInteger)viewHeight {
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        return [[[[UIApplication sharedApplication] windows] objectAtIndex:0] frame].size.height-20;
    }else{
        return [[[[UIApplication sharedApplication] windows] objectAtIndex:0] frame].size.height;
    }
}

@end
