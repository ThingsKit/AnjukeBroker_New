//
//  FaceImageView.m
//  WeiboDemo1
//
//  Created by leo.zhu on 14-2-1.
//  Copyright (c) 2014年 3k. All rights reserved.
//

#import "FaceView.h"
#import "UIViewExt.h"

#import "Emoji.h"
#import "EmojiEmoticons.h"
#import "EmojiMapSymbols.h"
#import "EmojiPictographs.h"
#import "EmojiTransport.h"

#define FACE_WIDTH 42
#define FACE_HEIGHT 48
#define PADDING_WIDTH 20
#define PADDING_HEIGHT 20
#define PAGE_COUNT 3

@interface FaceView ()

@property (nonatomic, strong) NSMutableArray* items;
@property (nonatomic, strong) UIImageView* magnifier;
@property (nonatomic, strong) UIImageView* icon;
@property (nonatomic, strong) UILabel* labelIcon;

@end


@implementation FaceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
    }
    return self;
}

/*
NSArray = [
            [@"1", @"2", @"3", @"", @"...", @"28"],
            [@"", @"", @"", @"", @"", @""],
            [@"", @"", @"", @"", @"", @""],
            [@"", @"", @"", @"", @"", @""]
          ];
 
 
*/

- (NSArray*)emojis{
    return [Emoji allEmoji];
}

- (void)initData {
    self.items = [NSMutableArray arrayWithCapacity:PAGE_COUNT];
    //---------------------------整理plist成为一个二维数组------------------------
    NSArray* faces = [Emoji allEmoji];
    
    NSMutableArray* item2Ds;
    for (int i = 0; i< faces.count; i++) {
        NSString* code = [faces objectAtIndex:i];
        
        if (i % 21 == 0) {
            item2Ds = [[NSMutableArray alloc] initWithCapacity:21];
            [self.items addObject:item2Ds];
        }
        [item2Ds addObject:code];
    }
    
    //---------------------------设置尺寸--------------------------
    self.width = PAGE_COUNT * ScreenWidth;
    self.height = 3 * FACE_HEIGHT + 5;
    self.backgroundColor = [UIColor clearColor];
    
    //初始化放大镜
    self.magnifier = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 60)];
    self.magnifier.image = [UIImage imageNamed:@"emoji_touch"];
    self.magnifier.hidden = YES;
    [self addSubview:self.magnifier];
    
    self.labelIcon = [[UILabel alloc] initWithFrame:CGRectMake(45/2-30/2, 7, 30, 28)];
    self.labelIcon.backgroundColor = [UIColor clearColor];
    [self.labelIcon setFont:[UIFont fontWithName:@"AppleColorEmoji" size:30.0]];
    [self.magnifier addSubview:self.labelIcon];
    
    self.pageNumber = PAGE_COUNT;
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    int row = 0, column = 0;
    for (int i = 0; i< self.items.count; i++) {
        NSArray* page = [self.items objectAtIndex:i];
        for (int j = 0; j< page.count; j++) {
            NSString* name = [page objectAtIndex:j];
            
            CGRect frame = CGRectMake(PADDING_WIDTH + column*FACE_WIDTH, PADDING_HEIGHT + row*FACE_HEIGHT, 30, 30);
            
            //考虑页数
            float x =   i*ScreenWidth + frame.origin.x;
            frame.origin.x = x;
            
            if (row == 2 && column == 6) {
                UIImage* image = [UIImage imageNamed:@"faceDelete"];
                [image drawInRect:frame];
            }else{
                UILabel* label = [[UILabel alloc] initWithFrame:frame];
                [label setFont:[UIFont fontWithName:@"AppleColorEmoji" size:30.0]];
                label.text = name;
                [label drawTextInRect:frame];
            }
            
            column++;
            if (column % 7 == 0) {
                row++;
                column = 0;
            }
            
            if (row == 3) {
                row = 0;
            }
            
        }
        
        
    }
}

#pragma mark -
#pragma mark UIResponder
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self coordinateCaculator:point];
    
    [self showMagnifier];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if ([self coordinateCaculator:point]) {
        [self showMagnifier];
    }else{
        [self hideMagnifier];
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self hideMagnifier];
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if ([self coordinateCaculator:point]) {
        if (self.faceClickBlock != nil) {
            //        __block FaceView* this = self; //这里不需要,因为block没有引用全局变量对象,只是传入参数
            _faceClickBlock(_selectedItemName); //因为block会调用多次,所以不可以在这里释放
        }
        //    NSLog(@"%d", _selectedItemName.retainCount);
    }

}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self hideMagnifier];
}

- (void)showMagnifier {
    self.magnifier.hidden = NO;
    //移动的时候禁止scroll滑动
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView* scrollView = (UIScrollView*)self.superview;
        scrollView.scrollEnabled = NO;
    }
}

- (void)hideMagnifier {
    self.magnifier.hidden = YES;
    //触摸结束开启scroll滑动
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView* scrollView = (UIScrollView*)self.superview;
        scrollView.scrollEnabled = YES;
    }
}

- (BOOL)coordinateCaculator:(CGPoint)point{
    int x = floor(point.x);
    int y = floor(point.y);
    x -= PADDING_WIDTH;
    y -= PADDING_HEIGHT;
    int page = floor(x/320);
    x %=320;
    
    int column = floor(x/FACE_WIDTH);
    int row = floor(y/FACE_HEIGHT);
    
    if (column > 6) {
//        column = 6;
    }
    if (column < 0) {
//        column = 0;
    }
    if (row > 2) {
//        row = 2;
    }
    if (row < 0) {
//        row = 0;
    }
    int index = row*7 + column;
    NSArray* item2D = [self.items objectAtIndex:page];
    if (index < item2D.count) {
        if (row == 2 && column == 6) {
            self.selectedItemName = @"delete";
        }else{
            NSString* name = [item2D objectAtIndex:index];
            //性能优化
            if (![name isEqualToString:_selectedItemName]) {
                self.selectedItemName = name;
                self.labelIcon.text = name;
                self.magnifier.origin = CGPointMake(ScreenWidth*page + PADDING_WIDTH + FACE_WIDTH*column -8, PADDING_HEIGHT + FACE_HEIGHT*row - 50);
            }
        }
        return YES;
    }else{
        return NO;
    }
    
}

@end
