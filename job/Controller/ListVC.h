//
//  NewsListVC.h
//  job
//
//  Created by Wee Tom on 13-1-4.
//  Copyright (c) 2013年 Wee Tom. All rights reserved.
//

#import "CLViewController.h"
#import "DataManager.h"

@interface ListVC : CLViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *contents;

- (void)finishLoadingData:(NSString *)content;
- (void)finishLoadingMoreData:(NSString *)content;
- (void)renderData;
@end
