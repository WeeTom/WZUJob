//
//  WZUWebContentProcessor.h
//  job
//
//  Created by Wee Tom on 13-1-3.
//  Copyright (c) 2013年 Wee Tom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZUWebContentFetcher.h"
#import "Content.h"

@interface WZUWebContentProcessor : NSObject
// listing
+ (NSString *)processTitle:(NSString *)content;
+ (NSArray *)processCategory:(NSString *)content;
+ (NSArray *)processList:(NSString *)content;

// detail
+ (NSMutableDictionary *)processNewsDetail:(NSString *)content;
+ (NSMutableDictionary *)processJobDetail:(NSString *)content;
@end
