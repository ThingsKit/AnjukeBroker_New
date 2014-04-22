//
//  AXDownLoadModule.h
//  Anjuke2
//
//  Created by 杨 志豪 on 4/2/14.
//  Copyright (c) 2014 anjuke inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AXDownLoadRequestResponse.h"

typedef NS_ENUM(NSUInteger, AJKDownLoadModuleDownLoadStatus)
{
    AJKDownLoadModuleDownLoadStatusSuccessful,
    AJKDownLoadModuleDownLoadStatusFailed,
};

@interface AXDownLoadModule : NSObject
+ (id)shareInstance;
- (id)init;
- (void)cancleAllRequest;
- (NSUInteger)currentCountOfOperations;
- (void)cancleOperationWithIdentify:(NSString *)identify;
//download method
- (void)downLoadWithHostAddress:(NSString *)api methodName:(NSString *)methodName isCheck:(BOOL)isCheck identify:(NSString *)identify callBack:(NSString *)callBack target:(id)target type:(AJKDownLoadModuleDownLoadType )type;
- (void)downLoadWithUrlString:(NSURL *)url identify:(NSString *)identify callBack:(NSString *)callBack target:(id)target type:(AJKDownLoadModuleDownLoadType )type;

//upload method
/*
 postData is NSData or NSString,if upload voice,postData is NSData,if upload image postData is filePath which is NSString
 */
- (void)upLoadWithHostAddress:(NSString *)api postData:(id)postData methodName:(NSString *)methodName isCheck:(BOOL)isCheck identify:(NSString *)identify callBack:(NSString *)callBack target:(id)target type:(AJKDownLoadModuleDownLoadType )type;
- (void)upLoadWithUrlString:(NSURL *)url postData:(id)postData identify:(NSString *)identify callBack:(NSString *)callBack target:(id)target type:(AJKDownLoadModuleDownLoadType )type;


@end
