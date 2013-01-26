// light@huohua.tv
#import "CLSinaWeibo.h"
#import "CLCache.h"
#import "CLCacheKeyDefine.h"
#import "SVProgressHUD.h"
#import "CLNotificationDefine.h"
#import "SinaWeiboConstants.h"

#define weiboAppKey             @"2040737074"
#define weiboAppSecret          @"6b60dcb3fa1f0546b3f16ae074eb6b40"
#define weiboAppRedirectURI     @"http://job.wzu.edu.cn"
#define weiboSSOCallbackScheme  @"sinasso.wzujob://"


@interface CLSinaWeibo() <SinaWeiboDelegate, SinaWeiboRequestDelegate>
@property (strong, nonatomic) HHBasicBlock afterLoginBlock, afterLogoutBlock, completionBlock;
@end

@implementation CLSinaWeibo

+ (CLSinaWeibo *)shared
{
    static CLSinaWeibo *sinaWeibo;
    @synchronized(self) {
        if (!sinaWeibo) {            
            sinaWeibo = [[self alloc] initWithAppKey:weiboAppKey appSecret:weiboAppSecret appRedirectURI:weiboAppRedirectURI ssoCallbackScheme:weiboSSOCallbackScheme andDelegate:nil];
            NSDictionary *sinaWeiboInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"SinaWeiboAuthData"];
            if ([sinaWeiboInfo objectForKey:@"AccessTokenKey"] && [sinaWeiboInfo objectForKey:@"ExpirationDateKey"] && [sinaWeiboInfo objectForKey:@"UserIDKey"])
            {
                sinaWeibo.accessToken = [sinaWeiboInfo objectForKey:@"AccessTokenKey"];
                sinaWeibo.expirationDate = [sinaWeiboInfo objectForKey:@"ExpirationDateKey"];
                sinaWeibo.userID = [sinaWeiboInfo objectForKey:@"UserIDKey"];
            }
        }
    }
    return sinaWeibo;
}

+ (BOOL)isSSO
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:kSinaWeiboAppAuthURL_iPad]]) return YES;
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:kSinaWeiboAppAuthURL_iPhone]]) return YES;
    return NO;
}

- (void)logInAndPerform:(HHBasicBlock)block
{
    if (![self isLoggedIn] || [self isAuthorizeExpired]) {
        [CLCache removeStringForKey:@"userId"];
        [CLCache removeStringForKey:@"sinaWeiboNickname"];
        [CLCache removeStringForKey:@"sinaWeiboAvatar"];
        
        self.afterLoginBlock = [block copy];
        self.delegate = self;
        [self performSelector:@selector(logIn) withObject:nil afterDelay:0.5f];
    } else {
        block();
    }
}

- (void)logOutAndPerform:(HHBasicBlock)block
{
    self.afterLogoutBlock = [block copy];
    self.delegate = self;
    
    [CLCache removeStringForKey:@"userId"];
    [CLCache removeStringForKey:@"sinaWeiboNickname"];
    [CLCache removeStringForKey:@"sinaWeiboAvatar"];
    
    [self logOut];
}

- (void)sendText:(NSString *)text completion:(HHBasicBlock)completionBlock
{
    self.completionBlock = [completionBlock copy];
    
    NSMutableDictionary *params = [@{
        @"status": text
    } mutableCopy];
    
    [self requestWithURL:@"statuses/update.json" params:params httpMethod:@"POST" delegate:self];
}

- (void)sendText:(NSString *)text image:(UIImage *)image completion:(HHBasicBlock)completionBlock
{
    if (!image) {
        [self sendText:text completion:completionBlock];
        return ;
    }
    
    self.completionBlock = [completionBlock copy];
    
    NSMutableDictionary *params = [@{
        @"status": text,
        @"pic": image
    } mutableCopy];
    
    
    [self requestWithURL:@"statuses/upload.json" params:params httpMethod:@"POST" delegate:self];
}

#pragma mark - SinaWeiboDelegate
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate, sinaweibo.refreshToken);
    [self storeAuthData];
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:self.userID forKey:@"uid"];
    [self requestWithURL:@"users/show.json" params:params httpMethod:@"GET" delegate:self];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogOut");
    [self removeAuthData];
    self.afterLogoutBlock();
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboLogInDidCancel");
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"sinaweibo logInDidFailWithError %@", error);
    [SVProgressHUD showErrorWithStatus:@"登录失败"];
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
    [SVProgressHUD showErrorWithStatus:@"请重新登录新浪微博"];
    [self removeAuthData];
}

- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.accessToken = nil;
    self.expirationDate = nil;
    self.userID = nil;
}

- (void)storeAuthData
{
    NSDictionary *authData = @{
        @"AccessTokenKey": self.accessToken,
        @"ExpirationDateKey": self.expirationDate,
        @"UserIDKey": self.userID,
        //@"refresh_token": self.refreshToken
    };
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - SinaWeiboRequest Delegate
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    HHLog(@"CLSinaWeibo request:didFailWithError: %@", error);
    if (self.completionBlock) self.completionBlock();
}

- (void)request:(SinaWeiboRequest *)request_ didFinishLoadingWithResult:(id)result
{
    HHLog(@"CLSinaWeibo request:didFinishLoadingWithResult: %@", result);
    
    if ([request_.url hasSuffix:@"oauth2/access_token"]) {
        // 对不支持 SSO 设备的支持
        HHLog(@"SinaWeibo SSO Not Supported");
        self.userID = [result valueForKey:@"uid"];
        self.accessToken = [result valueForKey:@"access_token"];
        self.expirationDate = [NSDate dateWithTimeIntervalSinceNow:[[result valueForKey:@"expires_in"] intValue]];
        [self sinaweiboDidLogIn:self];
    } else if ([request_.url hasSuffix:@"users/show.json"]) {
        NSDictionary *dic = (NSDictionary *)result;
        
        NSMutableDictionary *userWeiboData = [NSMutableDictionary dictionary];
        NSArray *keys = [dic allKeys];
        for (NSString *key in keys) {
            NSString *value = [dic objectForKey:key];
            if ([value isKindOfClass:[NSString class]]) [userWeiboData setObject:value forKey:key];
        }
        [[NSUserDefaults standardUserDefaults] setObject:userWeiboData forKey:CACHE_KEY_UserWeiboData];
        [[NSUserDefaults standardUserDefaults] synchronize];

        NSString *nick = [dic objectForKey:@"screen_name"];
        NSString *avatar = [dic objectForKey:@"avatar_large"];
        if (nick) [CLCache setString:nick forKey:@"sinaWeiboNickname"];
        if (avatar) [CLCache setString:avatar forKey:@"sinaWeiboAvatar"];
        if (self.afterLoginBlock) {
            self.afterLoginBlock();
        } else {
            [SVProgressHUD dismiss];
        }
        
    } else if ([request_.url hasSuffix:@"friendships/friends/ids.json"]) {
        NSDictionary *dic = (NSDictionary *)result;        
        NSArray *weiboIds = [dic objectForKey:@"ids"];
        if (![weiboIds isKindOfClass:[NSArray class]]) return;
        
        HHLog(@"Total weiboIds: %d", [weiboIds count]);

        if (self.completionBlock) self.completionBlock();
    } else {
        if (self.completionBlock) self.completionBlock();
    }
}

@end