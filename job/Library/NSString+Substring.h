//
//  NSString+Substring.h
//  job
//
//  Created by Wee Tom on 13-1-3.
//  Copyright (c) 2013年 Wee Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Substring)
- (BOOL)containsStrings:(NSArray *)subStrings;
- (NSString *)subStringFromString:(NSString *)fromString toString:(NSString *)toString;
- (NSString *)replacingOccurrencesOfStrings:(NSArray *)targets withString:(NSString *)replacement;
@end
