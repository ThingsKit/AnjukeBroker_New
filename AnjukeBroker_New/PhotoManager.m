//
//  PhotoManager.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-12.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "PhotoManager.h"
#import "Util_UI.h"

#define Broker_AlbumName @"网络经纪人"

@implementation PhotoManager

+ (NSString *)getDocumentPath:(NSString *)path{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *document = [paths objectAtIndex:0];
    if (path.length == 0) {
        return document;
    }else{
        return [document stringByAppendingPathComponent:path];
    }
}

+ (NSString *)genUUID
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef str = CFUUIDCreateString(NULL, uuidRef);
    NSString *tmp = (NSString *)CFBridgingRelease(str);
    CFRelease(uuidRef);
    return tmp;
}

+ (NSString *)saveImageFile:(UIImage *)image toFolder:(NSString *)folder
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *fileDocument = [self getDocumentPath:nil];
    NSString *userFolder = [fileDocument stringByAppendingPathComponent:folder];
    if (![fileManager fileExistsAtPath:userFolder]) {
        [fileManager createDirectoryAtPath:userFolder withIntermediateDirectories:NO attributes:nil error:nil];
    }
    NSString *uuidStr = [self genUUID];
    NSString *fileName = [folder stringByAppendingPathComponent:[uuidStr stringByAppendingPathExtension:@"jpg"]];
    
    NSString *imageFilePath = [fileDocument stringByAppendingPathComponent:fileName]; //得到当前照片的路径
//    CGSize coreSize = CGSizeMake(960, 960);
//    UIImage *bigImage = nil;
//    
//    UIGraphicsBeginImageContext(coreSize);
//    [image drawInRect:[Util_UI frameSize:image.size inSize:coreSize]];
//    bigImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    if ([UIImageJPEGRepresentation(image, 0.96) writeToFile:imageFilePath atomically:YES]) {
        DLog(@"save bigImage yes");
    }else{
        DLog(@"save bigImage wrong");
    }
    
//    NSString *thumbImageFilePath = [self createThumbImageNameWith:imageFilePath]; //得到照片路径
//    UIImage *thumbImage = nil;
//    coreSize = CGSizeMake(260, 260);
//    UIGraphicsBeginImageContext(coreSize);
//    [image drawInRect:[Util_UI frameSize:image.size inSize:coreSize]];
//    bigImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    if ([UIImageJPEGRepresentation(thumbImage, 1) writeToFile:thumbImageFilePath atomically:YES]) {
//        DLog(@"save thumbImage yes");
//    }else{
//        DLog(@"save thumbImage wrong");
//    }
    
    DLog(@"fileName imgUrl--[%@]", fileName);
    
    return fileName;
}

+ (NSString *)createThumbImageNameWith:(NSString *)path{
    NSString *thumbName = [NSString stringWithFormat:@"%@_thumb.%@", [path stringByDeletingPathExtension], [path pathExtension]];
    return thumbName;
}

+ (E_Photo *)getNewE_Photo {
    E_Photo *ep = [[E_Photo alloc] initWithEntity:[NSEntityDescription entityForName:@"E_Photo" inManagedObjectContext:[[RTCoreDataManager sharedInstance] managedObjectContext]] insertIntoManagedObjectContext:nil];
    
    return ep;
}

@end
