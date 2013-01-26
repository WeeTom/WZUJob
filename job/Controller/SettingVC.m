//
//  SettingVC.m
//  job
//
//  Created by Wee Tom on 13-1-20.
//  Copyright (c) 2013年 Wee Tom. All rights reserved.
//

#import "SettingVC.h"

#define SECTION_WEIBO       0
#define SECTION_CACHE       2
#define SECTION_VIEW        1
#define SECTION_VERSION     4
#define SECTION_DEVELOPER   3
@interface SettingVC ()
@property (strong, nonatomic) UISwitch *nightViewSwitch;
@end

@implementation SettingVC
#pragma mark - propeties
- (void)clearProperties {
    [super clearProperties];
    _nightViewSwitch = nil;
}

#pragma mark - hooks
- (NSArray *)hooksAfterLoadView {
    NSMutableArray *hooks = [[super hooksAfterLoadView] mutableCopy];
    [hooks addObject:@"resetupTableView"];
    return hooks;
}

- (NSArray *)hooksBeforeViewDidUnload {
    NSMutableArray *hooks = [[super hooksBeforeViewDidUnload] mutableCopy];
    return hooks;
}

- (void)setupNavigationBar {
    [super setupNavigationBar];
    [self.navigationController setTitleText:@"设置"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:    self.navigationController action:@selector(popWithAnimated)];
}

- (void)resetupTableView {
    [self.tableView removeFromSuperview];
    self.tableView            = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case SECTION_CACHE:
            return @"";
        case SECTION_DEVELOPER:
            return @"";
        case SECTION_VERSION:
            return @"";
        case SECTION_VIEW:
            return @"";
        case SECTION_WEIBO:
            return @"新浪微博";
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"SettingVC Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    switch (indexPath.section) {
        case SECTION_DEVELOPER:
            cell.textLabel.text = @"Product of WeeTom";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            break;
        case SECTION_CACHE:
            cell.textLabel.text = @"清空缓存";
            break;
        case SECTION_WEIBO:
            cell.textLabel.text = @"新浪微博";
            break;
        case SECTION_VERSION:
            cell.textLabel.text = [NSString stringWithFormat:@"Version %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            break;
        case SECTION_VIEW:
            cell.textLabel.text = @"夜间模式";
            cell.accessoryView = self.nightViewSwitch;
            break;
        default:
            break;
    }
    return cell;
}

- (UISwitch *)nightViewSwitch {
    if (!_nightViewSwitch) {
        _nightViewSwitch = [[UISwitch alloc] init];
        [_nightViewSwitch addTarget:self action:@selector(switchToNightView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nightViewSwitch;
}

- (void)switchToNightView {
    if (self.nightViewSwitch.on) {
        [CLCache setBool:YES forKey:CACHE_KEY_NightView];
        HHLog(@"NightSwitch");
    } else {
        [CLCache setBool:NO forKey:CACHE_KEY_NightView];
        HHLog(@"CancelNightSwitch");
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:CLNotificationNightViewSwitched object:nil];
}
@end
