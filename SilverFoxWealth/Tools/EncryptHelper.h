

//加密助手

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface EncryptHelper : NSObject

/**
 *MD5加密
 */
+ (NSString *)MD5String:(NSString *)origString ;


/**
 *64位加密
 */
+ (NSString *)base64StringFromText:(NSString *)text ;


@end
