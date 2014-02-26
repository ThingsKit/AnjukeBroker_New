//
//  SSPullToRefreshSimpleContentView.m
//  SSPullToRefresh
//
//  Created by Sam Soffes on 5/17/12.
//  Copyright (c) 2012 Sam Soffes. All rights reserved.
//

#import "AXPullToRefreshContentView.h"

@implementation AXPullToRefreshContentView

@synthesize statusLabel = _statusLabel;
@synthesize activityIndicatorView = _activityIndicatorView;
@synthesize arrowImageView = _arrowImageView;

#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		CGFloat width = self.bounds.size.width;
        self.backgroundColor = [UIColor clearColor];
		
		_statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 14.0f, width, 20.0f)];
		_statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_statusLabel.font = [UIFont systemFontOfSize:24/2];
		_statusLabel.textColor = [UIColor grayColor];
		_statusLabel.backgroundColor = [UIColor clearColor];
		_statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.shadowColor = [UIColor whiteColor];
        _statusLabel.shadowOffset = CGSizeMake(0, 1);
		[self addSubview:_statusLabel];
		
		_activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		_activityIndicatorView.frame = CGRectMake(30.0f, 25.0f, 20.0f, 20.0f);
		[self addSubview:_activityIndicatorView];
        _activityIndicatorView.hidden = YES;
        
		_arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rt_pull_fresh_down.png"]];
        _arrowImageView.autoresizingMask = UIViewContentModeScaleAspectFit;
		_arrowImageView.frame = _activityIndicatorView.frame;
		[self addSubview:_arrowImageView];
        
        self.backgroundColor = [UIColor clearColor];
	}
	return self;
}


- (void)layoutSubviews {
	CGSize size = self.bounds.size;
	self.statusLabel.frame = CGRectMake(20.0f, roundf((size.height - 30.0f) / 2.0f), size.width - 40.0f, 30.0f);
	self.activityIndicatorView.frame = CGRectMake(roundf((size.width - 120.0f) / 2.0f)-6.0f, roundf((size.height - 20.0f) / 2.0f), 20.0f, 20.0f);
    self.arrowImageView.frame = self.activityIndicatorView.frame;
}

#pragma mark - SSPullToRefreshContentView

- (void)setState:(AXPullToRefreshViewState)state withPullToRefreshView:(AXPullToRefreshView *)view {
	switch (state) {
		case AXPullToRefreshViewStateReady: {
			self.statusLabel.text = @"松开刷新";
            CGImageRef imageRef = [self.arrowImageView.image CGImage];
            UIImage *rotatedImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationDown];
            self.arrowImageView.image = rotatedImage;
            self.arrowImageView.hidden = NO;
			[self.activityIndicatorView startAnimating];
			self.activityIndicatorView.alpha = 0.0f;
			break;
		}
			
		case AXPullToRefreshViewStateNormal: {
			self.statusLabel.text = @"下拉刷新";
            self.arrowImageView.image = [UIImage imageNamed:@"rt_pull_fresh_down.png"];
            self.arrowImageView.hidden = NO;
			self.statusLabel.alpha = 1.0f;
			[self.activityIndicatorView stopAnimating];
			self.activityIndicatorView.alpha = 0.0f;
			break;
		}
			
		case AXPullToRefreshViewStateLoading: {
            self.activityIndicatorView.hidden = NO;
			self.activityIndicatorView.alpha = 1.0f;
			[self.activityIndicatorView startAnimating];
            self.arrowImageView.hidden = YES;
			self.statusLabel.text = @"加载中...";
			break;
		}
			
		case AXPullToRefreshViewStateClosing: {
			[self.activityIndicatorView stopAnimating];
            self.activityIndicatorView.alpha = 0.0f;
			self.statusLabel.text = @"加载完成";
			break;
		}
            
        case AXPullToRefreshViewStateAlert: {
            self.activityIndicatorView.hidden = NO;
			self.activityIndicatorView.alpha = 1.0f;
			self.statusLabel.text = @"刷新失败";
			break;
		}
            
        case AXPullToRefreshViewStateAlertFinish: {
            [self.activityIndicatorView stopAnimating];
            self.activityIndicatorView.alpha = 0.0f;
			self.statusLabel.text = @"刷新失败";
			break;
		}
            
        default:
            break;
	}
}

- (void)showMessage:(NSString *)message image:(UIImage *)image activity:(BOOL)activity{
    self.statusLabel.text = message;
    self.arrowImageView.image = image;
    self.arrowImageView.hidden = !image;
    if (activity) {
        [self.activityIndicatorView startAnimating];
        self.activityIndicatorView.alpha = 1.0f;
    }else{
        [self.activityIndicatorView stopAnimating];
        self.activityIndicatorView.alpha = 0.0f;
    }
}

@end
