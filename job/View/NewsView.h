//
//  NewsHeaderView.h
//  job
//
//  Created by Wee Tom on 13-1-5.
//  Copyright (c) 2013年 Wee Tom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Content.h"
#import "HHKit.h"
#import "CLUIDefine.h"

#define dateTag     10
#define titleTag    11
#define editorTag   12
#define writerTag   13
#define detailTag   14

@interface NewsView : UIScrollView
- (void)setupWithContent:(NSMutableDictionary *)content detail:(NSString *)detail;
@end
