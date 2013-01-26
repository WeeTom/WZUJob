// light@huohua.tv
#import <UIKit/UIKit.h>
#import "HHBlocks.h"

@interface UIViewController (User)
// login and expired
- (BOOL)checkIsLoginAndNotExpired:(UIView *)view completion:(HHBasicBlock)completionBlock;
@end