//
//  AlbumData.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-21.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlbumData : NSObject

@property (nonatomic, strong) NSMutableArray* albumDicts;
@property (nonatomic, strong) NSMutableArray* albumArray;
@property (nonatomic, assign) BOOL hasTextView;
@property (nonatomic, assign) BOOL isRemoteImage; //图片是否网络下载, 默认从本地取出

+ (AlbumData*)sharedAlbumData;

@end
