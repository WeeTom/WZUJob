//
//  DataManager.m
//  job
//
//  Created by Wee Tom on 13-1-19.
//  Copyright (c) 2013年 Wee Tom. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager
+ (id)objectForKey:(NSString *)key {
    NSMutableDictionary *dic = [self currentCacheDic];
    return [dic objectForKey:key];
}

+ (void)setObject:(id)obj forKey:(NSString *)key {
    if (!obj) {
        return;
    }
    NSMutableDictionary *dic = [self currentCacheDic];
    [dic setObject:obj forKey:key];
    [CLCache setObject:dic forKey:CACHE_KEY_AllCachedData];
}

+ (void)clearAllCachedData {
    [CLCache removeObjectForKey:CACHE_KEY_AllCachedData];
}

+ (NSMutableDictionary *)currentCacheDic {
    NSMutableDictionary *dic = [[CLCache objectForKey:CACHE_KEY_AllCachedData] mutableCopy];
    if (!dic) {
        dic = [NSMutableDictionary dictionary];
    }
    return dic;
}
@end
