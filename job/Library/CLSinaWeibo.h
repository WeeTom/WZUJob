// light@huohua.tv
#import "SinaWeibo.h"
#import "HHKit.h"

@interface CLSinaWeibo : SinaWeibo
+ (CLSinaWeibo *)shared;
+ (BOOL)isSSO;

- (void)logInAndPerform:(HHBasicBlock)block;
- (void)logOutAndPerform:(HHBasicBlock)block;

- (void)sendText:(NSString *)text completion:(HHBasicBlock)completionBlock;
- (void)sendText:(NSString *)text image:(UIImage *)image completion:(HHBasicBlock)completionBlock;

- (void)uploadWeiboFriends:(HHBasicBlock)completionBlock;
@end