//
//  WZUWebContentFetcher.h
//  job
//
//  Created by Wee Tom on 13-1-3.
//  Copyright (c) 2013年 Wee Tom. All rights reserved.
//

#import "WebContentFetcher.h"

#define Job_WZU_EDU_CN          @"http://job.wzu.edu.cn/"

// 通知公告
#define ListRoute               @"List.aspx"
    #define ListTid_Notice      @"2"
    #define ListTid_Dynamic     @"6"

#define JobRoute                @"Job.aspx"

#define JobsRoute               @"Jobs.aspx"
//……

#define ShowNewsRoute           @"ShowNews.aspx"
#define ShowJobRoute            @"ShowJob.aspx"

@interface WZUWebContentFetcher : WebContentFetcher
+ (NSString *)fetchListContentFrom:(NSString *)route withTid:(NSString *)tid atPage:(NSInteger)page;

+ (NSString *)fetchDetailContentFrom:(NSString *)route withTid:(NSString *)tid andID:(NSString *)_id;
@end
