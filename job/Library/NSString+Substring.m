//
//  NSString+Substring.m
//  job
//
//  Created by Wee Tom on 13-1-3.
//  Copyright (c) 2013年 Wee Tom. All rights reserved.
//

#import "NSString+Substring.h"

@implementation NSString (Substring)
- (BOOL)containsStrings:(NSArray *)subStrings {
    for (NSString *string in subStrings) {
        NSRange range = [self rangeOfString:string];
        if (range.location + string.length > self.length) {
            return NO;
        }
    }
    return YES;
}

- (NSString *)subStringFromString:(NSString *)fromString toString:(NSString *)toString {
    NSString *tempString = self;
    if (fromString) {
        NSRange fromRange = [tempString rangeOfString:fromString];
        if (fromRange.location + fromString.length < tempString.length) {
            tempString = [tempString substringFromIndex:fromRange.location + fromString.length];
        } else {
            return nil;
        }
    }
    
    if (toString) {
        NSRange toRange = [tempString rangeOfString:toString];
        if (toRange.location + toString.length < tempString.length) {
            tempString = [tempString substringToIndex:toRange.location];
        }
    }
    
    return tempString;
}

- (NSString *)replacingOccurrencesOfStrings:(NSArray *)targets withString:(NSString *)replacement {
    NSString *tempString = [self copy];
    for (NSString *s in targets) {
        if (![s isKindOfClass:[NSString class]]) {
            continue;
        }
        
        tempString = [tempString stringByReplacingOccurrencesOfString:s withString:replacement];
    }

    return tempString;
}
@end
