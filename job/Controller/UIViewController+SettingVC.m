//
//  UIViewController+SettingVC.m
//  job
//
//  Created by Wee Tom on 13-1-20.
//  Copyright (c) 2013年 Wee Tom. All rights reserved.
//

#import "UIViewController+SettingVC.h"
#import "CLRouter.h"

@implementation UIViewController (SettingVC)
- (void)showSettingVC {
    [CLRouter modallyPresent:@"/setting/" from:self.navigationController];
}
@end
