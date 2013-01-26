//
//  DataManager.h
//  job
//
//  Created by Wee Tom on 13-1-19.
//  Copyright (c) 2013年 Wee Tom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLCacheKeyDefine.h"
#import "CLCache.h"

@interface DataManager : NSObject
+ (id)objectForKey:(NSString *)key;
+ (void)setObject:(id)obj forKey:(NSString *)key;
+ (void)clearAllCachedData;
@end
