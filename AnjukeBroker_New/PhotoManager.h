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

@interface PhotoManager : NSObject

+ (NSString *)saveImageFile:(UIImage *)image toFolder:(NSString *)folder; //保存图片并得到图片路径
+ (NSString *)getDocumentPath:(NSString *)path; //得到图片文件路径

+ (E_Photo *)getNewE_Photo;

@end
