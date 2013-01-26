// weetom@huohua.tv
#import "WechatHelper.h"
#import "HHAlertView.h"

@implementation WechatHelper

+ (void)sendWXURLMessageTitle   :(NSString *)titile
        description             :(NSString *)description
        imageURL                :(NSString *)image
        URL                     :(NSString *)url
{
    if (![WechatHelper wechatAvailable]) {
        return;
    }
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = titile;
    message.description = description;

    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:image] options:SDWebImageCacheMemoryOnly progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType type, BOOL finished){
        if (image) {
            [message setThumbImage:image];
        } else {
            [message setThumbImage:[UIImage imageFromMainBundleFile:@"Icon.png"]];
        }
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = url;
        message.mediaObject = ext;
        
        __autoreleasing SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        
        while (![WXApi sendReq:req]) { // 图片最多只能 32k
            UIImage *thumbImage = [UIImage imageWithData:req.message.thumbData];
            thumbImage = [thumbImage scaleByFactor:0.9f];
            [message setThumbImage:thumbImage];
            req.message = message;
        }
    }];
}

+ (void)sendWXVideoMessageTitle:(NSString *)titile
                                  description:(NSString *)description
                                   imageURL:(NSString *)image
                                    videoURL:(NSString *)url
                                        scene :(BOOL)allFriends
{
    if (![WechatHelper wechatAvailable]) {
        return;
    }
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = titile;
    message.description = description;

    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:image] options:SDWebImageCacheMemoryOnly progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType type, BOOL finished){
        if (image) {
            [message setThumbImage:image];
        } else {
            [message setThumbImage:[UIImage imageFromMainBundleFile:@"Icon.png"]];
        }
        WXVideoObject *vdo = [WXVideoObject object];
        vdo.videoUrl = url;
        message.mediaObject = vdo;
        
        __autoreleasing SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = allFriends?WXSceneTimeline:WXSceneSession; //发送到朋友圈
        
        while (![WXApi sendReq:req]) { // 图片最多只能 32k
            UIImage *thumbImage = [UIImage imageWithData:req.message.thumbData];
            thumbImage = [thumbImage scaleByFactor:0.9f];
            [message setThumbImage:thumbImage];
            req.message = message;
        }
    }];
}

+ (BOOL)wechatAvailable {
    if (![WXApi isWXAppInstalled] || ![WXApi isWXAppSupportApi]) {
        HHAlertView *alertView = [[HHAlertView alloc] initWithTitle:@"火花" message:@"您没有安装微信，或没有安装最新版本的微信 :(" cancelButtonTitle:@"确认"];
        [alertView show];
        return NO;
    }
    return YES;
}
@end