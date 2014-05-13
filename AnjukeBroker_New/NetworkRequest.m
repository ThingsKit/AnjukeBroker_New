//
//  NetworkRequest.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-13.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "NetworkRequest.h"
#import "JSONKit.h"

#define BASE_URL @"https://open.weibo.cn/2/"

@implementation NetworkRequest

+ (ASIHTTPRequest*) requestWithURL:(NSString*)urlString
                            params:(NSMutableDictionary*)params
                        httpMethod:(NSString*)httpMethod
             requestDidFinishBlock:(RequestDidFinishBlock)requestDidFinishBlock {
    
    //    https://open.weibo.cn/2/statuses/home_timeline.json?count=20&access_token=2.00Yx3zxBlDwHfD37be1192618_FZCE
    //---------获取access_token并完成基本拼接
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* accessToken = [[defaults objectForKey:@"SinaWeiboAuthData"] objectForKey:@"AccessTokenKey"];
    urlString = [BASE_URL stringByAppendingFormat:@"%@?access_token=%@", urlString, accessToken];
    
    //---------如果是GET请求,那么继续将请求参数拼接到urlString
    if ([@"GET" caseInsensitiveCompare:httpMethod] == NSOrderedSame) {
        NSArray* keys = [params allKeys];
        NSMutableString* keyValue = [NSMutableString stringWithCapacity:0];
        for (int i=0; i<keys.count; i++) {
            id value = [params objectForKey:keys[i]];
            [keyValue appendFormat:@"%@=%@", keys[i], value];
            if (i < keys.count-1) {
                [keyValue appendString:@"&"]; //每一组键值对后加上一个&
            }
        }
        
        if (keyValue.length > 0) { //有参数就追加
            urlString = [urlString stringByAppendingFormat:@"&%@", keyValue];
        }
    }
    
    //    NSLog(@"%@", urlString);
    
    NSURL* url = [NSURL URLWithString:urlString];
    //---------局部变量防止block中被加持
    __block ASIFormDataRequest* request = [[ASIFormDataRequest alloc] initWithURL:url];
    [request setTimeOutSeconds:60];
    [request setRequestMethod:httpMethod];
    
    //---------如果是POST请求,设置请求参数
    if ([@"POST" caseInsensitiveCompare:httpMethod] == NSOrderedSame) {
        NSArray* keys = [params allKeys];
        for (NSString* key in keys) {
            id value = [params objectForKey:key];
            if ([value isKindOfClass:[NSData class]]) { //如果是NSData类型的值
                [request addData:value forKey:key];
            } else {
                [request addPostValue:value forKey:key]; //普通值
            }
        }
    }
    
    //设置请求完成的completionBlock
    [request setCompletionBlock:^{
        NSData* data = request.responseData; //局部变量__block修饰防止加持
        //解析JSON结果
        id result = nil;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0")) {
            result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        } else {
            result = [data objectFromJSONData];
        }
        requestDidFinishBlock(result); //调用参数block抛出解析后的结果
        
    }];
    
    [request startAsynchronous]; //请求开始异步调用
    
    return request;
}

@end
