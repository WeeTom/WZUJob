//
//  WZUWebContentFetcher.m
//  job
//
//  Created by Wee Tom on 13-1-3.
//  Copyright (c) 2013年 Wee Tom. All rights reserved.
//

#import "WZUWebContentFetcher.h"

@implementation WZUWebContentFetcher
+ (NSString *)fetchListContentFrom:(NSString *)route withTid:(NSString *)tid atPage:(NSInteger)page {
    NSString *source = [Job_WZU_EDU_CN stringByAppendingFormat:@"%@?Tid=%@", route, tid];
    if (page > 1) source = [source stringByAppendingFormat:@"&Page=%d", page];
    
    return [self fetchSouce:source];
}

+ (NSString *)fetchDetailContentFrom:(NSString *)route withTid:(NSString *)tid andID:(NSString *)_id {
    NSString *source = [Job_WZU_EDU_CN stringByAppendingFormat:@"%@?Tid=%@&ID=%@", route, tid, _id];
    return [self fetchSouce:source];
}
@end
