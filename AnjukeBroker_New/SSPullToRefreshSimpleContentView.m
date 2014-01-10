//
//  SSPullToRefreshSimpleContentView.m
//  SSPullToRefresh
//
//  Created by Sam Soffes on 5/17/12.
//  Copyright (c) 2012 Sam Soffes. All rights reserved.
//

#import "SSPullToRefreshSimpleContentView.h"

@implementation SSPullToRefreshSimpleContentView

@synthesize statusLabel = _statusLabel;
@synthesize activityIndicatorView = _activityIndicatorView;
@synthesize arrowImageView = _arrowImageView;

#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		CGFloat width = self.bounds.size.width;
		
		_statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 14.0f, width, 20.0f)];
		_statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_statusLabel.font = [UIFont boldSystemFontOfSize:14.0f];
		_statusLabel.textColor = [UIColor blackColor];
		_statusLabel.backgroundColor = [UIColor clearColor];
		_statusLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:_statusLabel];
		
		_activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		_activityIndicatorView.frame = CGRectMake(30.0f, 25.0f, 20.0f, 20.0f);
		[self addSubview:_activityIndicatorView];
        _activityIndicatorView.hidden = YES;
        
		_arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueArrow.png"]];
        _arrowImageView.autoresizingMask = UIViewContentModeScaleAspectFit;
		_arrowImageView.frame = _activityIndicatorView.frame;
		[self addSubview:_arrowImageView];
	}
	return self;
}


- (void)layoutSubviews {
	CGSize size = self.bounds.size;
	self.statusLabel.frame = CGRectMake(20.0f, roundf((size.height - 30.0f) / 2.0f), size.width - 40.0f, 30.0f);
	self.activityIndicatorView.frame = CGRectMake(roundf((size.width - 120.0f) / 2.0f), roundf((size.height - 20.0f) / 2.0f), 20.0f, 20.0f);
    self.arrowImageView.frame = self.activityIndicatorView.frame;
}


#pragma mark - SSPullToRefreshContentView

- (void)setState:(SSPullToRefreshViewState)state withPullToRefreshView:(SSPullToRefreshView *)view {
	switch (state) {
		case SSPullToRefreshViewStateReady: {
			self.statusLabel.text = @"松开刷新";
            CGImageRef imageRef = [self.arrowImageView.image CGImage];            
            UIImage *rotatedImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationDown];
            self.arrowImageView.image = rotatedImage;
            self.arrowImageView.hidden = NO;
			[self.activityIndicatorView startAnimating];
			self.activityIndicatorView.alpha = 0.0f;
			break;
		}
			
		case SSPullToRefreshViewStateNormal: {
			self.statusLabel.text = @"下拉刷新";
            self.arrowImageView.image = [UIImage imageNamed:@"blueArrow.png"];
            self.arrowImageView.hidden = NO;
			self.statusLabel.alpha = 1.0f;
			[self.activityIndicatorView stopAnimating];
			self.activityIndicatorView.alpha = 0.0f;
			break;
		}
			
		case SSPullToRefreshViewStateLoading: {
            self.arrowImageView.hidden = YES;
            self.activityIndicatorView.hidden = NO;
			self.statusLabel.text = @"正在刷新";
			[self.activityIndicatorView startAnimating];
			self.activityIndicatorView.alpha = 1.0f;
			break;
		}
			
		case SSPullToRefreshViewStateClosing: {
			[self.activityIndicatorView stopAnimating];
            self.activityIndicatorView.alpha = 0.0f;
			self.statusLabel.text = @"刷新成功";
//			self.statusLabel.text = nil;
			break;
		}
	}
}

@end
