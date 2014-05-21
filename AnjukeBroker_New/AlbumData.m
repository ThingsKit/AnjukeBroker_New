//
//  AlbumData.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-21.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "AlbumData.h"

@implementation AlbumData

static AlbumData* defaultAlbumData;

+ (AlbumData*)sharedAlbumData{
    @synchronized(self){//确保同一时刻只有一个线程调用,确保不会产生两个对象
        if (defaultAlbumData == nil) {
            defaultAlbumData = [[AlbumData alloc] init];
        }
    }
    return defaultAlbumData;
}

@end
