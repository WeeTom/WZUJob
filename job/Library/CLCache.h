// light@huohua.tv
#import <Foundation/Foundation.h>

@interface CLCache : NSObject
+ (NSInteger)integerForKey:(NSString *)key;
+ (void)setInteger:(NSInteger)integer forKey:(NSString *)key;
+ (void)incrForKey:(NSString *)key;
+ (void)minusForKey:(NSString *)key;
+ (void)incrNumber:(NSInteger)number forKey:(NSString *)key;

+ (NSString *)stringForKey:(NSString *)key;
+ (NSString *)stringForKey:(NSString *)key default:(NSString *)defaultString;
+ (void)removeStringForKey:(NSString *)key;

+ (void)setString:(NSString *)aString forKey:(NSString *)key;

+ (id)objectForKey:(NSString *)key;
+ (id)objectForKey:(NSString *)key default:(id)obj;
+ (void)removeObjectForKey:(NSString *)key;

+ (void)setObject:(id)obj forKey:(NSString *)key;

+ (void)setBool:(BOOL)yesOrNo forKey:(NSString *)key;
+ (BOOL)boolForKey:(NSString *)key;
@end