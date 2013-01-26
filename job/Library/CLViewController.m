// light@huohua.tv
#import "CLViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation CLViewController
- (void)dealloc
{
    _apiPath = nil;
    _parameters = nil;
}

#pragma mark - CLViewControllerDelegate
- (NSArray *)hooksAfterLoadView
{
    return @[@"setupView", @"setupTableView", @"setupNavigationBar"];
}

- (NSArray *)hooksBeforeViewDidUnload
{
    return @[@"clearProperties"];
}

- (NSArray *)hooksAfterViewDidAppear
{
    return @[@"logCurrentVisiableVC"];
}

- (NSArray *)hooksAfterViewDidDisappear
{
    return @[];
}

#pragma mark - UIViewController
- (void)clearProperties
{
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    _tableView = nil;
}

- (void)setupView
{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].applicationFrame.size.height - self.navigationController.navigationBar.frame.size.height)];
    self.view.backgroundColor = [UIColor CLBackgroundColor];
}

- (void)setupNavigationBar
{
    if ([self.parameters objectForKey:@"title"]) {
        [self.navigationController setTitleText:[self.parameters objectForKey:@"title"]];
    }
    //[self.navigationController customBackgroundWithImage:[UIImage imageFromMainBundleFile:@"navi-bg-solid@2x.png"]];
}

- (void)logCurrentVisiableVC {
    HHLog(@"ViewDidAppear:%@", self.fullApiPath);
}

- (NSString *)fullApiPath {
    NSMutableString *path = [NSMutableString string];
    [path appendString:self.apiPath];

    if ([[self.parameters allKeys] count] > 0) {
        [path appendString:@"?"];
        for (NSString *key in [self.parameters allKeys]) {
            [path appendFormat:@"%@=%@", key, [self.parameters objectForKey:key]];
            if ([[self.parameters allKeys] indexOfObject:key] != ([[self.parameters allKeys] count] - 1)) {
                [path appendString:@"&"];
            }
        }
    }
    
    return path;
}

#pragma mark - Autorotate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (BOOL)isModalPresented
{
    if ([self respondsToSelector:@selector(parentViewController)]) {
        UIViewController *viewController = self;
        UIViewController *parentViewController = self.parentViewController;
        while (parentViewController) {
            viewController = parentViewController;
            parentViewController = parentViewController.parentViewController;
        }
        if ([self.tabBarController.viewControllers containsObject:viewController]) return NO;
    }
    return YES;
}

#pragma mark - TableView
- (void)setupTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.height)];
    self.tableView.backgroundColor = [UIColor CLBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = YES;
    self.tableView.bounces = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - ScrollViewDelegate
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([scrollView isEqual:self.tableView]) {
        if ((scrollView.contentOffset.y - 30 + scrollView.frame.size.height >= scrollView.contentSize.height)) {
            if (self.isLoading || self.isEnd) {
                return;
            }
            
            if ([self respondsToSelector:@selector(loadMoreData)]) {
                [self performSelector:@selector(loadMoreData)];
            }
        }
    }
}

- (void)setIsLoading:(BOOL)isLoading
{
    _isLoading = isLoading;
}
@end