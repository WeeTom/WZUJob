// light@huohua.tv
#import <UIKit/UIKit.h>

@interface UINavigationController (CLOVER)
- (void)customBackgroundWithImage:(UIImage *)image;
- (void)setTitleText:(NSString *)title;
- (void)backBtnWithImage:(UIImage *)image highlightImage:(UIImage *)highlightImage;
- (void)leftBtnWithImage:(UIImage *)image highlightImage:(UIImage *)highlightImage target:(id)target selector:(SEL)selector;
- (void)rightBtnWithImage:(UIImage *)image highlightImage:(UIImage *)highlightImage target:(id)target selector:(SEL)selector;
- (void)leftBtnWithText:(NSString *)text target:(id)target selector:(SEL)selector;
- (void)rightBtnWithText:(NSString *)text target:(id)target selector:(SEL)selector;
@end