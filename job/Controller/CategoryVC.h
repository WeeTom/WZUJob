//
//  JobCategoryVC.h
//  job
//
//  Created by Wee Tom on 13-1-4.
//  Copyright (c) 2013年 Wee Tom. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CategoryVC;

@protocol CategoryVCDelegate <NSObject>
- (void)categoryVC:(CategoryVC *)vc didSelectCategory:(NSMutableDictionary *)category;
@end

@interface CategoryVC : UITableViewController
@property (unsafe_unretained, nonatomic) id<CategoryVCDelegate> delegate;
@property (strong, nonatomic) NSArray *categories;
@end
