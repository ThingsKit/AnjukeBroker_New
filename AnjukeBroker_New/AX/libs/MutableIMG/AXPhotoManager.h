//
//  AXPhotoManager.h
//  Anjuke2
//
//  Created by jianzhongliu on 2/26/14.
//  Copyright (c) 2014 anjuke inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AXPhotoManager : NSObject
+ (NSString *)getLibrary:(NSString *)path;
+ (NSString *)saveImageFile:(UIImage *)image toFolder:(NSString *)folder whitChatId:(NSString *)chatId andIMGName:(NSString *) IMGName;
@end
