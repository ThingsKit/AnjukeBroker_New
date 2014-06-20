//
//  AXChatBaseCell.m
//  Anjuke2
//
//  Created by Gin on 3/2/14.
//  Copyright (c) 2014 anjuke inc. All rights reserved.
//

#import "AXChatBaseCell.h"

@implementation AXChatBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)configAvatar:(AXMappedPerson *)person
{
    
}

- (void)configWithData:(NSDictionary *)data
{
    
}

- (void)configWithIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
