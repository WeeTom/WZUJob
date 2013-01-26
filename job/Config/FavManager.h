//
//  FavManager.h
//  job
//
//  Created by Wee Tom on 13-1-20.
//  Copyright (c) 2013年 Wee Tom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLCacheKeyDefine.h"
#import "CLCache.h"
#import "CLNotificationDefine.h"

@interface FavManager : NSObject
+ (NSArray *)favs;
+ (void)addFavItem:(id)obj;
+ (void)removeFavedItem:(id)obj;
+ (void)removeAllFavedItems;
@end
