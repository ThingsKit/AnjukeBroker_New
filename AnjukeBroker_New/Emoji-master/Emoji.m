//
//  Emoji.m
//  Emoji
//
//  Created by Aliksandr Andrashuk on 26.10.12.
//  Copyright (c) 2012 Aliksandr Andrashuk. All rights reserved.
//

#import "Emoji.h"
#import "EmojiEmoticons.h"
#import "EmojiMapSymbols.h"
#import "EmojiPictographs.h"
#import "EmojiTransport.h"

@implementation Emoji
+ (NSString *)emojiWithCode:(int)code {
    int sym = EMOJI_CODE_TO_SYMBOL(code);
    return [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
}
+ (NSArray *)allEmoji {
    NSArray* emojis = @[@"\U0001f603", @"\U0001f60a", @"\ufe0f", @"\U0001f609", @"\U0001f60d", @"\U0001f618", @"\U0001f61a",
                        @"\U0001f61c",@"\U0001f61d",@"\U0001f61b",@"\U0001f633", @"\U0001f601", @"\U0001f614", @"\U0001f60c"
                        ];
    
    NSMutableArray *array = [NSMutableArray new];
    [array addObjectsFromArray:[EmojiEmoticons allEmoticons]];
    [array addObjectsFromArray:[EmojiMapSymbols allMapSymbols]];
    [array addObjectsFromArray:[EmojiPictographs allPictographs]];
    [array addObjectsFromArray:[EmojiTransport allTransport]];
    
    return array;
}
@end
