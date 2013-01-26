// light@huohua.tv
#import <Foundation/Foundation.h>

@interface SVPullToRefreshHelper : NSObject
+ (UIView *)stoppedView;
+ (UIView *)triggeredView;
+ (UIView *)loadingView;
@end