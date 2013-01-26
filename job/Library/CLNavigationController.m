// light@huohua.tv
#import "CLNavigationController.h"
#import "CLUIDefine.h"
#import "HHKit.h"

@implementation UINavigationController (CLOVER)

- (void)customBackgroundWithImage:(UIImage *)image
{
    self.navigationBar.frame = CGRectMake(0, self.navigationBar.frame.origin.y, self.navigationBar.frame.size.width, 44);

    if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) { // iOS 5
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    
    if ([self.navigationBar respondsToSelector:@selector(shadowImage)]) { // iOS 6
        self.navigationBar.shadowImage = [[UIImage alloc] init];
    }
}

- (void)setTitleText:(NSString *)title
{
    HHLabel *titleLabel = [[HHLabel alloc] initWithFrame:CGRectMake(0, 0, 240, 18)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.shadowColor = [UIColor CLGrayTextColor];
    titleLabel.shadowOffset = CGSizeMake(1, 1);
    titleLabel.font = [UIFont CLFontSize:18 bold:YES];

    titleLabel.text = title;
    
    [titleLabel autoResize:titleLabel.frame.size];
    titleLabel.offsetX = (self.visibleViewController.view.width - titleLabel.width) / 2;
    titleLabel.offsetY = 12;
    
    self.visibleViewController.navigationItem.titleView = titleLabel;
}

- (void)backBtnWithImage:(UIImage *)image highlightImage:(UIImage *)highlightImage
{
    [self leftBtnWithImage:image highlightImage:highlightImage target:self selector:@selector(popWithAnimated)];
}

- (void)leftBtnWithImage:(UIImage *)image highlightImage:(UIImage *)highlightImage target:(id)target selector:(SEL)selector
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    leftBtn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [leftBtn setImage:image forState:UIControlStateNormal];
    
    if (highlightImage) {
        [leftBtn setImage:highlightImage forState:UIControlStateHighlighted];
    }
    
    [leftBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    self.visibleViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}

- (void)rightBtnWithImage:(UIImage *)image highlightImage:(UIImage *)highlightImage target:(id)target selector:(SEL)selector
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightBtn.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [rightBtn setImage:image forState:UIControlStateNormal];
    
    if (highlightImage) {
        [rightBtn setImage:highlightImage forState:UIControlStateHighlighted];
    }
    
    [rightBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    self.visibleViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

- (void)leftBtnWithText:(NSString *)text target:(id)target selector:(SEL)selector
{
    UIButton *leftBtn = [self buttonWithTitle:text];
    
    [leftBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    self.visibleViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}

- (void)rightBtnWithText:(NSString *)text target:(id)target selector:(SEL)selector
{
    UIButton *rightBtn = [self buttonWithTitle:text];
    
    [rightBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    self.visibleViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

#pragma mark - NaviButton
- (UIButton *)buttonWithTitle:(NSString *)title
{
    return [self buttonWithTitle:title width:0 height:0];
}

- (UIButton *)buttonWithTitle:(NSString *)title width:(CGFloat)width
{
    return [self buttonWithTitle:title width:width height:0];
}

- (UIButton *)buttonWithTitle:(NSString *)title height:(CGFloat)height
{
    return [self buttonWithTitle:title width:0 height:height];
}

- (UIButton *)buttonWithTitle:(NSString *)title width:(CGFloat)width height:(CGFloat)height
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImage = [UIImage imageFromMainBundleFile:@"navi-btn-normal@2x.png"];
    UIImage *buttonImagePressed = [UIImage imageFromMainBundleFile:@"navi-btn-pressed@2x.png"];
    UIColor *titleColor = [UIColor CLGrayTextColor];
    
    buttonImage = [buttonImage stretchableImageWithLeftCapWidth:floorf(buttonImage.size.width / 2) + 5 topCapHeight:floorf(buttonImage.size.height / 2)];
    buttonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:floorf(buttonImagePressed.size.width / 2) + 5 topCapHeight:floorf(buttonImagePressed.size.height / 2)];
    
    button.titleLabel.font = [UIFont CLFontSize:15];
    
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImagePressed forState:UIControlStateHighlighted];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateHighlighted];
    
    CGRect buttonFrame;
    buttonFrame.origin.x = 0;
    buttonFrame.origin.y = 0;
    buttonFrame.size.width = width > 0 ? width : buttonImage.size.width + 10;
    buttonFrame.size.height = height > 0 ? height : buttonImage.size.height;
    
    button.frame = buttonFrame;
    
    return button;
}


@end