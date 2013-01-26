// weetom@huohua.tv
#import "UIFont+Clover.h"

@implementation UIFont (Clover)
+ (UIFont *)CLFontSize:(CGFloat)fontSize
{
    return [UIFont CLFontSize:fontSize bold:NO];
}

+ (UIFont *)CLFontSize:(CGFloat)fontSize bold:(BOOL)bold
{
    switch (bold) {
        case YES:
            return  [UIFont fontWithName:@"Helvetica-Bold" size:fontSize];
            break;
        default:
            return  [UIFont fontWithName:@"Helvetica" size:fontSize];
            break;
    }
}

@end