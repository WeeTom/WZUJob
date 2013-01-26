// light@huohua.tv
#import "SVPullToRefreshHelper.h"
#import "UIColor+Clover.h"
#import "UIFont+Clover.h"
#import "HHKit.h"

static CGFloat const SVPullToRefreshViewHeight = 60;

@implementation SVPullToRefreshHelper

static UIView *_stoppedView = nil;
+ (UIView *)stoppedView
{
    if (!_stoppedView) {
        _stoppedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, SVPullToRefreshViewHeight)];
        _stoppedView.backgroundColor = [UIColor clearColor];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 16)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor CLGrayTextColor];
        titleLabel.font = [UIFont CLFontSize:14];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"下拉刷新";
        titleLabel.offsetY = (_stoppedView.height - titleLabel.height) / 2;
        [_stoppedView addSubview:titleLabel];
    }
    return _stoppedView;
}

static UIView *_triggeredView = nil;
+ (UIView *)triggeredView
{
    if (!_triggeredView) {
        _triggeredView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, SVPullToRefreshViewHeight)];
        _triggeredView.backgroundColor = [UIColor clearColor];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 16)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor CLGrayTextColor];
        titleLabel.font = [UIFont CLFontSize:14];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"松开刷新";
        titleLabel.offsetY = (_triggeredView.height - titleLabel.height) / 2;
        [_triggeredView addSubview:titleLabel];
    }
    return _triggeredView;
}


static UIView *_loadingView = nil;
+ (UIView *)loadingView
{
    if (!_loadingView) {
        _loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, SVPullToRefreshViewHeight)];
        _loadingView.backgroundColor = [UIColor clearColor];
        
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.offsetX = (_loadingView.width - indicatorView.width) / 2;
        indicatorView.offsetY = (_loadingView.height - indicatorView.height) / 2;
        [indicatorView startAnimating];
        [_loadingView addSubview:indicatorView];
    }
    return _loadingView;
}

@end