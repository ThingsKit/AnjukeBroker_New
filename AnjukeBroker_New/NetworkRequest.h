//
//  NetworkRequest.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-13.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

typedef void(^RequestDidFinishBlock) (id result);

@interface NetworkRequest : NSObject

+ (ASIHTTPRequest*) requestWithURL:(NSString*)urlString
                            params:(NSMutableDictionary*)params
                        httpMethod:(NSString*)httpMethod
             requestDidFinishBlock:(RequestDidFinishBlock)requestDidFinishBlock;



@end
