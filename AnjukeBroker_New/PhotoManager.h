//
//  PhotoManager.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-12.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "E_Photo.h"

#define PHOTO_FOLDER_NAME @"AJK_Broker"
#define API_PhotoUpload @"http://upd1.ajkimg.com/upload"

#define ROOM_IMAGE_MAX 8
#define HOUSETYPE_IMAGE_MAX 2
#define IMAGE_ALL_MAX ROOM_IMAGE_MAX +HOUSETYPE_IMAGE_MAX //室内图、户型图的上传上限

#define MAX_ROOMPHOTO_ALERT_MESSAGE @"室内图最多只能添加8张"
#define MAX_HOUSETYPEPHOTO_ALERT_MESSAGE @"房型图最多只能添加2张"

@interface PhotoManager : NSObject

+ (NSString *)saveImageFile:(UIImage *)image toFolder:(NSString *)folder; //保存图片并得到图片路径
+ (NSString *)getDocumentPath:(NSString *)path; //得到图片文件路径

+ (E_Photo *)getNewE_Photo;
+ (NSArray *)transformRoomImageArrToFooterShowArrWithArr:(NSArray *)imageArr; //将室内图array转换为footer可显示的数组--抽取imageUrl


@end
