//
//  AXPullToRefreshView.h
//  AXPullToRefresh
//
//  Created by Sam Soffes on 4/9/12.
//  Copyright (c) 2012 Sam Soffes. All rights reserved.
//

//
// Example usage:
//
// - (void)viewDidLoad {
//    [super viewDidLoad];
//    self.pullToRefreshView = [[AXPullToRefreshView alloc] initWithScrollView:self.tableView delegate:self];
// }
//
// - (void)viewDidUnload {
//    [super viewDidUnload];
//    self.pullToRefreshView = nil;
// }
//
// - (void)refresh {
//    [self.pullToRefreshView startLoading];
//    // Load data...
//    [self.pullToRefreshView finishLoading];
// }
//
// - (void)pullToRefreshViewDidStartLoading:(AXPullToRefreshView *)view {
//    [self refresh];
// }
//

typedef enum {
	/// Most will say "Pull to refresh" in this state
	AXPullToRefreshViewStateNormal,
    
	/// Most will say "Release to refresh" in this state
	AXPullToRefreshViewStateReady,
    
	/// The view is loading
	AXPullToRefreshViewStateLoading,
    
	/// The view has finished loading and is animating
	AXPullToRefreshViewStateClosing,
    
    AXPullToRefreshViewStateAlert,
    
    AXPullToRefreshViewStateAlertFinish
} AXPullToRefreshViewState;

@protocol AXPullToRefreshViewDelegate;
@protocol AXPullToRefreshContentView;

@interface AXPullToRefreshView : UIView

/**
 The content view displayed when the `scrollView` is pulled down. By default this is an instance of `AXPullToRefreshDefaultContentView`.
 
 @see AXPullToRefreshContentView
 */
@property (nonatomic, strong) UIView<AXPullToRefreshContentView> *contentView;

/**
 If you need to update the scroll view's content inset while it contains a pull to refresh view, you should set the
 `defaultContentInset` on the pull to refresh view and it will forward it to the scroll view taking into account the
 pull to refresh view's position.
 */
@property (nonatomic, assign) UIEdgeInsets defaultContentInset;

/**
 The height of the fully expanded content view. The default is `70.0`.
 
 The `contentView`'s `sizeThatFits:` will be respected when displayed but does not effect the expanded height. You can use this
 to draw outside of the expanded area. If you don't implement `sizeThatFits:` it will automatically display at the default size.
 
 @see expanded
 */
@property (nonatomic, assign) CGFloat expandedHeight;

/**
 A boolean indicating if the pull to refresh view is expanded.
 
 @see expandedHeight
 @see startLoadingAndExpand:
 */
@property (nonatomic, assign, readonly, getter = isExpanded) BOOL expanded;

/**
 The scroll view containing the pull to refresh view. This is automatically set with `initWithScrollView:delegate:`.
 
 @see initWithScrollView:delegate:
 */
@property (nonatomic, assign, readonly) UIScrollView *scrollView;

/**
 The delegate is sent messages when the pull to refresh view starts loading. This is automatically set with `initWithScrollView:delegate:`.
 
 @see initWithScrollView:delegate:
 @see AXPullToRefreshViewDelegate
 */
@property (nonatomic, weak) id<AXPullToRefreshViewDelegate> delegate;

/**
 The state of the pull to refresh view.
 
 @see startLoading
 @see startLoadingAndExpand:
 @see finishLoading
 @see AXPullToRefreshViewState
 */
@property (nonatomic, assign, readonly) AXPullToRefreshViewState state;

/**
 All you need to do to add this view to your scroll view is call this method (passing in the scroll view). That's it.
 You don't have to add it as subview or anything else. The rest is magic.
 
 You should only initalize with this method and never move it to another scroll view during its lifetime.
 */
- (id)initWithScrollView:(UIScrollView *)scrollView delegate:(id<AXPullToRefreshViewDelegate>)delegate;

/**
 Call this method when you start loading. If you trigger loading another way besides pulling to refresh, call this
 method so the pull to refresh view will be in sync with the loading status. By default, it will not expand the view
 so it loads quietly out of view.
 */
- (void)startLoading;

/**
 Call this method when you start loading. If you trigger loading another way besides pulling to refresh, call this
 method so the pull to refresh view will be in sync with the loading status. You may pass YES for shouldExpand to
 animate down the pull to refresh view to show that it's loading.
 */
- (void)startLoadingAndExpand:(BOOL)shouldExpand animated:(BOOL)animated;

/**
 Call this when you finish loading.
 */
- (void)finishLoading;

- (void)finishWithError;

/**
 Manually update the last updated at time. This will automatically get called when the pull to refresh view finishes laoding.
 */
- (void)refreshLastUpdatedAt;

@end


@protocol AXPullToRefreshViewDelegate <NSObject>

@optional

@property (nonatomic) BOOL bNeedPullRefresh;

/**
 Return `NO` if the pull to refresh view should no start loading.
 */
- (BOOL)pullToRefreshViewShouldStartLoading:(AXPullToRefreshView *)view;

/**
 The pull to refresh view started loading. You should kick off whatever you need to load when this is called.
 */
- (void)pullToRefreshViewDidStartLoading:(AXPullToRefreshView *)view;

/**
 The pull to refresh view finished loading. This will get called when it receives `finishLoading`.
 */
- (void)pullToRefreshViewDidFinishLoading:(AXPullToRefreshView *)view;

/**
 The date when data was last updated. This will get called when it finishes loading or if it receives `refreshLastUpdatedAt`.
 Some content views may display this date.
 */
- (NSDate *)pullToRefreshViewLastUpdatedAt:(AXPullToRefreshView *)view;

/**
 The pull to refresh view updated its scroll view's content inset
 */
- (void)pullToRefreshView:(AXPullToRefreshView *)view didUpdateContentInset:(UIEdgeInsets)contentInset;

@end


@protocol AXPullToRefreshContentView <NSObject>

@required

/**
 The pull to refresh view's state has changed. The content view must update itself. All content view's must implement
 this method.
 */
- (void)setState:(AXPullToRefreshViewState)state withPullToRefreshView:(AXPullToRefreshView *)view;

@optional

/**
 The pull to refresh view will set send values from `0.0` to `1.0` as the user pulls down. `1.0` means it is fully expanded and
 will change to the `AXPullToRefreshViewStateReady` state. You can use this value to draw the progress of the pull
 (i.e. Tweetbot style).
 */
- (void)setPullProgress:(CGFloat)pullProgress;

/**
 The pull to refresh view updated its last updated date.
 */
- (void)setLastUpdatedAt:(NSDate *)date withPullToRefreshView:(AXPullToRefreshView *)view;

@end
