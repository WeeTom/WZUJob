// weetom@huohua.tv
#import <UIKit/UIKit.h>

@class HHLabel;

@interface NaviBarTitleButton : UIButton
@property (strong, nonatomic) HHLabel *mainTextLabel;

- (void)setTitleText:(NSString *)text;
@end
