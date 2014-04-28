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
//    NSArray* emojis = @[@"\U0001f603", @"\U0001f60a", @"\u263a", @"\U0001f609", @"\U0001f60d", @"\U0001f618", @"\U0001f61a",
//                        @"\U0001f61c", @"\U0001f61d", @"\U0001f61b", @"\U0001f633", @"\U0001f601", @"\U0001f614", @"\U0001f60c",
//                        @"\U0001f612", @"\U0001f61e", @"\U0001f623", @"\U0001f622", @"\U0001f602", @"\U0001f62d", @"",
//                        
//                        @"\U0001f62a", @"\U0001f630", @"\U0001f605", @"\U0001f613", @"\U0001f629", @"\U0001f628", @"\U0001f631",
//                        @"\U0001f621", @"\U0001f624", @"\U0001f616", @"\U0001f637", @"\U0001f60e", @"\U0001f634", @"\U0001f632",
//                        @"\U0001f61f", @"\U0001f627", @"\U0001f610", @"\U0001f62f", @"\U0001f636", @"\U0001f607", @"",
//                        
//                        @"\U0001f60f", @"\U0001f611", @"\U0001f44d", @"\U0001f44e", @"\U0001f44c", @"\U0001f44a", @"\u270a",
//                        @"\u270c", @"\U0001f44b", @"\u270b", @"\U0001f450", @"\U0001f446", @"\U0001f447", @"\U0001f449",
//                        @"\U0001f448", @"\U0001f64c", @"\U0001f64f", @"\u261d", @"\U0001f44f", @"\U0001f4aa", @""
//                        ];
    
    NSArray* emojis = @[@"\U0001f604", @"\U0001f60A", @"\U0001f603", @"\u263A", @"\U0001f609", @"\U0001f60D", @"\U0001f618",
                        @"\U0001f61A", @"\U0001f633", @"\U0001f60C", @"\U0001f601", @"\U0001f61C", @"\U0001f61D", @"\U0001f612",
                        @"\U0001f60F", @"\U0001f613", @"\U0001f614", @"\U0001f61E", @"\U0001f616", @"\U0001f625", @"",
                        
                        @"\U0001f630", @"\U0001f628", @"\U0001f623", @"\U0001f622", @"\U0001f62D", @"\U0001f602", @"\U0001f632",
                        @"\U0001f631", @"\U0001f620", @"\U0001f621", @"\U0001f62A", @"\U0001f637", @"\U0001f47F", @"\U0001f47D",
                        @"\U0001f49B", @"\U0001f499", @"\U0001f49C", @"\U0001f497", @"\U0001f49A", @"\u2764", @"",
                        
                        @"\U0001f494", @"\U0001f493", @"\U0001f498", @"\u2728", @"\U0001f44D", @"\U0001f44E", @"\U0001f44C",
                        @"\U0001f44A",@"\u270A",  @"\u270C", @"\U0001f44B", @"\u270B", @"\U0001f450", @"\U0001f446",
                        @"\U0001f447", @"\U0001f449", @"\U0001f448", @"\U0001f64C", @"\U0001f64F", @"\U0001f44F", @""
                        ];
    
//    NSMutableArray *emojis = [NSMutableArray new];
//    [emojis addObjectsFromArray:[EmojiEmoticons allEmoticons]];
//    [emojis addObjectsFromArray:[EmojiMapSymbols allMapSymbols]];
//    [emojis addObjectsFromArray:[EmojiPictographs allPictographs]];
//    [emojis addObjectsFromArray:[EmojiTransport allTransport]];
    
    return emojis;
}
@end
