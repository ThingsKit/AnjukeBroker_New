//
//  CellHeight.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 12/26/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "CellHeight.h"
#import "Util_UI.h"

@implementation CellHeight

+ (CGFloat)getBidCellHeight:(NSString *) title{
//    CGSize size = CGSizeMake(260, 40);
    CGSize si = [Util_UI sizeOfString:title maxWidth:260 withFontSize:14];//[title sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    return si.height+98.0f;

//    return 2.1;
}

+ (CGFloat)getFixedCellHeight:(NSString *) title{
//    CGSize size = CGSizeMake(260, 40);
    CGSize si = [Util_UI sizeOfString:title maxWidth:260 withFontSize:14];//[title sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    return si.height+50.0f;
}

+ (CGFloat)getNoPlanCellHeight:(NSString *) title{
//    CGSize size = CGSizeMake(250, 40);
    CGSize si = [Util_UI sizeOfString:title maxWidth:250 withFontSize:14];//[title sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    return si.height+40.0f;
}
@end
