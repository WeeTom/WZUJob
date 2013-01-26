// light@huohua.tv
#import "CLUIDefine.h"

@implementation UIColor (Clover)

+ (UIColor *)CLBackgroundColor
{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"background@2x.png"]];
}

+ (UIColor *)CLTimelineColor
{
    return [UIColor CLColorWithRed:147 green:147 blue:147 alpha:0.1];
}

#pragma mark - Gray
+ (UIColor *)CLDarkGrayColor
{
    return [UIColor CLColorWithRed:59 green:59 blue:59 alpha:1.0];
}

+ (UIColor *)CLLightGrayColor
{
    return [UIColor CLColorWithRed:174 green:174 blue:174 alpha:1.0];
}

+ (UIColor *)CLGrayTextColor
{
    return [UIColor CLColorWithRed:129 green:129 blue:129 alpha:1.0];
}

+ (UIColor *)CLHighlightedGrayColor {
    return [UIColor CLColorWithRed:233 green:233 blue:233 alpha:1.0];
}

#pragma mark - Red
+ (UIColor *)CLRedTextColor
{
    return [UIColor CLColorWithRed:223 green:70 blue:64 alpha:1.0];
}

#pragma mark - Universal
+ (UIColor *)CLColorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

@end