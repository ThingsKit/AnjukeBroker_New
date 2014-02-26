//
//  AXPullToRefreshView.m
//  RTss
//
//  Created by Sam Soffes on 4/9/12.
//  Copyright (c) 2012 Sam Soffes. All rights reserved.
//
#import "AXPullToRefreshView.h"
#import "AXPullToRefreshContentView.h"

@interface AXPullToRefreshView ()
@property (nonatomic, readwrite) AXPullToRefreshViewState state;
@property (nonatomic, readwrite) UIScrollView *scrollView;
@property (nonatomic, readwrite, getter = isExpanded) BOOL expanded;
@property (nonatomic) CGFloat topInset;
@property (nonatomic) dispatch_semaphore_t animationSemaphore;
@end

@implementation AXPullToRefreshView

@synthesize delegate = _delegate;
@synthesize scrollView = _scrollView;
@synthesize expandedHeight = _expandedHeight;
@synthesize contentView = _contentView;
@synthesize state = _state;
@synthesize expanded = _expanded;
@synthesize defaultContentInset = _defaultContentInset;
@synthesize topInset = _topInset;
@synthesize animationSemaphore = _animationSemaphore;


#pragma mark - Accessors

- (void)setState:(AXPullToRefreshViewState)state {
	BOOL wasLoading = _state == AXPullToRefreshViewStateLoading;
    _state = state;
    
	// Forward to content view
	[self.contentView setState:_state withPullToRefreshView:self];
    
	// Update delegate
	id<AXPullToRefreshViewDelegate> delegate = self.delegate;
	if (wasLoading && _state != AXPullToRefreshViewStateLoading) {
        
	} else if (!wasLoading && _state == AXPullToRefreshViewStateLoading) {
		[self _setPullProgress:1.0f];
		if ([delegate respondsToSelector:@selector(pullToRefreshViewDidStartLoading:)]) {
			[delegate pullToRefreshViewDidStartLoading:self];
		}
	}
}


- (void)setExpanded:(BOOL)expanded {
	_expanded = expanded;
	[self _setContentInsetTop:expanded ? self.expandedHeight : 0.0f];
}


- (void)setScrollView:(UIScrollView *)scrollView {
	void *context = (__bridge void *)self;
	if ([_scrollView respondsToSelector:@selector(removeObserver:forKeyPath:context:)]) {
		[_scrollView removeObserver:self forKeyPath:@"contentOffset" context:context];
	} else if (_scrollView) {
		[_scrollView removeObserver:self forKeyPath:@"contentOffset"];
	}
    
	_scrollView = scrollView;
	self.defaultContentInset = _scrollView.contentInset;
	[_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:context];
}


- (UIView<AXPullToRefreshContentView> *)contentView {
	// Use the simple content view as the default
	if (!_contentView) {
		self.contentView = [[AXPullToRefreshContentView alloc] initWithFrame:CGRectZero];
	}
	return _contentView;
}


- (void)setContentView:(UIView<AXPullToRefreshContentView> *)contentView {
	[_contentView removeFromSuperview];
	_contentView = contentView;
    
	[_contentView setState:self.state withPullToRefreshView:self];
	[self refreshLastUpdatedAt];
	[self addSubview:_contentView];
}


- (void)setDefaultContentInset:(UIEdgeInsets)defaultContentInset {
	_defaultContentInset = defaultContentInset;
	[self _setContentInsetTop:self.topInset];
}


#pragma mark - NSObject

- (void)dealloc {
	self.scrollView = nil;
	self.delegate = nil;
#if !OS_OBJECT_USE_OBJC
	dispatch_release(_animationSemaphore);
#endif
}


#pragma mark - UIView

- (void)removeFromSuperview {
	self.scrollView = nil;
	[super removeFromSuperview];
}


- (void)layoutSubviews {
	CGSize size = self.bounds.size;
	CGSize contentSize = [self.contentView sizeThatFits:size];
    
	if (contentSize.width < size.width) {
		contentSize.width = size.width;
	}
    
	if (contentSize.height < self.expandedHeight) {
		contentSize.height = self.expandedHeight;
	}
    
	self.contentView.frame = CGRectMake(roundf((size.width - contentSize.width) / 2.0f), size.height - contentSize.height, contentSize.width, contentSize.height);
}


#pragma mark - Initializer

- (id)initWithScrollView:(UIScrollView *)scrollView delegate:(id<AXPullToRefreshViewDelegate>)delegate {
	CGRect frame = CGRectMake(0.0f, 0.0f - scrollView.bounds.size.height, scrollView.bounds.size.width,
							  scrollView.bounds.size.height);
	if ((self = [self initWithFrame:frame])) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.scrollView = scrollView;
		self.delegate = delegate;
		self.state = AXPullToRefreshViewStateNormal;
		self.expandedHeight = 40.0f;
        
		for (UIView *view in self.scrollView.subviews) {
			if ([view isKindOfClass:[AXPullToRefreshView class]]) {
				[[NSException exceptionWithName:@"AXPullToRefreshViewAlreadyAdded" reason:@"There is already a AXPullToRefreshView added to this scroll view. Unexpected things will happen. Don't do this." userInfo:nil] raise];
			}
		}
        
		// Add to scroll view
		[self.scrollView addSubview:self];
        
		// Semaphore is used to ensure only one animation plays at a time
		_animationSemaphore = dispatch_semaphore_create(0);
		dispatch_semaphore_signal(_animationSemaphore);
	}
	return self;
}


#pragma mark - Loading

- (void)startLoading {
	[self startLoadingAndExpand:NO animated:NO];
}


- (void)startLoadingAndExpand:(BOOL)shouldExpand animated:(BOOL)animated {
	// If we're not loading, this method has no effect
    if (self.state == AXPullToRefreshViewStateLoading) {
		return;
	}
    
	// Animate back to the loading state
	[self _setState:AXPullToRefreshViewStateLoading animated:animated expanded:shouldExpand completion:nil];
}


- (void)finishLoading {
	// If we're not loading, this method has no effect
    if (self.state != AXPullToRefreshViewStateLoading) {
		return;
	}
    
	// Animate back to the normal state
	__weak AXPullToRefreshView *blockSelf = self;
    id<AXPullToRefreshViewDelegate> delegate = self.delegate;
    
	[self _setState:AXPullToRefreshViewStateClosing animated:YES expanded:NO completion:^{
		blockSelf.state = AXPullToRefreshViewStateNormal;
        if ([delegate respondsToSelector:@selector(pullToRefreshViewDidFinishLoading:)]) {
			[delegate pullToRefreshViewDidFinishLoading:blockSelf];
		}
	}];
	[self refreshLastUpdatedAt];
}

- (void)finishWithError {
	__weak AXPullToRefreshView *blockSelf = self;
	[self _setState:AXPullToRefreshViewStateAlertFinish animated:YES expanded:NO completion:^{
		blockSelf.state = AXPullToRefreshViewStateNormal;
	}];
	[self refreshLastUpdatedAt];
}


- (void)refreshLastUpdatedAt {
	NSDate *date = nil;
	id<AXPullToRefreshViewDelegate> delegate = self.delegate;
	if ([delegate respondsToSelector:@selector(pullToRefreshViewLastUpdatedAt:)]) {
		date = [delegate pullToRefreshViewLastUpdatedAt:self];
	} else {
		date = [NSDate date];
	}
    
	// Forward to content view
	if ([self.contentView respondsToSelector:@selector(setLastUpdatedAt:withPullToRefreshView:)]) {
		[self.contentView setLastUpdatedAt:date withPullToRefreshView:self];
	}
}


#pragma mark - Private

- (void)_setContentInsetTop:(CGFloat)topInset {
	self.topInset = topInset;
    
	// Default to the scroll view's initial content inset
	UIEdgeInsets inset = self.defaultContentInset;
    
	// Add the top inset
	inset.top += self.topInset;
    
	// Don't set it if that is already the current inset
	if (UIEdgeInsetsEqualToEdgeInsets(self.scrollView.contentInset, inset)) {
		return;
	}
    
	// Update the content inset
	self.scrollView.contentInset = inset;
    
	// If scrollView is on top, scroll again to the top (needed for scrollViews with content > scrollView).
	if (self.scrollView.contentOffset.y == 0.0f) {
		[self.scrollView scrollRectToVisible:CGRectMake(0.0f, 0.0f, 1.0f, 1.0f) animated:YES];
	}
    
	// Tell the delegate
	id<AXPullToRefreshViewDelegate> delegate = self.delegate;
	if ([delegate respondsToSelector:@selector(pullToRefreshView:didUpdateContentInset:)]) {
		[delegate pullToRefreshView:self didUpdateContentInset:self.scrollView.contentInset];
	}
}


- (void)_setState:(AXPullToRefreshViewState)state animated:(BOOL)animated expanded:(BOOL)expanded completion:(void (^)(void))completion {
	if (!animated) {
		self.state = state;
		self.expanded = expanded;
        
		if (completion) {
			completion();
		}
		return;
	}
    
	dispatch_semaphore_t semaphore = self.animationSemaphore;
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
		dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
		dispatch_async(dispatch_get_main_queue(), ^{
			[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
				self.state = state;
				self.expanded = expanded;
			} completion:^(BOOL finished) {
				dispatch_semaphore_signal(semaphore);
				if (completion) {
					completion();
				}
			}];
		});
	});
}


- (void)_setPullProgress:(CGFloat)pullProgress {
	if ([self.contentView respondsToSelector:@selector(setPullProgress:)]) {
		[self.contentView setPullProgress:pullProgress];
	}
}


#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	// Call super if we didn't register for this notification
	if (context != (__bridge void *)self) {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
		return;
	}
    
	// We don't care about this notificaiton
	if (self.delegate == nil || object != self.scrollView || ![keyPath isEqualToString:@"contentOffset"]) {
		return;
	}
    
	// Get the offset out of the change notification
	CGFloat y = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue].y + self.defaultContentInset.top;
    
	// Scroll view is dragging
	if (self.scrollView.isDragging) {
		// Scroll view is ready
		if (self.state == AXPullToRefreshViewStateReady) {
			// Dragged enough to refresh
			if (y > -self.expandedHeight && y < 0.0f) {
				self.state = AXPullToRefreshViewStateNormal;
			}
            // Scroll view is normal
		} else if (self.state == AXPullToRefreshViewStateNormal) {
			// Update the content view's pulling progressing
			[self _setPullProgress:-y / self.expandedHeight];
            
			// Dragged enough to be ready
			if (y < -self.expandedHeight) {
				self.state = AXPullToRefreshViewStateReady;
			}
            // Scroll view is loading
		} else if (self.state == AXPullToRefreshViewStateLoading) {
            CGFloat insetAdjustment = y < 0 ? fmaxf(0, self.expandedHeight + y) : self.expandedHeight;
			[self _setContentInsetTop:self.expandedHeight - insetAdjustment];
		}
		return;
	}
    
	// If the scroll view isn't ready, we're not interested
	if (self.state != AXPullToRefreshViewStateReady) {
		return;
	}
    
	// We're ready, prepare to switch to loading. Be default, we should refresh.
	AXPullToRefreshViewState newState = AXPullToRefreshViewStateLoading;
    
	// Ask the delegate if it's cool to start loading
	BOOL expand = YES;
	id<AXPullToRefreshViewDelegate> delegate = self.delegate;
	if ([delegate respondsToSelector:@selector(pullToRefreshViewShouldStartLoading:)]) {
		if (![delegate pullToRefreshViewShouldStartLoading:self]) {
			// Animate back to normal since the delegate said no
			newState = AXPullToRefreshViewStateNormal;
			expand = NO;
		}
	}
    
	// Animate to the new state
	[self _setState:newState animated:YES expanded:expand completion:nil];
}

@end
