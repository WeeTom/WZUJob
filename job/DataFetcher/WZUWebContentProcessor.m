//
//  WZUWebContentProcessor.m
//  job
//
//  Created by Wee Tom on 13-1-3.
//  Copyright (c) 2013年 Wee Tom. All rights reserved.
//

#import "WZUWebContentProcessor.h"
#import "HHKit.h"
#import "NSString+Substring.h"

@implementation WZUWebContentProcessor
+ (NSString *)processTitle:(NSString *)content {
    NSString *title = @"温州大学";
    NSString *titleRawString = [content subStringFromString:@"您现在的位置：" toString:@"</td>"];
    NSArray *stacks = [titleRawString componentsSeparatedByString:@"&gt;&gt;"];
    
    for (int i = 0; i < stacks.count; i++) {
        NSString *location = [stacks objectAtIndex:i];
        title = [location.trim subStringFromString:@">" toString:@"<"];
    }
    return title;
}

+ (NSArray *)processCategory:(NSString *)content {
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *mainContentSymbol = @"<table width=\"218\" border=\"0\" align=\"center\" cellpadding=\"0\" cellspacing=\"0\">";
    NSString *mainContentEndSymbol = @"</table>";
    
    NSString *mainContent = [content replacingOccurrencesOfStrings:@[@"\n", @"\r"] withString:@""];
    mainContent = [mainContent subStringFromString:mainContentSymbol toString:mainContentEndSymbol];
    mainContent = [mainContent replacingOccurrencesOfStrings:@[@"<tbody>", @"</tbody>"] withString:@""];
    
    NSArray *rawArray = [mainContent componentsSeparatedByString:@"</a>"];
    for (NSString *string in rawArray) {
        if (![string isKindOfClass:[NSString class]]) {
            HHLog(@"%@", string);
            continue;
        }
        
        HHLog(@"%d of total %d:", [rawArray indexOfObject:string], rawArray.count);
        NSString *pString = [string replacingOccurrencesOfStrings:@[@"<tr>", @"</tr>"] withString:@""];
        pString = [pString subStringFromString:@"<a" toString:nil];
                
        NSString *url      = [pString subStringFromString:@"href=\"/" toString:@"\""];
        NSString *cTitle = [[pString subStringFromString:@">" toString:nil] trim];
        
        NSMutableDictionary *category = [NSMutableDictionary dictionary];
        
        if ([url containsStrings:@[@"Tid="]]) {
            HHLog(@"category:%@", cTitle);
            HHLog(@"url     :%@", url);
            
            category.type  = @"category";
            category.title = cTitle;
            category.url   = url;
            [array addObject:category];
        }
    }
    
    return array;
}

+ (NSArray *)processList:(NSString *)content {
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *mainContentSymbol = @"<table width=\"710\" border=\"0\" align=\"center\" cellpadding=\"0\" cellspacing=\"0\">";
    NSString *mainContentEndSymbol = @"</table>";
    
    NSString *mainContent = [content replacingOccurrencesOfStrings:@[@"\n", @"\r"] withString:@""];
    mainContent = [mainContent subStringFromString:mainContentSymbol toString:mainContentEndSymbol];
    mainContent = [mainContent replacingOccurrencesOfStrings:@[@"<tbody>", @"</tbody>"] withString:@""];
    
    NSArray *rawArray = [mainContent componentsSeparatedByString:@"</tr>"];
    
    for (NSString *string in rawArray) {
        if (![string isKindOfClass:[NSString class]]) {
            HHLog(@"%@", string);
            continue;
        }
        
        HHLog(@"%d of total %d:", [rawArray indexOfObject:string], rawArray.count);
        NSString *pString = [string replacingOccurrencesOfStrings:@[@"<tr>", @"</tr>"] withString:@""];
        
        NSArray *titleAndDate = [pString componentsSeparatedByString:@"</td>"];
        
        if (titleAndDate.count >= 3) {
            NSString *urlRawString = [titleAndDate objectAtIndex:1];
            urlRawString = [urlRawString subStringFromString:@"<a href=\"" toString:@"\""];
            
            NSString *type               = nil;
            NSString *titleRawString     = nil;
            NSString *dateRawString      = nil;
            NSString *jobRawString       = nil;
            NSString *viewCountRawString = nil;
            
            titleRawString = [titleAndDate objectAtIndex:1];
            titleRawString = [titleRawString subStringFromString:@"<a" toString:@"a>"];
            titleRawString = [titleRawString subStringFromString:@">" toString:@"<"];
            
            if ([urlRawString hasPrefix:@"ShowJob.aspx"]) {
                type = @"job";
                
                jobRawString = [titleAndDate objectAtIndex:2];
                jobRawString = [jobRawString subStringFromString:@">" toString:nil];
                jobRawString = [jobRawString replacingOccurrencesOfStrings:@[@"&nbsp;"] withString:@""];
                
                viewCountRawString = [titleAndDate objectAtIndex:3];
                viewCountRawString = [viewCountRawString subStringFromString:@">" toString:nil];
                viewCountRawString = [viewCountRawString replacingOccurrencesOfStrings:@[@"&nbsp;"] withString:@""];
                
                dateRawString = [titleAndDate objectAtIndex:4];
                dateRawString = [dateRawString subStringFromString:@">" toString:nil];
            } else if ([urlRawString hasPrefix:@"ShowNews.aspx"]) {
                type = @"news";
                
                dateRawString = [titleAndDate objectAtIndex:2];
                dateRawString = [dateRawString subStringFromString:@">" toString:nil];
            }
            

            
            if (titleRawString.length > 0 && dateRawString.length > 0) {
                HHLog(@"url  :%@", urlRawString);
                HHLog(@"type :%@", type);
                HHLog(@"title:%@", titleRawString);
                HHLog(@"date :%@", dateRawString);
                
                NSMutableDictionary *content = [NSMutableDictionary dictionary];
                content.type      = type;
                content.url       = urlRawString;
                content.title     = titleRawString;
                content.date      = dateRawString;
                
                if ([content.type isEqualToString:@"job"]) {
                    content.company   = content.title;
                    content.job       = jobRawString;
                    content.clicks    = viewCountRawString;
                }
                
                [array addObject:content];
            }
        }
    }
    
    
    return array;
}

+ (NSMutableDictionary *)processNewsDetail:(NSString *)content {
    NSMutableDictionary *detail = [NSMutableDictionary dictionary];
    detail.type = @"news";
    NSString *fmTitle    = [content subStringFromString:@"id=\"FM_Title\">" toString:@"<"];
    NSString *fmEditor   = [content subStringFromString:@"id=\"FM_Editor\">" toString:@"<"];
    NSString *fmWriter   = [content subStringFromString:@"id=\"FM_Writer\">" toString:@"<"];
    NSString *fmPostDate = [content subStringFromString:@"id=\"FM_PostDate\">" toString:@"<"];
    NSString *fmClicks   = [content subStringFromString:@"id=\"FM_Clicks\">" toString:@"<"];
    NSString *fmContent  = [content subStringFromString:@"id=\"FM_Content\">" toString:@"</span>"];
    fmContent = [fmContent replacingOccurrencesOfStrings:@[@"<P>&nbsp;</P>"] withString:@""];
    
    HHLog(@"DetailProcessed:");
    HHLog(@"fmTitle        :%@", fmTitle);
    HHLog(@"fmEditor       :%@", fmEditor);
    HHLog(@"fmWriter       :%@", fmWriter);
    HHLog(@"fmPostDate     :%@", fmPostDate);
    HHLog(@"fmClicks       :%@", fmClicks);
//  HHLog(@"fmContent        :%@", fmContent);
    
    detail.title = fmTitle;
    detail.editor = fmEditor;
    detail.writer = fmWriter;
    detail.date  = fmPostDate;
    detail.clicks = fmClicks;
    detail.content = [self removeImagesFromContent:fmContent];
    detail.images = [self processImages:fmContent];
    
    return detail;
}

+ (NSString *)removeImagesFromContent:(NSString *)content {
    NSString *subString = [content subStringFromString:@"<IMG" toString:@">"];
    while (subString) {
        NSString *imageString = [@"<IMG" stringByAppendingFormat:@"%@>", subString];
        content = [content replacingOccurrencesOfStrings:@[imageString] withString:@""];
        subString = [content subStringFromString:@"<IMG" toString:@">"];
    }
    
    return content;
}

+ (NSArray *)processImages:(NSString *)content {
    NSMutableArray *array = [NSMutableArray array];
    NSString *subString = [content subStringFromString:@"<IMG" toString:@">"];
    while (subString) {
        NSString *imageString = [@"<IMG" stringByAppendingFormat:@"%@>", subString];
        content = [content replacingOccurrencesOfStrings:@[imageString] withString:@""];
        subString = [content subStringFromString:@"<IMG" toString:@">"];

        imageString = [imageString replacingOccurrencesOfStrings:@[@"src=\"/UploadFile"] withString:@"src=\"Http://job.wzu.edu.cn/UploadFile"];
        imageString = [imageString subStringFromString:@"src=\"" toString:@"\""];
        if (![imageString hasPrefix:@"Http:/"]) {
            continue;
        }
        [array addObject:imageString];
    }
    return array;
}

+ (NSMutableDictionary *)processJobDetail:(NSString *)content {
    NSMutableDictionary *detail = [NSMutableDictionary dictionary];
    detail.type = @"job";
    NSString *fmJob      = [content subStringFromString:@"id=\"FM_Job\">" toString:@"<"];
    NSString *fmCompany  = [content subStringFromString:@"id=\"FM_Company\">" toString:@"<"];
    NSString *fmPostDate = [content subStringFromString:@"id=\"FM_PostDate\">" toString:@"<"];
    NSString *fmTel      = [content subStringFromString:@"id=\"FM_Tel\">" toString:@"<"];
    NSString *fmMobile   = [content subStringFromString:@"id=\"FM_Mobile\">" toString:@"<"];
    NSString *fmAddress  = [content subStringFromString:@"id=\"FM_Address\">" toString:@"<"];
    NSString *fmEmail    = [content subStringFromString:@"id=\"FM_Email\">" toString:@"<"];
    NSString *fmInfo     = [content subStringFromString:@"id=\"FM_Info\">" toString:@"<"];
    NSString *fmContent  = [content subStringFromString:@"id=\"FM_Content\">" toString:@"</span>"];
    
    HHLog(@"DetailProcessed:");
    HHLog(@"fmJob           :%@", fmJob);
    HHLog(@"fmCompany       :%@", fmCompany);
    HHLog(@"fmPostDate      :%@", fmPostDate);
    HHLog(@"fmTel           :%@", fmTel);
    HHLog(@"fmMobile        :%@", fmMobile);
    HHLog(@"fmAddress       :%@", fmAddress);
    HHLog(@"fmEmail         :%@", fmEmail);
    HHLog(@"fmInfo          :%@", fmInfo);
    HHLog(@"fmContent       :%@", fmContent);
    
    detail.job     = fmJob;
    detail.company = fmCompany;
    detail.date    = fmPostDate;
    detail.tel     = fmTel;
    detail.mobile  = fmMobile;
    detail.address = fmAddress;
    detail.email   = fmEmail;
    detail.info    = fmInfo;
    detail.content = [self removeImagesFromContent:fmContent];
    
    return detail;
}
@end
