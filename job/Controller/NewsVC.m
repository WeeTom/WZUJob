//
//  NewsVC.m
//  job
//
//  Created by Wee Tom on 13-1-4.
//  Copyright (c) 2013年 Wee Tom. All rights reserved.
//

#import "NewsVC.h"
#import "NewsView.h"
#import "Content.h"
#import "SVProgressHUD.h"

@interface NewsVC () <UIWebViewDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) NewsView *newsView;
@property (assign, nonatomic) BOOL shouldHideNaviBar;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSString *detailText;
@end

@implementation NewsVC
#pragma mark - properties
- (void)clearProperties {
    [super clearProperties];
    
    _newsView   = nil;
    _webView    = nil;
    _detailText = nil;
}

- (void)setIsLoading:(BOOL)isLoading {
    [super setIsLoading:isLoading];
    if (isLoading) {
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [indicatorView startAnimating];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:indicatorView];
    } else {
        self.navigationItem.rightBarButtonItems = @[
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActionSheet)],
        [[UIBarButtonItem alloc] initWithTitle:@"T +" style:UIBarButtonItemStyleBordered target:self action:@selector(largerFont)],
        [[UIBarButtonItem alloc] initWithTitle:@"T -" style:UIBarButtonItemStyleBordered target:self action:@selector(smallerFont)],
        [[UIBarButtonItem alloc] initWithTitle:@"T Color" style:UIBarButtonItemStyleBordered target:self action:@selector(changeTextColor)]
        ];
    }
}

- (void)setupNavigationBar {
    [super setupNavigationBar];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)finishLoadingData:(NSString *)content {
    self.detail = [WZUWebContentProcessor processNewsDetail:content];
    self.detail.url = [NSString stringWithFormat:@"%@?Tid=%@&ID=%@", self.route, self.tid, self._id];
    [self.webView loadHTMLString:self.detail.content baseURL:nil];
}

- (NewsView *)newsView {
    if (!_newsView) {
        _newsView = [[NewsView alloc] initWithFrame:self.view.bounds];
        _newsView.scrollEnabled = YES;
        _newsView.bounces = YES;
        _newsView.alwaysBounceVertical = YES;
        _newsView.delegate = self;
        _newsView.clipsToBounds = NO;
    }
    return _newsView;
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
    }
    return _webView;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.tableView removeFromSuperview];
    NSString *lJs2 = @"document.documentElement.innerText";
    self.detailText = [webView stringByEvaluatingJavaScriptFromString:lJs2];
    
    [self.newsView setupWithContent:self.detail detail:self.detailText];
    [self.view addSubview:self.newsView];
}

- (void)showActionSheet {
    HHActionSheet *actionSheet = [[HHActionSheet alloc] initWithTitle:@""];
    if ([[FavManager favs] containsObject:self.detail]) {
        [actionSheet addButtonWithTitle:@"取消收藏" block:^{
            [FavManager removeFavedItem:self.detail];
        }];
    } else {
        [actionSheet addButtonWithTitle:@"添加到收藏夹" block:^{
            [self addToFavoutites];
        }];
    }
    [actionSheet addButtonWithTitle:@"在浏览器中打开" block:^{
        if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?Tid=%@&ID=%@", Job_WZU_EDU_CN, self.route, self.tid, self._id]]]) {
            [SVProgressHUD showErrorWithStatus:@"出错了~"];
        }
    }];
    [actionSheet addButtonWithTitle:@"分享到微信" block:^{
        [self shareViaWechat];
    }];
    [actionSheet addButtonWithTitle:@"分享到微博" block:^{
        [self shareViaWeibo];
    }];
    [actionSheet addCancelButtonWithTitle:@"取消"];
    [actionSheet showInView:self.view];
}

- (void)shareViaWechat {
    [WechatHelper sendWXURLMessageTitle:[NSString stringWithFormat:@"新闻:%@", self.detail.title] description:[NSString stringWithFormat:@"日期:%@", self.detail.date] imageURL:nil URL:[NSString stringWithFormat:@"%@%@?Tid=%@&ID=%@", Job_WZU_EDU_CN, self.route, self.tid, self._id]];
}

- (void)shareViaWeibo {
    if (![self checkIsLoginAndNotExpired:self.view completion:^{
        [self shareViaWeibo];
    }]) {
        return;
    }
    [SVProgressHUD showWithStatus:@"分享中..."];
    [[CLSinaWeibo shared] sendText:[NSString stringWithFormat:@"在#温州大学就业网#看到这段新闻:%@ >>>> %@", self.detail.title, [NSString stringWithFormat:@"%@%@?Tid=%@&ID=%@", Job_WZU_EDU_CN, self.route, self.tid, self._id]] completion:^{
        [SVProgressHUD showSuccessWithStatus:@"分享成功"];
    }];
}

#pragma mark - TextColor
- (void)changeTextColor {
    UITextView *textView = (UITextView *)[self.newsView viewWithTag:detailTag];
    HHActionSheet *actionSheet = [[HHActionSheet alloc] initWithTitle:@"选择颜色"];
    [actionSheet addButtonWithTitle:@"黑色" block:^{
        textView.textColor = [UIColor CLDarkGrayColor];
    }];
    [actionSheet addButtonWithTitle:@"深蓝色" block:^{
        textView.textColor = [UIColor CLColorWithRed:27 green:6 blue:82 alpha:1];
    }];
    [actionSheet addButtonWithTitle:@"深绿色" block:^{
        textView.textColor = [UIColor CLColorWithRed:6 green:82 blue:9 alpha:1];
    }];
    [actionSheet addCancelButtonWithTitle:@"取消"];
    [actionSheet showInView:self.view];
}

#pragma mark - FontSize
- (void)largerFont {
    UITextView *textView = (UITextView *)[self.newsView viewWithTag:detailTag];
    [self resizeFontForDetailView:(textView.font.pointSize + 1)];
}

- (void)smallerFont {
    UITextView *textView = (UITextView *)[self.newsView viewWithTag:detailTag];
    [self resizeFontForDetailView:(textView.font.pointSize - 1)];
}

- (void)resizeFontForDetailView:(NSInteger)size {
    if (size > 30 || size < 10) {
        return;
    }
    UITextView *textView = (UITextView *)[self.newsView viewWithTag:detailTag];
    textView.font = [UIFont CLFontSize:size];
    [self.newsView setupWithContent:self.detail detail:self.detailText];
}

- (void)editView {
    HHActionSheet *actionSheet = [[HHActionSheet alloc] initWithTitle:@""];
    [actionSheet addButtonWithTitle:@"修改字体大小" block:^{
        HHLabel *label = (HHLabel *)[self.newsView viewWithTag:detailTag];
        if (label) {
            label.font = [UIFont CLFontSize:18];
            [self.newsView setupWithContent:self.detail detail:self.detailText];
        }
    }];
    [actionSheet addButtonWithTitle:@"修改字体颜色" block:^{
        HHLabel *label = (HHLabel *)[self.newsView viewWithTag:detailTag];
        if (label) {
            label.textColor = [UIColor CLRedTextColor];
            [self.newsView setupWithContent:self.detail detail:self.detailText];
        }
    }];
    [actionSheet addCancelButtonWithTitle:@"取消"];
    [actionSheet showInView:self.view];
}

#pragma mark - UIScrollView Delegate
static CGFloat beginPointY;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.shouldHideNaviBar = YES;
    beginPointY =  scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.shouldHideNaviBar) {
        CGFloat currentPonitY = scrollView.contentOffset.y;
        if (currentPonitY > beginPointY
            && currentPonitY >= 0
            && scrollView.height + scrollView.contentOffset.y <= scrollView.contentSize.height) {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        } else {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
        beginPointY = currentPonitY;
    }
    
    if (scrollView.height + scrollView.contentOffset.y > scrollView.contentSize.height && !self.shouldHideNaviBar) {
        self.shouldHideNaviBar = YES;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    self.shouldHideNaviBar = NO;
}
@end