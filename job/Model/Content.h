//
//  News.h
//  job
//
//  Created by Wee Tom on 13-1-3.
//  Copyright (c) 2013年 Wee Tom. All rights reserved.
//

#import <Foundation/Foundation.h>
#define Job_WZU_EDU_CN          @"http://job.wzu.edu.cn/"

@interface NSMutableDictionary (Content)

// common attributes
- (NSString *)type;
- (void)setType:(NSString *)type;

- (NSString *)title;
- (void)setTitle:(NSString *)title;

- (NSString *)url;
- (void)setUrl:(NSString *)url;
- (NSString *)fullUrl;

// job & news attributes
- (NSString *)date;
- (void)setDate:(NSString *)date;

// job attributes
- (NSString *)job;
- (void)setJob:(NSString *)job;

- (NSString *)clicks;
- (void)setClicks:(NSString *)clicks;

- (NSString *)detailText;

// news detailed attributes
- (NSString *)writer;
- (void)setWriter:(NSString *)writer;

- (NSString *)editor;
- (void)setEditor:(NSString *)editor;

- (NSString *)content;
- (void)setContent:(NSString *)content;

- (NSArray *)images;
- (void)setImages:(NSArray *)images;

// job detailed attribute
- (NSString *)company;
- (void)setCompany:(NSString *)company;

- (NSString *)tel;
- (void)setTel:(NSString *)tel;

- (NSString *)mobile;
- (void)setMobile:(NSString *)mobile;

- (NSString *)address;
- (void)setAddress:(NSString *)address;

- (NSString *)email;
- (void)setEmail:(NSString *)email;

- (NSString *)info;
- (void)setInfo:(NSString *)info;
@end
