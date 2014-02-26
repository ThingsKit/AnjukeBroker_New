//
//  AXPhotoManager.m
//  Anjuke2
//
//  Created by jianzhongliu on 2/26/14.
//  Copyright (c) 2014 anjuke inc. All rights reserved.
//

#import "AXPhotoManager.h"

@implementation AXPhotoManager

+ (NSString *)getLibrary:(NSString *)path{
    NSArray*libsPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString*libPath = [libsPath objectAtIndex:0];

    if (path.length == 0) {
        return libPath;
    }else{
        return [libPath stringByAppendingPathComponent:path];
    }
}

+ (NSString *)saveImageFile:(UIImage *)image toFolder:(NSString *)folder whitChatId:(NSString *)chatId andIMGName:(NSString *) IMGName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *fileDocument = [self getLibrary:nil];
    NSString *userFolder = [fileDocument stringByAppendingPathComponent:folder];
    if (![fileManager fileExistsAtPath:userFolder]) {
        [fileManager createDirectoryAtPath:userFolder withIntermediateDirectories:NO attributes:nil error:nil];
    }
    NSString *uuidStr = chatId;
    NSString *fileName = [folder stringByAppendingPathComponent:[uuidStr stringByAppendingPathExtension:@"jpg"]];
    
    NSString *imageFilePath = [fileDocument stringByAppendingPathComponent:fileName]; //得到当前照片的路径
    
    if ([UIImageJPEGRepresentation(image, 0.96) writeToFile:imageFilePath atomically:YES]) {
        
    }else{

    }
    
    return fileName;
}

@end
