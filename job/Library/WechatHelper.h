//weetom@huohua.tv

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "SDWebImageManager.h"
#import "UIImage+Resizing.h"
#import "HHKit.h"

@interface WechatHelper : NSObject

+ (void)sendWXURLMessageTitle:(NSString *)titile
                                 description:(NSString *)description
                                  imageURL:(NSString *)image
                                           URL:(NSString *)url;

+ (void)sendWXVideoMessageTitle:(NSString *)titile
                    description:(NSString *)description
                       imageURL:(NSString *)image
                       videoURL:(NSString *)url
                         scene :(BOOL)allFriens;

+ (BOOL)wechatAvailable;
@end
