//
//  NewsListVC.m
//  job
//
//  Created by Wee Tom on 13-1-4.
//  Copyright (c) 2013年 Wee Tom. All rights reserved.
//

#import "ListVC.h"

@interface ListVC ()
@property (strong, nonatomic) UILabel *footerView;
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;

@property (assign, nonatomic) NSInteger currentPage;
@property (readonly, nonatomic) NSString *route;
@property (readonly, nonatomic) NSString *tid;

@end

@implementation ListVC
- (id)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = NO;
    }
    return self;
}

#pragma mark - Properties
- (NSString *)route {
    return self.apiPath;
}

- (NSString *)tid {
    return [self.parameters objectForKey:@"Tid"];
}

- (void)clearProperties {
    _contents = nil;
    _footerView = nil;
    _indicatorView = nil;
}

#pragma mark - Hooks
- (NSArray *)hooksAfterLoadView {
    NSMutableArray *hooks = [[super hooksAfterLoadView] mutableCopy];
    [hooks addObject:@"resetupView"];
    [hooks addObject:@"resetupTableView"];
    [hooks addObject:@"loadData"];
    return hooks;
}

- (NSArray *)hooksAfterViewWillAppear {
    NSMutableArray *hooks = [[super hooksAfterViewWillAppear] mutableCopy];
    [hooks addObject:@"setNaviBarTranslucent"];
    return hooks;
}

- (void)setNaviBarTranslucent {
    self.navigationController.navigationBar.translucent = NO;
}

- (void)setupNavigationBar {
    [super setupNavigationBar];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleBordered target:self action:@selector(showSettingVC)];
}

- (void)resetupView {
    self.view.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].applicationFrame.size.height - self.navigationController.navigationBar.frame.size.height - self.tabBarController.tabBar.height);
}

- (void)resetupTableView {
    self.tableView.frame = self.view.bounds;
    self.tableView.tableFooterView = self.footerView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

#pragma mark - UITableView
- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        _footerView.textAlignment = NSTextAlignmentCenter;
        _footerView.textColor = [UIColor CLGrayTextColor];
        _footerView.font = [UIFont CLFontSize:14];
        self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.indicatorView.frame = CGRectMake(150, 12, 20, 20);
        [_footerView addSubview:self.indicatorView];
    }
    return _footerView;
}

- (void)setIsLoading:(BOOL)isLoading {
    [super setIsLoading:isLoading];
    if (isLoading) {
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [indicatorView startAnimating];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:indicatorView];
        self.footerView.text = @"";
        [self.indicatorView startAnimating];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadData)];
        [self.indicatorView stopAnimating];
        self.footerView.text = @"下拉加载更多";
    }
}

- (void)setIsEnd:(BOOL)isEnd {
    [super setIsEnd:isEnd];
    if (isEnd) {
        [self.indicatorView stopAnimating];
        self.footerView.text = @"没有更多了";
    }
}

- (void)loadData {
    if (self.isLoading) return;
    
    self.isLoading = YES;
    self.currentPage = 1;
    
    __block NSString *content = [DataManager objectForKey:self.fullApiPath];
    if (content) {
        [self finishLoadingData:content];
    }
    
    [HHThreadHelper performBlockInBackground:^{
        content = [WZUWebContentFetcher fetchListContentFrom:self.route withTid:self.tid atPage:self.currentPage];
    } completion:^{
        self.isLoading = NO;
        if (!content) {
            [SVProgressHUD showErrorWithStatus:@"网络有问题哦"];
            return ;
        }
        
        [DataManager setObject:content forKey:self.fullApiPath];
        self.currentPage++;
        [self finishLoadingData:content];
    }];
}

- (void)finishLoadingData:(NSString *)content {

}

- (void)loadMoreData {
    if (self.isLoading) return;

    self.isLoading = YES;
    
    __block NSString *content = nil;
    [HHThreadHelper performBlockInBackground:^{
        content = [WZUWebContentFetcher fetchListContentFrom:self.route withTid:self.tid atPage:self.currentPage];
    } completion:^{
        self.isLoading = NO;
        if (!content) {
            [SVProgressHUD showErrorWithStatus:@"网络有问题哦"];
            return ;
        }
        
        self.currentPage++;
        [self finishLoadingMoreData:content];
    }];
}

- (void)finishLoadingMoreData:(NSString *)content {

}

- (void)renderData {
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contents.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableDictionary *news = [self.contents objectAtIndex:indexPath.row];
    [CLRouter navigateTo:news.url withNavigationController:self.navigationController];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.tableView] && !self.isLoading) {
        if ((scrollView.contentOffset.y - 30 + scrollView.frame.size.height >= scrollView.contentSize.height)) {
            if (self.isLoading || self.isEnd) {
                return;
            }
            
            if ([self respondsToSelector:@selector(loadMoreData)]) {
                self.footerView.text = @"松开加载更多";
            }
        } else {
            self.footerView.text = @"下拉加载更多";
        }
    }
}
@end
