//
//  News.m
//  job
//
//  Created by Wee Tom on 13-1-3.
//  Copyright (c) 2013年 Wee Tom. All rights reserved.
//

#import "Content.h"
#import "HHKit.h"

#define Type      @"type"
#define Title     @"title"
#define Date      @"date"
#define URL       @"url"
#define Job       @"job"
#define Clicks    @"clicks"
#define Writer    @"writer"
#define Editor    @"editor"
#define Detail    @"detail"
#define Images    @"images"
#define Company   @"company"
#define Tel       @"tel"

@implementation NSMutableDictionary (Content)
- (void)setNotNilObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (anObject) {
        [self setObject:anObject forKey:aKey];
    } else {
        HHLog([@"Trying To Insert Nil into Key:" stringByAppendingFormat:@"%@", aKey]);
    }
}

- (NSString *)type {
    return [self objectForKey:Type];
}

- (void)setType:(NSString *)type {
    [self setNotNilObject:type forKey:Type];
}

- (NSString *)title {
    return [self objectForKey:Title];
}

- (void)setTitle:(NSString *)title {
    [self setNotNilObject:title forKey:Title];
}

- (NSString *)date {
    return [self objectForKey:Date];
}

- (void)setDate:(NSString *)date {
    [self setNotNilObject:date forKey:Date];
}

- (NSString *)url {
    return [self objectForKey:URL];
}

- (void)setUrl:(NSString *)url {
    [self setNotNilObject:url forKey:URL];
}

- (NSString *)fullUrl {
    return [Job_WZU_EDU_CN stringByAppendingFormat:@"%@", self.url];
}

- (NSString *)job {
    return [self objectForKey:Job];
}

- (void)setJob:(NSString *)job {
    [self setNotNilObject:job forKey:Job];
}

- (NSString *)clicks {
    return [self objectForKey:Clicks];
}

- (void)setClicks:(NSString *)clicks {
    [self setNotNilObject:clicks forKey:Clicks];
}

- (NSString *)detailText {
    NSMutableString *string = [NSMutableString string];
    if (self.company) {
        [string appendString:self.company];
    }
    
    if (self.company && self.date) {
        [string appendString:@" "];
    }
    
    if (self.date) {
        [string appendString:self.date];
    }
    return string;
}

- (NSString *)writer {
    return [self objectForKey:@"writer"];
}

- (void)setWriter:(NSString *)writer {
    [self setNotNilObject:writer forKey:Writer];
}

- (NSString *)editor {
    return [self objectForKey:Editor];
}

- (void)setEditor:(NSString *)editor {
    [self setNotNilObject:editor forKey:Editor];
}

- (NSString *)content {
    return [self objectForKey:Detail];
}

- (void)setContent:(NSString *)content {
    [self setNotNilObject:content forKey:Detail];
}

- (NSArray *)images {
    return [self objectForKey:Images];
}

- (void)setImages:(NSArray *)images {
    [self setNotNilObject:images forKey:Images];
}

- (NSString *)company {
    return [self objectForKey:Company];
}

- (void)setCompany:(NSString *)company {
    [self setNotNilObject:company forKey:Company];
}


- (NSString *)tel {
   return [self objectForKey:Tel];
}

- (void)setTel:(NSString *)tel {
    [self setNotNilObject:tel forKey:Tel];
}

#define Mobile @"mobile"
- (NSString *)mobile {
    return [self objectForKey:Mobile];
}

- (void)setMobile:(NSString *)mobile {
    [self setNotNilObject:mobile forKey:Mobile];
}

#define Add @"address"
- (NSString *)address {
    return [self objectForKey:Add];
}

- (void)setAddress:(NSString *)address {
    [self setNotNilObject:address forKey:Add];
}

#define Email @"email"
- (NSString *)email {
    return [self objectForKey:Email];
}

- (void)setEmail:(NSString *)email {
    [self setNotNilObject:email forKey:Email];
}

#define Info @"info"
- (NSString *)info {
    return [self objectForKey:Info];
}

- (void)setInfo:(NSString *)info {
    [self setNotNilObject:info forKey:Info];
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[NSMutableDictionary class]]) {
        NSMutableDictionary *content = (NSMutableDictionary *)object;
        if ([content.url isEqualToString:self.url]) {
            return YES;
        }
    }
    return NO;
}
@end
