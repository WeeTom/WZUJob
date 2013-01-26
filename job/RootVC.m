// light@huohua.tv
#import "RootVC.h"

#import "HHKit.h"
#import "CLRouter.h"
#import "CLCache.h"
#import "CLNotificationDefine.h"
#import "CLSinaWeibo.h"
#import "CLViewController.h"
#import "CLUIDefine.h"

#import "SDImageCache.h"

#import "CLSinaWeiboFriendHelper.h"
#import "CLCacheKeyDefine.h"
#import "CLRouter.h"

@interface RootVC () </*LeveyTabBarControllerDelegate, */UINavigationControllerDelegate, UITabBarControllerDelegate>
@property (strong, nonatomic) UINavigationController *activityNC;
@property (strong, nonatomic) UINavigationController *exploreNC;
@property (strong, nonatomic) UINavigationController *albumNC;
@property (strong, nonatomic) UINavigationController *mineNC;
@end

@implementation RootVC
- (id)init
{
    
    self = [super init];
    if (self) {
        NSArray *viewControllers = @[self.activityNC, self.exploreNC, self.albumNC, self.mineNC];
        self.viewControllers = viewControllers;
        self.view.backgroundColor = [UIColor CLBackgroundColor];
        self.selectedIndex = 1;
        self.delegate = self;
        
        [CLSinaWeiboFriendHelper clearFriendList];// clear WeiboFriendList cache
    }
    return self;
}

#pragma mark - UINavigationController
- (UINavigationController *)activityNC
{
    if (!_activityNC) {
        _activityNC = [[UINavigationController alloc] initWithRootViewController:[CLRouter match:[ListRoute stringByAppendingFormat:@"?Tid=%@&title=%@", ListTid_Notice, @"通知公告"]]],
        _activityNC.tabBarItem.title = @"通知公告";
        _activityNC.tabBarItem.image = [UIImage imageFromMainBundleFile:@"notice@2x.png"];
        _activityNC.delegate = self;
    }
    return _activityNC;
}

- (UINavigationController *)exploreNC
{
    if (!_exploreNC) {
        _exploreNC = [[UINavigationController alloc] initWithRootViewController:[CLRouter match:[ListRoute stringByAppendingFormat:@"?Tid=%@&title=%@", ListTid_Dynamic, @"当前分类:工作动态"]]],
        _exploreNC.tabBarItem.title = @"新闻动态";
        _exploreNC.tabBarItem.image = [UIImage imageFromMainBundleFile:@"info@2x.png"];
        _exploreNC.delegate = self;
    }
    return _exploreNC;
}

- (UINavigationController *)albumNC
{
    if (!_albumNC) {
        _albumNC = [[UINavigationController alloc] initWithRootViewController:[CLRouter match:[JobRoute stringByAppendingFormat:@"?Tid=%@&title=%@", @"1", [NSString stringWithFormat:@"当前专业:综合类"]]]],
        _albumNC.tabBarItem.title = @"最新职位";
        _albumNC.tabBarItem.image = [UIImage imageFromMainBundleFile:@"folder@2x.png"];
        _albumNC.delegate = self;
    }
    return _albumNC;
}

- (UINavigationController *)mineNC
{
    if (!_mineNC) {
        _mineNC = [[UINavigationController alloc] initWithRootViewController:[CLRouter match:@"/fav/"]],
        _mineNC.tabBarItem.title = @"我的收藏";
        _mineNC.tabBarItem.image = [UIImage imageFromMainBundleFile:@"fav@2x.png"];
        _mineNC.delegate = self;
    }
    return _mineNC;
}
@end