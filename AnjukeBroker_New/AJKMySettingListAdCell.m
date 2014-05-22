//
//  AJKMySettingListAdCell.m
//  Anjuke2
//
//  Created by Gin on 2/17/14.
//  Copyright (c) 2014 anjuke inc. All rights reserved.
//

#import "AJKMySettingListAdCell.h"
#import <iAd/iAd.h>

@interface AJKMySettingListAdCell () <ADBannerViewDelegate>

@property (nonatomic, strong) ADBannerView *banner;

@end

@implementation AJKMySettingListAdCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _banner = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
        _banner.frame = CGRectMake(0, 0, 320, 50);
        _banner.userInteractionEnabled = YES;
        _banner.delegate = self;
        [self.contentView addSubview:_banner];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}

#pragma mark iAd Delegate Methods
- (void)bannerViewWillLoadAd:(ADBannerView *)banner
{

}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{

}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
}

@end
