//
//  AXMessageLocationCell.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 3/18/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import "AXMessageLocationCell.h"
@interface AXMessageLocationCell ()
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@end

@implementation AXMessageLocationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initData];
        // Initialization code
    }
    return self;
}

- (void)initData {
    self.dataDic = [NSDictionary dictionary];
}

- (void)dealloc {
    self.dataDic = nil;
    self.locationLabel = nil;
}

- (void)initUI {
    [super initUI];
    
    self.mapIMGView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.mapIMGView];
    
    self.locationLabel = [[UILabel alloc] init];
    self.locationLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.locationLabel.numberOfLines = 2;
    self.locationLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.locationLabel];
    
    self.mapControl = [[UIControl alloc] init];
    self.mapControl.backgroundColor = [UIColor clearColor];
    [self.mapControl addTarget:self action:@selector(didClickMap) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.mapControl];
    
    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activity.hidden = YES;
    self.activity.frame = CGRectMake(40, 3, 25, 25);
    //    [self.activityIndicatorView startAnimating];
    [self.locationLabel addSubview:self.activity];
    
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                             action:@selector(handleLongPressGesture:)];
    [recognizer setMinimumPressDuration:0.4f];
    [self.mapControl addGestureRecognizer:recognizer];
}

- (void)configWithData:(NSDictionary *)data
{
    [super configWithData:data];
    self.locationLabel.text = nil;
    self.dataDic = [data[@"content"] JSONValue];
    CGRect frame = CGRectMake(0.0f, 0.0f, 120.0f, 120.0f);
    
    if (self.messageSource == AXChatMessageSourceDestinationIncoming) {
        frame.origin.x = kJSAvatarSize +40;
    }else {
        frame.origin.x = 320 - kJSAvatarSize - 40 - frame.size.width;
    }
    
    [self setBubbleIMGByImgFrame:frame];
    
    self.mapIMGView.image = [UIImage imageNamed:@"anjuke_icon_map.png"];
    self.mapIMGView.layer.cornerRadius = 6.0f;
    self.mapIMGView.layer.masksToBounds = YES;
    
    if ([self.dataDic[@"address"] length] == 0) {
        [self getGeoLocation];
    }else {
        self.locationLabel.text = self.dataDic[@"address"];
        
    }
    
    [self configWithStatus];
}


- (void)setBubbleIMGByImgFrame:(CGRect) rect{
    if (self.messageSource == AXChatMessageSourceDestinationIncoming) {
        
        self.mapIMGView.frame = CGRectMake(kJSAvatarSize + 30.0f, 12.0f, rect.size.width, rect.size.height);
        if (self.isBroker) {
            self.bubbleIMG.frame = CGRectMake(self.mapIMGView.frame.origin.x - 9.0f, 10.0f, rect.size.width + 9.0f + 2.0f, rect.size.height + 4.0f);
        } else {
            self.bubbleIMG.frame = CGRectMake(self.mapIMGView.frame.origin.x - 7.0f, 18.0f, rect.size.width + 9.0f, rect.size.height + 4.0f);
        }
    } else {
        self.mapIMGView.frame = CGRectMake(320.0f - kJSAvatarSize - 20.0f - rect.size.width - 7.0f, 12.0f, rect.size.width, rect.size.height);
        self.bubbleIMG.frame = CGRectMake(self.mapIMGView.frame.origin.x - 2.0f, 10.0f, rect.size.width + 4.0f + 5.0f + 2.0f, rect.size.height + 4.0f);
        
    }


    CGRect frame = self.mapIMGView.frame;
    frame.origin.y += 80.0f;
    frame.size.height -= 80.0f;
    self.locationLabel.frame = frame;
    self.locationLabel.textAlignment = NSTextAlignmentCenter;
    self.locationLabel.backgroundColor = [UIColor blackColor];
    self.locationLabel.alpha = 0.7;
    self.locationLabel.textColor = [UIColor whiteColor];
    
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.locationLabel.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(6, 6)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.locationLabel.bounds;
    maskLayer.path = maskPath.CGPath;
    self.locationLabel.layer.mask = maskLayer;
    
    self.mapControl.frame = self.bubbleIMG.frame;
}

- (void)getGeoLocation{
    [self.activity startAnimating];
    self.activity.hidden = NO;
    CGFloat locallat = [[self.dataDic objectForKey:@"lat"] floatValue];
    CGFloat locallng = [[self.dataDic objectForKey:@"lng"] floatValue];
    [[RTRequestProxy sharedInstance] geoWithLat:[NSString stringWithFormat:@"%f", locallat] lng:[NSString stringWithFormat:@"%f", locallng] target:self action:@selector(geoDidFinishGetAddress:)];
}

- (void)geoDidFinishGetAddress:(RTNetworkResponse *) response {
//    [self.activity stopAnimating];
    if ([response.content[@"status"] isEqualToString:@"OK"]) {
#warning TODO 需不需要此功能！
    }
//    if ([self.dataDic[@"address"] length] > 0) {
//        self.locationLabel.text = self.dataDic[@"address"];
//    }else {
//        self.locationLabel.text = @"中国上海市 浦东新区 东方路1217号 陆家嘴金融服务广场";
//    }
}

- (void)didClickMap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickMapCell:)]) {
        [self.delegate didClickMapCell:self.dataDic];
    }
}

@end
