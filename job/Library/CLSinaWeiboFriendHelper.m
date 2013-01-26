// weetom@huohua.tv
#import "CLSinaWeiboFriendHelper.h"
#import "CLSinaWeibo.h"
#import "CLCacheKeyDefine.h"

@interface CLSinaWeiboFriendHelper () <SinaWeiboRequestDelegate>
@property (assign, nonatomic) BOOL isLoading;
@property (strong, nonatomic) SinaWeiboRequest *sinaWeiboRequest;
@property (strong, nonatomic) NSNumber *next_cursor; //used when loading more WeiboFriends

@end

@implementation CLSinaWeiboFriendHelper
- (id)init {
    self = [super init];
    if (self) {
        self.next_cursor = @0;
    }
    return self;
}

- (void)dealloc {
    _sinaWeiboRequest.delegate = nil;
    [_sinaWeiboRequest disconnect];
    _sinaWeiboRequest = nil;
}

- (void)loadWeiboFriendList {
    if (!self.isLoading) {
        NSArray *weiboUserInfos = [[NSUserDefaults standardUserDefaults] objectForKey:CACHE_KEY_WeiboFriends];
        if (weiboUserInfos) {
            [self.delegate weiboFriendHelper:self didFinishLoadingWithResult:weiboUserInfos];
            return;
        }
    }

    self.isLoading = YES;
    NSMutableDictionary *params = [@{
                                   @"uid": [CLSinaWeibo shared].userID,
                                   @"count": @"200",
                                   @"cursor": [self.next_cursor stringValue]
                                   } mutableCopy];
    
    self.sinaWeiboRequest = [[CLSinaWeibo shared] requestWithURL:@"friendships/friends.json" params:params httpMethod:@"GET" delegate:self];
}

- (void)reloadWeiboFriendList {
    self.next_cursor = @0;
    [[self class] clearFriendList];
    [self loadWeiboFriendList];
}

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    HHLog(@"CLSinaWeibo request:didFailWithError: %@", error);
    if ([self.delegate respondsToSelector:@selector(weiboFriendListLoadingDidFail)]) {
        [self.delegate weiboFriendHelper:self didFinishLoadingWithError:error];
    }
    return;
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    HHLog(@"CLSinaWeibo request:didFinishLoadingWithResult:");
    
    if (![result isKindOfClass:[NSDictionary class]]) {
        if ([self.delegate respondsToSelector:@selector(weiboFriendListLoadingDidFail)]) {
        [self.delegate weiboFriendHelper:self didFinishLoadingWithError:nil];
        }
        return;
    }
    
    NSArray *weiboUserInfos = [result objectForKey:@"users"];
    if (![weiboUserInfos isKindOfClass:[NSArray class]]) {
        if ([self.delegate respondsToSelector:@selector(weiboFriendListLoadingDidFail)]) {
            [self.delegate weiboFriendHelper:self didFinishLoadingWithError:nil];
        }
        return;
    }
    
    NSMutableArray *weiboUserFriendsList = [[[NSUserDefaults standardUserDefaults] objectForKey:CACHE_KEY_WeiboFriends] mutableCopy];
    if (!weiboUserFriendsList) weiboUserFriendsList = [NSMutableArray array];
    [weiboUserFriendsList addObjectsFromArray:weiboUserInfos];
    
    [[NSUserDefaults standardUserDefaults] setObject:weiboUserFriendsList forKey:CACHE_KEY_WeiboFriends];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.next_cursor = [result objectForKey:@"next_cursor"];
    if ([self.next_cursor intValue] == 0) {
        self.isLoading = NO;
        if ([self.delegate respondsToSelector:@selector(weiboFriendHelper:didFinishLoadingWithResult:)]) {
            [self.delegate weiboFriendHelper:self didFinishLoadingWithResult:weiboUserFriendsList];
        }
    } else {
        [self loadWeiboFriendList];
    }
}

+ (void)clearFriendList {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CACHE_KEY_WeiboFriends];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
