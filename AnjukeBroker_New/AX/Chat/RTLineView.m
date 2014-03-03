//
//  RTLineView.m
//  UIComponents
//
//  Created by liu lh on 13-6-19.
//  Copyright (c) 2013年 anjuke inc. All rights reserved.
//

#import "RTLineView.h"
#import "RTUISetting.h"

@implementation RTLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.nickLineColors = [NSArray nickColors];
        self.borderWidth = 1.0;
        self.horizontalLine = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat halfLineWidth = self.borderWidth / 2.0f;
    
    if (self.horizontalLine) {
        CGFloat lineTop = CGRectGetMaxY(rect) - halfLineWidth;
        CGFloat lineWidth = rect.size.width;
        CGContextSetStrokeColorWithColor(ctx, [[self.nickLineColors objectAtIndex:0] CGColor]);
        CGContextSetLineWidth(ctx, self.borderWidth);
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, rect.origin.x, lineTop);
        CGContextAddLineToPoint(ctx, lineWidth, lineTop);
        CGContextStrokePath(ctx);
        
        CGContextSetStrokeColorWithColor(ctx, [[self.nickLineColors objectAtIndex:1] CGColor]);
        CGContextSetLineWidth(ctx, self.borderWidth);
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, rect.origin.x, CGRectGetMaxY(rect));
        CGContextAddLineToPoint(ctx, lineWidth, CGRectGetMaxY(rect));
        CGContextStrokePath(ctx);
    }else{
        CGFloat lineTop = CGRectGetMaxX(rect) - halfLineWidth;
        CGFloat lineHeight = rect.size.height;
        CGContextSetStrokeColorWithColor(ctx, [[self.nickLineColors objectAtIndex:0] CGColor]);
        CGContextSetLineWidth(ctx, self.borderWidth);
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, lineTop, rect.origin.y);
        CGContextAddLineToPoint(ctx, lineTop, lineHeight);
        CGContextStrokePath(ctx);
        
        CGContextSetStrokeColorWithColor(ctx, [[self.nickLineColors objectAtIndex:1] CGColor]);
        CGContextSetLineWidth(ctx, self.borderWidth);
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, CGRectGetMaxX(rect), rect.origin.y);
        CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), lineHeight);
        CGContextStrokePath(ctx);
    }

}


@end
