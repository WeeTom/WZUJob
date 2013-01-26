// light@huohua.tv
#import "CLCache.h"
#import "NSString+HHKit.h"

@implementation CLCache

#pragma mark - Integer
+ (NSInteger)integerForKey:(NSString *)key
{
    return [[self stringForKey:key] integerValue];
}

+ (void)setInteger:(NSInteger)integer forKey:(NSString *)key
{
    NSString *string = [NSString stringWithFormat:@"%d", integer];
    [self setString:string forKey:key];
}

+ (void)incrForKey:(NSString *)key
{
    [self incrNumber:1 forKey:key];
}

+ (void)minusForKey:(NSString *)key
{
    [self incrNumber:-1 forKey:key];
}

+ (void)incrNumber:(NSInteger)number forKey:(NSString *)key
{
    NSInteger integer = [self integerForKey:key];
    integer += number;
    [self setInteger:integer forKey:key];
}

#pragma mark - String
+ (NSString *)stringForKey:(NSString *)key
{
    return [[self class] stringForKey:key default:nil];
}

+ (NSString *)stringForKey:(NSString *)key default:(NSString *)defaultString
{
    NSString *string = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    if (!string || string.trim.length == 0) string = defaultString;
    return string;
}

+ (void)removeStringForKey:(NSString *)key
{
    [self removeObjectForKey:key];
}

+ (void)setString:(NSString *)aString forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:aString forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)objectForKey:(NSString *)key {
    return [self objectForKey:key default:nil];
}

+ (id)objectForKey:(NSString *)key default:(id)obj {
    id object = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!object) object = obj;
    return object;
}

+ (void)removeObjectForKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setObject:(id)obj forKey:(NSString *)key {
    if (!obj) return;
    
    NSLog(@"Key:%@ Cached!", key);
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setBool:(BOOL)yesOrNo forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setBool:yesOrNo forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)boolForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}
@end