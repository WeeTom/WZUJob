//
//  FavouritesVC.m
//  job
//
//  Created by Wee Tom on 13-1-20.
//  Copyright (c) 2013年 Wee Tom. All rights reserved.
//

#import "FavouritesVC.h"
#import "CLCacheKeyDefine.h"
#import "FavManager.h"

@interface FavouritesVC ()
@property (strong, nonatomic) NSMutableArray *favourites;
@end

@implementation FavouritesVC
- (void)clearProperties {
    [super clearProperties];
    _favourites = nil;
}

- (void)setupNavigationBar {
    [super setupNavigationBar];
    [self.navigationController setTitleText:@"我的收藏"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleBordered target:self action:@selector(showSettingVC)];
}

- (void)resetupTableView {
    self.tableView.frame = self.view.bounds;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (NSArray *)hooksAfterLoadView {
    NSMutableArray *hooks = [[super hooksAfterLoadView] mutableCopy];
    [hooks addObject:@"loadData"];
    [hooks addObject:@"resetupTableView"];
    [hooks addObject:@"addFavouriteNotification"];
    return hooks;
}

- (NSArray *)hooksBeforeViewDidUnload {
    NSMutableArray *hooks = [[super hooksBeforeViewDidUnload] mutableCopy];
    [hooks addObject:@"removeFavouriteNotification"];
    return hooks;}

- (void)loadData {
    self.favourites = [[FavManager favs] mutableCopy];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.favourites.count;
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
    
    NSMutableDictionary *content = [self.favourites objectAtIndex:indexPath.row];
    if ([content.type isEqualToString:@"news"]) {
        cell.textLabel.text = content.title;
        cell.detailTextLabel.text = content.date;
    } else if ([content.type isEqualToString:@"job"]) {
        cell.textLabel.text = content.job;
        cell.detailTextLabel.text = content.detailText;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableDictionary *content = [self.favourites objectAtIndex:indexPath.row];
    [CLRouter navigateTo:content.url withNavigationController:self.navigationController];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableDictionary *content = [self.favourites objectAtIndex:indexPath.row];
        [FavManager removeFavedItem:content];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)addFavouriteNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newFavoutiteAdded:) name:CLNotificationNewFavAdded object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(favouritedRemoved:) name:CLNotificationFavedRemoved object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allFavouritedRemoved) name:CLNotificationAllFavedRemoved object:nil];
}

- (void)removeFavouriteNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CLNotificationNewFavAdded object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CLNotificationFavedRemoved object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CLNotificationAllFavedRemoved object:nil];
}

- (void)newFavoutiteAdded:(NSNotification *)notification {
    self.favourites = [[FavManager favs] mutableCopy];
    [self.tableView reloadData];
}

- (void)favouritedRemoved:(NSNotification *)notification {
    self.favourites = [[FavManager favs] mutableCopy];
    [self.tableView reloadData];
}

- (void)allFavouritedRemoved {
    self.favourites = [[FavManager favs] mutableCopy];
    [self.tableView reloadData];
}
@end
