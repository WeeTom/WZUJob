// light@huohua.tv
#import <Foundation/Foundation.h>
#import "ABRouter.h"

@interface CLRouter : NSObject
+ (void)loadRouting;
+ (UIViewController<Routable> *)match:(NSString *)route;
+ (void)navigateTo:(NSString *)route withNavigationController:(UINavigationController *)navigationController;
+ (void)modallyPresent:(NSString*)route from:(UIViewController*)viewController;
@end