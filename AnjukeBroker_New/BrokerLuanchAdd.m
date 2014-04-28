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
@synthesize timer,launchAddView;

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
- (void)doRequst{
    NSString *launchDirectory = [self getLauchImgFile];
    NSArray *fileList = [self getAllLaunchFileName];
    
    NSString *imgPath = nil;
    if (fileList && fileList.count > 0) {
        imgPath = [NSString stringWithFormat:@"%@/%@",launchDirectory,fileList.firstObject];
    }
    UIImage *launchImg = [[UIImage alloc] initWithContentsOfFile:imgPath];
    if (launchImg) {
        [self showLaunchAdd:launchImg];
    }
    
    [[RTRequestProxy sharedInstance] asyncRESTGetWithServiceID:RTAnjukeRESTService4ID methodName:@"setting/client" params:nil target:self action:@selector(onGetFixedInfo:)];
}
-(void)onGetFixedInfo:(RTNetworkResponse *)response{
    if([[response content] count] == 0){
        return ;
    }
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        return;
    }
    NSDictionary *resultFromAPI = [NSDictionary dictionaryWithDictionary:[response content]];
    
    NSString *imgUrl = nil;
    NSArray *itemsArr = [[[resultFromAPI objectForKey:@"results"] objectForKey:@"welcome"] objectForKey:@"items"];
    if ([itemsArr count] > 0 && [[[[itemsArr objectAtIndex:0] objectForKey:@"data"] objectAtIndex:0] objectForKey:@"image"]) {
        imgUrl = [[[[itemsArr objectAtIndex:0] objectForKey:@"data"] objectAtIndex:0] objectForKey:@"image"];
    }

//    imgUrl = @"http://pic1.ajkimg.com/m/3d401b7f8f426c4742a392fb65d67237/640x1136.jpg";
    
    NSArray *fileList = [self getAllLaunchFileName];
    if (imgUrl && fileList.count > 0) {
        for (int i = 0; i < fileList.count; i++) {
            if ([[self strReplace:imgUrl] isEqualToString:[NSString stringWithFormat:@"%@",[fileList objectAtIndex:i]]]) {
                return;
            }
        }
    }
    
    if (imgUrl) {
        //删除文件
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (fileList.count > 0) {
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
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    [window addSubview:self.launchAddView];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(hideLaunchAdd:) userInfo:nil repeats:NO];
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
