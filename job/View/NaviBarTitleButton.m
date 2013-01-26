// weetom@huohua.tv
#import "NaviBarTitleButton.h"
#import "HHLabel.h"
#import "CLUIDefine.h"
#import "UIView+HHKit.h"
#import "UIImage+HHKit.h"

@interface NaviBarTitleButton()
@end

@implementation NaviBarTitleButton
- (HHLabel *)mainTextLabel {
    if (!_mainTextLabel) {
        _mainTextLabel = [[HHLabel alloc] initWithFrame:CGRectMake(0, 10, 240, 18)];
        _mainTextLabel.textAlignment = NSTextAlignmentCenter;
        _mainTextLabel.backgroundColor = [UIColor clearColor];
        
        _mainTextLabel.textColor = [UIColor whiteColor];
        _mainTextLabel.shadowColor = [UIColor CLGrayTextColor];
        _mainTextLabel.shadowOffset = CGSizeMake(1, 1);
        _mainTextLabel.font = [UIFont CLFontSize:18 bold:YES];
    }
    return _mainTextLabel;
}

- (void)setTitleText:(NSString *)text {
    self.mainTextLabel.text = text;
    [self.mainTextLabel autoResize:CGSizeMake(320, 44)];
    [self addSubview:self.mainTextLabel];
    CGFloat width = self.mainTextLabel.width;
    CGFloat height = self.mainTextLabel.height;
    CGFloat offsetX = self.offsetX;
    CGFloat offsetY = self.offsetY;
    self.frame = CGRectMake(offsetX, offsetY, width, height + 20);
}
@end