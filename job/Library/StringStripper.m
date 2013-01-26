// weetom@huohua.tv
#import "StringStripper.h"

@implementation StringStripper
+ (NSString *)strippedStringFrom:(NSString *)originalString {
    NSScanner *scanner = [NSScanner scannerWithString:originalString];
    NSCharacterSet *numbers = [NSCharacterSet
                               characterSetWithCharactersInString:@"0123456789"];
    NSMutableString *strippedString =[NSMutableString stringWithCapacity:[originalString length]];
    NSString *phoneNumber = originalString;
    
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
            [strippedString appendString:buffer];
        }
        else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    phoneNumber = [strippedString copy];
    return phoneNumber;
}

@end
