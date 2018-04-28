

#import "EncryptHelper.h"

@implementation EncryptHelper


+ (NSString *)MD5String:(NSString *)origString {
    const char *original_str=[origString UTF8String];
    unsigned char result[32];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash=[NSMutableString string];
    for (int i=0; i<16; i++) {
        [hash appendFormat:@"%02x",result[i]];
    }
    return hash;
}


+ (NSString *)base64StringFromText:(NSString *)text {
    if (![text isEqualToString:@""]) {
        NSData *data=[text dataUsingEncoding:NSUTF8StringEncoding];
        NSString *resultStr=[data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        return resultStr;
    }else {
        return @"";
    }
    return @"";
}


















@end
