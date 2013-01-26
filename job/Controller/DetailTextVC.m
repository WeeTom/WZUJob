//
//  DetailTextVC.m
//  job
//
//  Created by Wee Tom on 13-1-5.
//  Copyright (c) 2013年 Wee Tom. All rights reserved.
//

#import "DetailTextVC.h"

@interface DetailTextVC ()
@property (strong, nonatomic) UITextView *textView;
@end

@implementation DetailTextVC
- (void)dealloc {
    _text  = nil;
    _textView = nil;
}

- (void)viewDidLoad {
    self.textView                 = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320 - 66 - 8, 460 - 66 - 50)];
    self.textView.font            = [UIFont fontWithName:@"Helvetica" size:15];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.scrollEnabled   = YES;
    self.textView.textColor       = [UIColor blackColor];
    self.textView.text            = self.text;
    self.textView.editable        = NO;
    [self.view addSubview:self.textView];
}

@end
