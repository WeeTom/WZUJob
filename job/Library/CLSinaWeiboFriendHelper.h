// weetom@huohua.tv
#import <Foundation/Foundation.h>
@class CLSinaWeiboFriendHelper;

@protocol CLSinaWeiboFriendHelperDelegate <NSObject>
- (void)weiboFriendHelper:(CLSinaWeiboFriendHelper *)helper didFinishLoadingWithError:(NSError *)error;
- (void)weiboFriendHelper:(CLSinaWeiboFriendHelper *)helper didFinishLoadingWithResult:(NSArray *)results;
@end

@interface CLSinaWeiboFriendHelper : NSObject
@property (unsafe_unretained, nonatomic) id<CLSinaWeiboFriendHelperDelegate> delegate;
- (void)loadWeiboFriendList;
- (void)reloadWeiboFriendList;
+ (void)clearFriendList;
@end
