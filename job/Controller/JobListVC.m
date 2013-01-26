//
//  JobListVC.m
//  job
//
//  Created by Wee Tom on 13-1-4.
//  Copyright (c) 2013年 Wee Tom. All rights reserved.
//

#import "JobListVC.h"
#import "CategoryVC.h"
#import "CQMFloatingController.h"
#import "CLCacheKeyDefine.h"
#import "NaviBarTitleButton.h"

@interface JobListVC () <CategoryVCDelegate>
@property (strong, nonatomic) NaviBarTitleButton *titleBtn;
@property (strong, nonatomic) CategoryVC *categoryVC;
@end

@implementation JobListVC
- (void)clearProperties {
    [super clearProperties];
    
    _titleBtn = nil;
    
    _categoryVC.delegate = nil;
    _categoryVC = nil;
}

- (void)finishLoadingData:(NSString *)content {
    self.contents = [[WZUWebContentProcessor processList:content] mutableCopy];
        
    NSArray *array = [WZUWebContentProcessor processCategory:content];
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:CACHE_KEY_JobCategory];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.titleBtn setTitleText:[NSString stringWithFormat:@"当前专业:%@", [WZUWebContentProcessor processTitle:content]]];
    [self.titleBtn addTarget:self action:@selector(showCategoryVC) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = self.titleBtn;
    
    [self renderData];
}

- (void)finishLoadingMoreData:(NSString *)content {
    NSArray *moreData = [WZUWebContentProcessor processList:content];
    if (moreData.count == 0) {
        self.isEnd = YES;
    } else {
        [self.contents addObjectsFromArray:moreData];
        [self renderData];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"NewsListVC Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSMutableDictionary *news = [self.contents objectAtIndex:indexPath.row];
    cell.textLabel.text = news.job;
    cell.detailTextLabel.text = news.detailText;
    return cell;
}

#pragma mark - TitleBtn
- (NaviBarTitleButton *)titleBtn {
    if (!_titleBtn) {
        _titleBtn = [[NaviBarTitleButton alloc] init];
    }
    return _titleBtn;
}

#pragma mark - CategoryVC
- (CategoryVC *)categoryVC {
    if (!_categoryVC) {
        _categoryVC = [[CategoryVC alloc] initWithStyle:UITableViewStylePlain];
        _categoryVC.title = @"专业选择";
        _categoryVC.delegate = self;
    }
    return _categoryVC;
}

- (void)showCategoryVC {
    self.categoryVC.categories     = [[NSUserDefaults standardUserDefaults] objectForKey:CACHE_KEY_JobCategory];
    
    [[CQMFloatingController sharedFloatingController] showInView:self.tabBarController.view withContentViewController:self.categoryVC animated:YES];
}

- (void)categoryVC:(CategoryVC *)vc didSelectCategory:(NSMutableDictionary *)category {
    CLViewController *newVC = (CLViewController *)[CLRouter match:[NSString stringWithFormat:@"%@&title=%@", category.url, [NSString stringWithFormat:@"当前专业:%@", category.title]]];
    [self.navigationController replaceVisibleViewController:newVC animated:NO];
}

@end
