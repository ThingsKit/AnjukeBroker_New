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

//二手房图片上传数量限制
#define AJK_MAXCOUNT_ROOMIMAGE 10
#define AJK_MAXCOUNT_HOUSETYPEIMAGE 4
#define AJK_MAXCOUNT_ALLIMAGE AJK_MAXCOUNT_ROOMIMAGE +AJK_MAXCOUNT_HOUSETYPEIMAGE //室内图、户型图的上传上限

//租房图片上传数量限制
#define HZ_MAXCOUNT_ROOMIMAGE 8
#define HZ_MAXCOUNT_HOUSETYPEIMAGE 2
#define HZ_MAXCOUNT_ALLIMAGE HZ_MAXCOUNT_ROOMIMAGE +HZ_MAXCOUNT_HOUSETYPEIMAGE //室内图、户型图的上传上限

#define MAX_ROOMPHOTO_ALERT_MESSAGE @"室内图最多只能添加8张"
#define MAX_HOUSETYPEPHOTO_ALERT_MESSAGE @"房型图最多只能添加2张"

#define _DEFULT_TITLE_FITMENT @"精装修"
#define _DEFULT_TITLE_EXPOSURE @"南北"
#define _DEFULT_TITLE_ROOM @"1室"

@interface PhotoManager : NSObject

+ (NSString *)saveImageFile:(UIImage *)image toFolder:(NSString *)folder; //保存图片并得到图片路径
+ (NSString *)getDocumentPath:(NSString *)path; //得到图片文件路径

+ (E_Photo *)getNewE_Photo;
+ (NSArray *)transformRoomImageArrToFooterShowArrWithArr:(NSArray *)imageArr; //将室内图array转换为footer可显示的数组--抽取imageUrl
+ (NSArray *)transformHouseTypeImageArrToFooterShowArrWithArr:(NSArray *)imageArr;
+ (NSArray *)transformOnlineHouseTypeImageArrToFooterShowArrWithArr:(NSDictionary *)imageDic;

//是否能添加更多室内图
+ (BOOL)canAddMoreRoomImageForImageArr:(NSArray *)imageArr isHaozu:(BOOL)isHaozu;
//根据二手房、好租和室内图、房型图返回提示文案
+ (NSString *)getImageMaxAlertStringForHaozu:(BOOL)isHaozu isHouseType:(BOOL)isHouseType;

@end
