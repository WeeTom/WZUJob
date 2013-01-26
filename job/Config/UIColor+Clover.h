// light@huohua.tv
#import <UIKit/UIKit.h>

@interface UIColor (Clover)
+ (UIColor *)CLBackgroundColor;
+ (UIColor *)CLTimelineColor;

// Gray
+ (UIColor *)CLDarkGrayColor;
+ (UIColor *)CLLightGrayColor;
+ (UIColor *)CLGrayTextColor;
+ (UIColor *)CLHighlightedGrayColor;

// Red
+ (UIColor *)CLRedTextColor;

// Universal
+ (UIColor *)CLColorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;
@end