//
//  AXDownLoadRequestElement.h
//  Anjuke2
//
//  Created by 杨 志豪 on 4/3/14.
//  Copyright (c) 2014 anjuke inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface AXDownLoadRequestElement : NSObject
@property (nonatomic, strong) NSString *identify;
@property (nonatomic, weak) id    target;
@property (nonatomic, strong) NSString *callback;
@end
