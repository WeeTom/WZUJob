//
//  NewsHeaderView.m
//  job
//
//  Created by Wee Tom on 13-1-5.
//  Copyright (c) 2013年 Wee Tom. All rights reserved.
//

#import "NewsView.h"
#import "UIImageView+WebCache.h"
#import "CLCacheKeyDefine.h"
#import "UIImageView+WebCache.h"

@implementation NewsView
- (void)setupWithContent:(NSMutableDictionary *)content detail:(NSString *)detail {
    
    CGFloat offsetY = 7 + 49;
    if (content.date) {
        HHLabel *label = (HHLabel *)[self viewWithTag:dateTag];
        if (!label) {
            label = [[HHLabel alloc] init];
            label.tag = dateTag;
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 1;
            label.font = [UIFont CLFontSize:12];
            label.textColor = [UIColor CLGrayTextColor];
            label.backgroundColor = [UIColor clearColor];
        }
        
        label.text = content.date;
        if (content.clicks && [content.clicks intValue] > 0) {
            label.text = [label.text stringByAppendingFormat:@" 阅读:%@", content.clicks];
        }
        [label autoResize:CGSizeMake(306, 20)];
        label.offset = CGPointMake(160 - label.width/2, offsetY);
        offsetY += label.height + 7*(label.text.trim.length>0);
        [self addSubview:label];
    }
    
    if (content.title) {
        HHLabel *label = (HHLabel *)[self viewWithTag:titleTag];
        if (!label) {
            label = [[HHLabel alloc] init];
            label.tag = titleTag;
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
            label.font = [UIFont CLFontSize:15 bold:YES];
            label.textColor = [UIColor CLDarkGrayColor];
            label.backgroundColor = [UIColor clearColor];
        }        
        label.text = content.title;
        [label autoResize:CGSizeMake(306, 1000)];
        label.offset = CGPointMake(160 - label.width/2, offsetY);
        offsetY += label.height + 7*(label.text.trim.length>0);
        [self addSubview:label];
    }
    
    if (content.editor) {
        HHLabel *label = (HHLabel *)[self viewWithTag:editorTag];
        if (!label) {
            label = [[HHLabel alloc] init];
            label.tag = editorTag;
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 1;
            label.font = [UIFont CLFontSize:12];
            label.textColor = [UIColor CLGrayTextColor];
            label.backgroundColor = [UIColor clearColor];
        }
        label.text = [@"编辑:" stringByAppendingFormat:@"%@", content.editor];
        [label autoResize:CGSizeMake(306, 20)];
        label.offset = CGPointMake(160 - label.width/2, offsetY);
        offsetY += label.height + 7*(label.text.trim.length>0);
        [self addSubview:label];
    }
    
    if (content.writer) {
        HHLabel *label = (HHLabel *)[self viewWithTag:writerTag];
        if (!label) {
            label = [[HHLabel alloc] init];
            label.tag = writerTag;
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 1;
            label.font = [UIFont CLFontSize:12];
            label.textColor = [UIColor CLGrayTextColor];
            label.backgroundColor = [UIColor clearColor];
        }

        label.text = [@"来源:" stringByAppendingFormat:@"%@", content.writer];
        [label autoResize:CGSizeMake(306, 20)];
        label.offset = CGPointMake(160 - label.width/2, offsetY);
        offsetY += label.height + 7*(label.text.trim.length>0);
        [self addSubview:label];
    }
    
    if (detail) {
        UITextView *textView = (UITextView *)[self viewWithTag:detailTag];
        if (!textView) {
            textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
            textView.tag = detailTag;
            textView.textAlignment = NSTextAlignmentLeft;
            textView.font = [UIFont CLFontSize:15];
            textView.textColor = [UIColor CLDarkGrayColor];
            textView.backgroundColor = [UIColor clearColor];
            textView.clipsToBounds = NO;
        }
        HHLog(@"%lf",textView.font.pointSize);
        textView.text = detail;
        textView.scrollEnabled = NO;
        textView.editable = NO;
        textView.frame = CGRectMake(0, offsetY, 320, 0);
        [self addSubview:textView];
        textView.height = textView.contentSize.height;
        offsetY += textView.height + 7*(textView.text.trim.length>0);
    }
    
    if (content.images && [[NSUserDefaults standardUserDefaults] boolForKey:CACHE_KEY_ShowImage]) {
        for (int i = 0; i < content.images.count; i++) {
            NSString *string = [content.images objectAtIndex:i];
            __block UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, offsetY, 306, 306.0*0.66)];
            [imageView setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageFromMainBundleFile:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType type){
                    imageView.size = CGSizeMake(306, 306*image.size.height/image.size.width);
            }];

            
            offsetY += imageView.height + 7;
            [self addSubview:imageView];
            
        }
    }
    
    self.contentSize = CGSizeMake(320, offsetY);
}
@end
