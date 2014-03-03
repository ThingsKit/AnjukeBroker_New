//
//  AXCellFactory.m
//  Anjuke2
//
//  Created by Gin on 3/2/14.
//  Copyright (c) 2014 anjuke inc. All rights reserved.
//

#import "AXCellFactory.h"
#import "AXMappedMessage.h"
#import "AXChatMessageRoomSourceCell.h"
#import "AXChatMessageTextCell.h"
#import "AXChatMessagePublicCardCell.h"
#import "AXChatMessagePublicCardCell.h"
#import "AXChatMessageImageCell.h"
#import "AXChatMessageSystemTimeCell.h"

@implementation AXCellFactory

+ (AXChatBaseCell *)cellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath withObject:(NSDictionary *)dic withIdentity:(NSString *)identity
{
    AXChatBaseCell *cell = nil;
    if (![identity isEqualToString:@"AXChatCell1"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:identity];
    }
    if (cell == nil) {
        // init
        switch ([dic[@"messageType"] integerValue]) {
            case AXMessageTypeProperty:
            {
                cell = [[AXChatMessageRoomSourceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
            }
                break;
            case AXMessageTypeText:
            {
                cell = [[AXChatMessageTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
            }
                break;
            case AXMessageTypePublicCard:
            {
                cell = [[AXChatMessagePublicCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
            }
            case AXMessageTypePic:
            {
                cell = [[AXChatMessageImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
            }
                break;
            default:
            {
                cell = [[AXChatMessageSystemTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
            }
                break;
        }
    }
    
    // config
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

@end
