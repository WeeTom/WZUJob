//
//  ShowVC.h
//  job
//
//  Created by Wee Tom on 13-1-5.
//  Copyright (c) 2013年 Wee Tom. All rights reserved.
//

#import "CLViewController.h"
#import "DataManager.h"
#import "FavManager.h"
#import "WechatHelper.h"

@interface ShowVC : CLViewController
@property (readonly, nonatomic) NSString *route;
@property (readonly, nonatomic) NSString *_id;
@property (readonly, nonatomic) NSString *tid;
@property (strong, nonatomic) NSMutableDictionary *detail;

- (void)finishLoadingData:(NSString *)content;
- (void)showActionSheet;
- (void)addToFavoutites;
@end
