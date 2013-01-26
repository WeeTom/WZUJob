//
//  JobVC.m
//  job
//
//  Created by Wee Tom on 13-1-4.
//  Copyright (c) 2013年 Wee Tom. All rights reserved.
//

#import "JobVC.h"
#import "Content.h"
#import "CQMFloatingController.h"
#import "DetailTextVC.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MapKit/MapKit.h>
#import "JSONKit.h"

@interface JobVC () <MFMailComposeViewControllerDelegate>
@end

@implementation JobVC
#pragma mark - propeties
- (void)clearProperties {
    [super clearProperties];
}

#pragma mark - hooks
- (NSArray *)hooksAfterLoadView {
    NSMutableArray *hooks = [[super hooksAfterLoadView] mutableCopy];
    [hooks addObject:@"resetupTableView"];
    return hooks;
}

- (void)setupNavigationBar {
    [super setupNavigationBar];
    [self.navigationController setTitleText:@"职位详情"];
}

- (void)resetupTableView {
    [self.tableView removeFromSuperview];
    self.tableView            = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    [self.view addSubview:self.tableView];
}

- (void)finishLoadingData:(NSString *)content {
    self.detail = [WZUWebContentProcessor processJobDetail:content];
    self.detail.url = [NSString stringWithFormat:@"%@?Tid=%@&ID=%@", self.route, self.tid, self._id];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8 + 1*(self.detail.content.trim.length > 0);
}

#define JobIndex     0
#define DateIndex    1
#define InfoIndex    2
#define CompanyIndex 3
#define TelIndex     4
#define MobileIndex  5
#define EmailIndex   6
#define AddressIndex 7
#define ContentIndex 8

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"JobVC Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.row) {
        case JobIndex:
            cell.textLabel.text = @"职位名称";
            cell.detailTextLabel.text = self.detail.job;
            break;
        case CompanyIndex:
            cell.textLabel.text = @"单位名称";
            cell.detailTextLabel.text = self.detail.company;
            break;
        case DateIndex:
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"发布日期";
            cell.detailTextLabel.text = self.detail.date;
            break;
        case TelIndex:
            cell.textLabel.text = @"电话号码";
            cell.detailTextLabel.text = self.detail.tel;
            if (self.detail.tel.trim.length == 0) {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            break;
        case MobileIndex:
            cell.textLabel.text = @"手机号码";
            cell.detailTextLabel.text = self.detail.mobile;
            if (self.detail.mobile.trim.length == 0) {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            break;
        case AddressIndex:
            cell.textLabel.text = @"单位地址";
            cell.detailTextLabel.text = self.detail.address;
            if (self.detail.address.trim.length == 0) {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            break;
        case EmailIndex:
            cell.textLabel.text = @"电子邮箱";
            cell.detailTextLabel.text = self.detail.email;
            if (self.detail.email.trim.length == 0) {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            break;
        case InfoIndex:
            cell.textLabel.text = @"岗位信息";
            cell.detailTextLabel.text = self.detail.info;
            if (self.detail.info.trim.length == 0) {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            break;
        case ContentIndex:
            cell.textLabel.text = @"备注信息";
            cell.detailTextLabel.text = self.detail.content;
            if (self.detail.content.trim.length == 0) {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case JobIndex: {
            [self presentDetailTextVC:@"职位名称" text:self.detail.job];
        }
            break;
        case CompanyIndex:{
            HHActionSheet *actionSheet = [[HHActionSheet alloc] initWithTitle:@""];
            [actionSheet addButtonWithTitle:@"查看全文" block:^{
                [self presentDetailTextVC:@"单位名称" text:self.detail.company];
            }];
            [actionSheet addButtonWithTitle:@"通过百度搜索" block:^{
                [self searchTextViaBaidu:self.detail.company];
            }];
            [actionSheet addCancelButtonWithTitle:@"取消"];
            [actionSheet showInView:self.view];
        }
        break;
        case DateIndex:
        break;
        case TelIndex: {
            NSString *number = self.detail.tel;
            if (number.trim.length == 0) {
                return;
            }
            HHActionSheet *actionSheet = [[HHActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"电话号码:%@", number]];
            if (number && [number length] > 0) {
                [actionSheet addDestructiveButtonWithTitle:@"拨打电话" block:^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", number]]];
                }];
            }
            [actionSheet addCancelButtonWithTitle:@"取消"];
            [actionSheet showInView:self.view];
        }
        break;
        case MobileIndex: {
            NSString *number = self.detail.mobile;
            if (number.trim.length == 0) {
                return;
            }
            HHActionSheet *actionSheet = [[HHActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"手机号码:%@", number]];
            if (number && [number length] > 0) {
                [actionSheet addDestructiveButtonWithTitle:@"拨打手机" block:^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", number]]];
                }];
            }
            [actionSheet addCancelButtonWithTitle:@"取消"];
            [actionSheet showInView:self.view];
        }
        break;
        case AddressIndex:{
            if (self.detail.address.trim.length == 0) {
                return;
            }
            [self openMaps];
            }
        break;
        case EmailIndex:
            if (self.detail.email.trim.length == 0) {
                return;
            }
            [self sendEmail];
            break;
        case InfoIndex: {
            if (self.detail.info.trim.length == 0) {
                return;
            }
            [self presentDetailTextVC:@"岗位信息" text:self.detail.info];
        }
        break;
        case ContentIndex: {
            if (self.detail.content.trim.length == 0) {
                return;
            }
            [self presentDetailTextVC:@"备注信息" text:self.detail.content];
        }
        break;
    }

}

#pragma mark - sendEmail
- (void)sendEmail
{
    if ([MFMailComposeViewController canSendMail]) {
        [self presentModalViewControllerWithBlock:^UIViewController *{
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate = self;
            
            [picker setSubject:[NSString stringWithFormat:@"应聘%@", self.detail.job]];
            [picker setToRecipients:@[self.detail.email]];
            [picker setCcRecipients:@[@"wzaop@qq.com"]];
            [picker setMessageBody:@"<br/><br/>通过温州大学就业网iOS阅读器发送" isHTML:YES];
            
            return picker;
        } animated:YES];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	[controller dismissViewControllerAnimated:YES completion:^{}];
}

- (void)presentDetailTextVC:(NSString *)title text:(NSString *)text {
    DetailTextVC *textVC = [[DetailTextVC alloc] init];
    textVC.title = title;
    textVC.text = text;
    [[CQMFloatingController sharedFloatingController] presentViewController:textVC animated:YES completion:^{}];
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
    }];
    [actionSheet addButtonWithTitle:@"分享到微博" block:^{
    }];
    [actionSheet addCancelButtonWithTitle:@"取消"];
    [actionSheet showInView:self.view];
}

- (void)openMaps {
    [SVProgressHUD showWithStatus:@"获取经纬度中\n(经纬度信息来自百度)"];
    __block CLLocationCoordinate2D to = CLLocationCoordinate2DMake(0, 0);
    [HHThreadHelper performBlockInBackground:^{
        
        NSString *urlString = [[NSString stringWithFormat:@"http://api.map.baidu.com/geocoder?address=%@&output=json&key=37492c0ee6f924cb5e934fa08c6b1676", self.detail.address] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] returningResponse:nil error:nil];
        
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        NSDictionary *result = (NSDictionary *)[returnString objectFromJSONString];
        HHLog(@"%@", result);
        result = [result objectForKey:@"result"];
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *latAndLng = [result objectForKey:@"location"];
            if (latAndLng) {
                to = CLLocationCoordinate2DMake([[latAndLng objectForKey:@"lat"] floatValue] - 0.0060, [[latAndLng objectForKey:@"lng"] floatValue] - 0.0065);
            }
        }
        
    } completion:^{
        [SVProgressHUD dismiss];
        if (to.latitude == 0 && to.longitude == 0) {
            HHActionSheet *actionSheet = [[HHActionSheet alloc] initWithTitle:@"没有获取到经纬度信息"];
            [actionSheet addButtonWithTitle:@"通过百度搜索" block:^{
                [self searchTextViaBaidu:self.detail.address];
            }];
            [actionSheet addCancelButtonWithTitle:@"取消"];
            [actionSheet showInView:self.view];
            return ;
        }
        Class itemClass = [MKMapItem class];
        if (itemClass && [itemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]) {
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil] ];
            toLocation.name = [NSString stringWithFormat:@"%@", self.detail.address];
            [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:toLocation, nil] launchOptions:nil];
        } else {
            NSMutableString *mapURL = [NSMutableString stringWithString:@"http://maps.google.com/maps?"];
            [mapURL appendFormat:@"&daddr=%f,%f", to.latitude, to.longitude];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[mapURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        }
    }];
}

- (void)searchTextViaBaidu:(NSString *)text {
    NSString *string = [NSString stringWithFormat:@"http://www.baidu.com/s?wd=%@", text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}
@end
