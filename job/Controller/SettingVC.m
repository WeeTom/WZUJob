//
//  SettingVC.m
//  job
//
//  Created by Wee Tom on 13-1-20.
//  Copyright (c) 2013年 Wee Tom. All rights reserved.
//

#import "SettingVC.h"
#import "DataManager.h"
#import "SDImageCache.h"
#import "CLSinaWeibo.h"

#define SECTION_WEIBO       0
#define SECTION_CACHE       2
#define SECTION_VIEW        1
#define SECTION_VERSION     4
#define SECTION_DEVELOPER   3
@interface SettingVC ()
@property (strong, nonatomic) UISwitch *showImageSwitch;
@end

@implementation SettingVC
#pragma mark - propeties
- (void)clearProperties {
    [super clearProperties];
    _showImageSwitch = nil;
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
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.textColor = [UIColor CLDarkGrayColor];
    cell.textLabel.font = [UIFont CLFontSize:17 bold:YES];
    cell.accessoryView = nil;
    switch (indexPath.section) {
        case SECTION_DEVELOPER:
            cell.textLabel.text = @"Product of WeeTom";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            break;
        case SECTION_CACHE:
            cell.textLabel.text = @"清空缓存";
            break;
        case SECTION_WEIBO: {
            cell.textLabel.text = @"新浪微博";
            HHLabel *label = [[HHLabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor CLGrayTextColor];
            label.font = [UIFont CLFontSize:17 bold:YES];
            if ([[CLSinaWeibo shared] isLoggedIn] && ![[CLSinaWeibo shared] isAuthorizeExpired]) {
                label.text = [CLCache stringForKey:@"sinaWeiboNickname"];
            } else {
                label.text = @"未绑定";
            }
            [label autoResize:CGSizeMake(200, 44)];
            label.offset = CGPointMake(300 - label.width, 22 - label.height/2);
            cell.accessoryView = label;
        }
            break;
        case SECTION_VERSION:
            cell.textLabel.text = [NSString stringWithFormat:@"Version %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            break;
        case SECTION_VIEW:
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"显示图片";
            cell.accessoryView = self.showImageSwitch;
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case SECTION_DEVELOPER:
            break;
        case SECTION_CACHE:
            [SVProgressHUD showWithStatus:@"清除中"];
            [[SDImageCache sharedImageCache] clearMemory];
            [DataManager clearAllCachedData];
            [SVProgressHUD showSuccessWithStatus:@"已清空"];
            break;
        case SECTION_WEIBO: {
            if (![[CLSinaWeibo shared] isLoggedIn] || [[CLSinaWeibo shared] isAuthorizeExpired]) {
                [[CLSinaWeibo shared] logInAndPerform:^{
                    [SVProgressHUD dismiss];
                    [self.tableView reloadData];
                }];
            } else {
                HHActionSheet *actionSheet = [[HHActionSheet alloc] initWithTitle:@""];
                [actionSheet addDestructiveButtonWithTitle:@"解除绑定" block:^{
                    [[CLSinaWeibo shared] logOutAndPerform:^{
                        [self.tableView reloadData];
                    }];
                }];
            }
        }
            break;
        case SECTION_VERSION:
            break;
        case SECTION_VIEW:
            break;
        default:
            break;
    }
}

- (UISwitch *)showImageSwitch {
    if (!_showImageSwitch) {
        _showImageSwitch = [[UISwitch alloc] init];
        [_showImageSwitch addTarget:self action:@selector(showImage) forControlEvents:UIControlEventTouchUpInside];
        _showImageSwitch.on = [CLCache boolForKey:CACHE_KEY_ShowImage];
    }
    return _showImageSwitch;
}

- (void)showImage {
    if (self.showImageSwitch.on) {
        [CLCache setBool:YES forKey:CACHE_KEY_ShowImage];
    } else {
        [CLCache setBool:NO forKey:CACHE_KEY_ShowImage];
    }
}
@end
