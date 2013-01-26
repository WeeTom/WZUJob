//
//  FavManager.m
//  job
//
//  Created by Wee Tom on 13-1-20.
//  Copyright (c) 2013年 Wee Tom. All rights reserved.
//

#import "FavManager.h"

@implementation FavManager
+ (NSArray *)favs {
    NSArray *array = [CLCache objectForKey:CACHE_KEY_Favourites];
    if (!array) {
        return [NSArray array];
    }
    return array;
}

+ (void)addFavItem:(id)obj {
    NSMutableArray *mArray = [NSMutableArray array];
    if (obj && ![[self favs] containsObject:obj]) {
        [mArray addObject:obj];
    }
    [mArray addObjectsFromArray:[self favs]];
    [CLCache setObject:mArray forKey:CACHE_KEY_Favourites];
    [[NSNotificationCenter defaultCenter] postNotificationName:CLNotificationNewFavAdded object:nil userInfo:@{@"content":obj}];
    NSLog(@"New Fav Added:%@, total:%d", obj, mArray.count);
}

+ (void)removeFavedItem:(id)obj {
    NSMutableArray *mArray = [[self favs] mutableCopy];
    [mArray removeObject:obj];
    [CLCache setObject:mArray forKey:CACHE_KEY_Favourites];
    [[NSNotificationCenter defaultCenter] postNotificationName:CLNotificationFavedRemoved object:nil userInfo:@{@"content":obj}];
}

+ (void)removeAllFavedItems {
    NSMutableArray *mArray = [[self favs] mutableCopy];
    [mArray removeAllObjects];
    [CLCache setObject:mArray forKey:CACHE_KEY_Favourites];
    [[NSNotificationCenter defaultCenter] postNotificationName:CLNotificationAllFavedRemoved object:nil userInfo:nil];
}
@end
