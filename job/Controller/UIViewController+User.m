// light@huohua.tv
#import "UIViewController+User.h"
#import "HHKit.h"
#import "CLSinaWeibo.h"
#import "CLNotificationDefine.h"
#import "SVProgressHUD.h"

@implementation UIViewController (User)
- (BOOL)checkIsLogin:(UIView *)view completion:(HHBasicBlock)completionBlock
{
    if ([[CLSinaWeibo shared] isLoggedIn]) {
        return YES;
    }
    
    HHActionSheet *actionSheet = [[HHActionSheet alloc] initWithTitle:@"需要绑定新浪微博才能继续操作"];
    [actionSheet addDestructiveButtonWithTitle:@"绑定微博" block:^{
        [[CLSinaWeibo shared] logInAndPerform:completionBlock];
    }];
    [actionSheet addCancelButtonWithTitle:@"取消" block:^{}];
    [actionSheet showInView:self.view];
    
    return NO;
}

- (BOOL)checkIsNotExpired:(UIView *)view completion:(HHBasicBlock)completionBlock
{
    if ([[CLSinaWeibo shared] isAuthorizeExpired]) {
        HHActionSheet *actionSheet = [[HHActionSheet alloc] initWithTitle:@"新浪微博授权已过期"];
        [actionSheet addDestructiveButtonWithTitle:@"重新绑定" block:^{
            [[CLSinaWeibo shared] logInAndPerform:completionBlock];
        }];
        [actionSheet addCancelButtonWithTitle:@"取消" block:^{}];
        [actionSheet showInView:self.view];
        return NO;
    }
    return YES;
}

- (BOOL)checkIsLoginAndNotExpired:(UIView *)view completion:(HHBasicBlock)completionBlock
{
    if (![self checkIsLogin:view completion:completionBlock]) {
        return NO;
    }
    if (![self checkIsNotExpired:view completion:completionBlock]) {
        return NO;
    }
    return YES;
}
@end