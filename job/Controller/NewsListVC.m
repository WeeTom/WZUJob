//
//  NewsListVC.m
//  job
//
//  Created by Wee Tom on 13-1-4.
//  Copyright (c) 2013年 Wee Tom. All rights reserved.
//

#import "NewsListVC.h"
#import "NaviBarTitleButton.h"
#import "CategoryVC.h"
#import "CQMFloatingController.h"

@interface NewsListVC () <CategoryVCDelegate>
@property (strong, nonatomic) NaviBarTitleButton *titleBtn;
@property (strong, nonatomic) CategoryVC *categoryVC;
@end

@implementation NewsListVC
- (void)clearProperties {
    [super clearProperties];
    _titleBtn = nil;
    
    _categoryVC.delegate = nil;
    _categoryVC = nil;
}

- (void)finishLoadingData:(NSString *)content {
    self.contents = [[WZUWebContentProcessor processList:content] mutableCopy];
        
    if ([[self.parameters objectForKey:@"Tid"] isEqualToString:@"2"]) {
        [self.navigationController setTitleText:@"通知公告"];
    } else {
        [self.titleBtn setTitleText:[NSString stringWithFormat:@"当前分类:%@", [WZUWebContentProcessor processTitle:content]]];
        [self.titleBtn addTarget:self action:@selector(showCategoryVC) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.titleView = self.titleBtn;
    }
    
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
    cell.textLabel.text = news.title;
    cell.detailTextLabel.text = news.date;
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
        _categoryVC.title = @"分类选择";
        _categoryVC.delegate = self;
    }
    return _categoryVC;
}

- (void)showCategoryVC {
    NSMutableArray *categories = [NSMutableArray array];
    
    [categories addObject:[@{
                           @"type" : @"category",
                           @"url"  : @"List.aspx?Tid=6",
                           @"title": @"工作动态"
                           } mutableCopy]];
    
    [categories addObject:[@{
                           @"type" : @"category",
                           @"url"  : @"Jobs.aspx?Tid=8",
                           @"title": @"温州大学校内招聘会"
                           } mutableCopy]];
    
    [categories addObject:[@{
                           @"type" : @"category",
                           @"url"  : @"Jobs.aspx?Tid=9",
                           @"title": @"温州大学校外招聘会"
                           } mutableCopy]];
    
    self.categoryVC.categories = categories;
    
    [[CQMFloatingController sharedFloatingController] presentViewController:self.categoryVC animated:YES completion:^{}];
}

- (void)categoryVC:(CategoryVC *)vc didSelectCategory:(NSMutableDictionary *)category {
    CLViewController *newVC = (CLViewController *)[CLRouter match:[NSString stringWithFormat:@"%@&title=%@", category.url, [NSString stringWithFormat:@"当前分类:%@", category.title]]];
    if (newVC) {
        [self.navigationController replaceVisibleViewController:newVC animated:NO];
    }
}

@end
