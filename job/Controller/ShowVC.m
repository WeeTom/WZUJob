//
//  ShowVC.m
//  job
//
//  Created by Wee Tom on 13-1-5.
//  Copyright (c) 2013年 Wee Tom. All rights reserved.
//

#import "ShowVC.h"
#import "Content.h"

@interface ShowVC ()
@end

@implementation ShowVC
- (id)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

#pragma mark - properties
- (void)clearProperties {
    [super clearProperties];
    _detail = nil;
}

- (NSString *)route {
    return self.apiPath;
}

- (NSString *)_id {
    return [self.parameters objectForKey:@"ID"];
}

- (NSString *)tid {
    return [self.parameters objectForKey:@"Tid"];
}

#pragma mark - hooks 
- (NSArray *)hooksAfterLoadView {
    NSMutableArray *hooks = [[super hooksAfterLoadView] mutableCopy];
    [hooks addObject:@"reSetupView"];
    [hooks addObject:@"loadData"];
    return hooks;
}

- (void)reSetupView {
    self.view.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].applicationFrame.size.height - self.navigationController.navigationBar.frame.size.height);
}

- (void)loadData {
    if (self.isLoading) return;
    self.isLoading = YES;
    
    __block NSString *content = [DataManager objectForKey:self.fullApiPath];
    if (content) {
        [self finishLoadingData:content];
    }
    
    [HHThreadHelper performBlockInBackground:^{
        content = [WZUWebContentFetcher fetchDetailContentFrom:self.route withTid:self.tid andID:self._id];
        [DataManager setObject:content forKey:self.fullApiPath];
    } completion:^{
        self.isLoading = NO;
        [CLCache setObject:content forKey:self.fullApiPath];
        [self finishLoadingData:content];
    }];
}

- (void)finishLoadingData:(NSString *)content {
    
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
        ];
    }
}

- (void)showActionSheet {

}

- (void)addToFavoutites {
    [FavManager addFavItem:self.detail];
}
@end
