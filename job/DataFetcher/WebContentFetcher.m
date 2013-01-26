//
//  WebContentFetcher.m
//  job
//
//  Created by Wee Tom on 13-1-3.
//  Copyright (c) 2013年 Wee Tom. All rights reserved.
//

#import "WebContentFetcher.h"
#import "HHKit.h"

@implementation WebContentFetcher
+ (NSString *)fetchSouce:(NSString *)source {
    HHLog(@"source: %@", source);
    NSString * appConnect = [[NSString alloc]
                             initWithContentsOfURL:[NSURL URLWithString:source]
                             encoding: CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)
                             error:nil];
    return appConnect;
}
@end
