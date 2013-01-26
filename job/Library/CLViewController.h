// light@huohua.tv
#import <UIKit/UIKit.h>
#import "HHKit.h"

#import "CLRouter.h"
#import "CLSinaWeibo.h"
#import "CLCache.h"

#import "CLUIDefine.h"
#import "CLDataDefine.h"
#import "CLCacheKeyDefine.h"
#import "CLNotificationDefine.h"
#import "CLNavigationController.h"

#import "SVProgressHUD.h"

#import "SVPullToRefreshHelper.h"

#import "WZUWebContentFetcher.h"
#import "WZUWebContentProcessor.h"
#import "UIViewController+User.h"

@interface CLViewController : HHViewController <Routable, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSString *apiPath;
@property (readonly, nonatomic) NSString *fullApiPath;
@property (strong, nonatomic) NSDictionary *parameters;

@property (strong, nonatomic) UITableView *tableView;

@property (assign, nonatomic) BOOL isLoading;
@property (assign, nonatomic) BOOL isEnd;

- (void)clearProperties;
- (void)setupNavigationBar;

@property (readonly, nonatomic) BOOL isModalPresented;
@end