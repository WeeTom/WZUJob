// light@huohua.tv
#import "CLRouter.h"

#import "NewsListVC.h"
#import "JobListVC.h"

#import "NewsVC.h"
#import "JobVC.h"

#import "FavouritesVC.h"

#import "SettingVC.h"

@implementation CLRouter

+ (void)loadRouting
{
    [[ABRouter sharedRouter] match:ListRoute to:[NewsListVC class]];
    [[ABRouter sharedRouter] match:JobRoute to:[JobListVC class]];
    [[ABRouter sharedRouter] match:JobsRoute to:[NewsListVC class]];
    
    [[ABRouter sharedRouter] match:ShowNewsRoute to:[NewsVC class]];
    [[ABRouter sharedRouter] match:ShowJobRoute  to:[JobVC class]];
    
    [[ABRouter sharedRouter] match:@"/fav/" to:[FavouritesVC class]];
    
    [[ABRouter sharedRouter] match:@"/setting/" to:[SettingVC class]];
}

+ (UIViewController<Routable> *)match:(NSString *)route
{
    return [[ABRouter sharedRouter] match:route];
}

+ (void)navigateTo:(NSString *)route withNavigationController:(UINavigationController *)navigationController
{
    [[ABRouter sharedRouter] navigateTo:route withNavigationController:navigationController];
}

+ (void)modallyPresent:(NSString *)route from:(UIViewController *)viewController
{
    if (![self match:route]) return;
    [[ABRouter sharedRouter] modallyPresent:route from:viewController];
}

@end