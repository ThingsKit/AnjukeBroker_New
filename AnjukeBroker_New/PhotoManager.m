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
    
    if ([UIImageJPEGRepresentation(image, 0.96) writeToFile:imageFilePath atomically:YES]) {
//        DLog(@"save bigImage yes");
    }else{
//        DLog(@"save bigImage wrong");
    }
    
//    DLog(@"fileName imgUrl--[%@]", fileName);
    
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

//将室内图array转换为footer可显示的数组--抽取imageUrl
+ (NSArray *)transformRoomImageArrToFooterShowArrWithArr:(NSArray *)imageArr {
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i = 0; i < imageArr.count; i ++) {
        NSString *url = [NSString string];
        url = [(E_Photo *)[imageArr objectAtIndex:i] smallPhotoUrl];
        [arr addObject:url];
    }
    
    return arr;
}

//将室内图array转换为footer可显示的数组--抽取imageUrl
+ (NSArray *)transformHouseTypeImageArrToFooterShowArrWithArr:(NSArray *)imageArr{
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i = 0; i < imageArr.count; i ++) {
        NSString *url = [NSString string];
        url = [(E_Photo *)[imageArr objectAtIndex:i] smallPhotoUrl];
        [arr addObject:url];
    }
    
    return arr;
}

+ (NSArray *)transformOnlineHouseTypeImageArrToFooterShowArrWithArr:(NSDictionary *)imageDic{
    NSMutableArray *arr = [NSMutableArray array];
    
    if (imageDic.count > 0) {
        [arr addObject:[imageDic objectForKey:@"url"]];
    }
    
    return arr;
}

//编辑房源已有图片数组转换
+ (NSArray *)transformEditImageArrToFooterShowArrWithArr:(NSArray *)imageArray{
    NSMutableArray *arr = [NSMutableArray array];
    
    if (imageArray.count > 0) {
        for (int i = 0; i < imageArray.count; i ++) {
            [arr addObject:[[imageArray objectAtIndex:i] objectForKey:@"imgUrl"]];
        }
    }
    
    return arr;
}

//是否能添加更多室内图
+ (BOOL)canAddMoreRoomImageForImageArr:(NSArray *)imageArr isHaozu:(BOOL)isHaozu type:(NSInteger)type
{
    BOOL canAdd = NO;
    int maxCount = 0;
    int addCount = 1; //再添加一张图片后判断
    
    if (type == 1)
    {
        maxCount = AJK_MAXCOUNT_ROOMIMAGE;
    }else if (type == 2)
    {
        maxCount = AJK_MAXCOUNT_HOUSETYPEIMAGE;
    }
    
    if (isHaozu)
    {
        if (type == 1)
        {
            maxCount = HZ_MAXCOUNT_ROOMIMAGE;
        }else if (type == 2)
        {
            maxCount = HZ_MAXCOUNT_HOUSETYPEIMAGE;
        }
        
    }
    if (addCount + imageArr.count <= maxCount) {
        canAdd = YES;
    }
    
    return canAdd;
}

+ (NSString *)getImageMaxAlertStringForHaozu:(BOOL)isHaozu isHouseType:(BOOL)isHouseType {
    NSString *alertStr = [NSString string];
    NSString *title = @"室内图";
    
    int maxCount = 0;
    
    if (isHaozu) {
        if (isHouseType) {
            maxCount = HZ_MAXCOUNT_HOUSETYPEIMAGE;
            title = @"户型图";
        }
        else
            maxCount = HZ_MAXCOUNT_ROOMIMAGE;
    }
    else {
        if (isHouseType) {
            maxCount = AJK_MAXCOUNT_HOUSETYPEIMAGE;
            title = @"户型图";
        }
        else
            maxCount = AJK_MAXCOUNT_ROOMIMAGE;
    }
    
    alertStr = [NSString stringWithFormat:@"%@最多上传%d张", title, maxCount];
    
    return alertStr;
}

@end
