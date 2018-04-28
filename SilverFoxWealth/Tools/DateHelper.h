

#import <Foundation/Foundation.h>

@interface DateHelper : NSObject


/**
 *转换一个时间戳为 yyyy-MM-dd 格式
 */
+ (NSString *)conversionTimeStampToHorizontalLineWith:(NSString *)timeStamp;
/**
 *转换一个时间戳为 yyyy-MM-d 格式
 */
+ (NSString *)conversionTimeStampToHorizontalAloneDayWith:(NSString *)timeStamp;

/**
 *把一个时间戳转换为 一个 yyyyMMddHHmmss 格式的字符串
 */
+ (NSString *)conversionTimeStampToCompactWith:(NSString *)timeStamp;

/**
 *把一个时间戳转换为 年月日时分秒 斜线的 yyyy-MM-dd HH:mm:ss
 */
+ (NSString *)conversionTimeStampToDiagonalwith:(NSString *)timeStamp;


/**
 *把一个时间戳转换为 月日 时分 斜线的 MM/dd HH:mm
 */
+ (NSString *)conversionTimeStampToShortStyleWith:(NSString *)timeStamp;


/**
 *把一个时间转换为 yyyyMMdd 格式的字符串
 */
+ (NSString *)conversionTimeToShortStyleWith:(NSDate *)time;

/**
 *把当前时间转换为 yyyy-MM-dd 格式的字符串
 */
+ (NSString *)conversionCurrentTime;

/**
 *把系统当前时间转换为 yyyyMMdd 格式的字符串
 */
+ (NSString *)conversionCurrentTimeForLineFormat;

/**
 *把一个时间比如20150616102523 转换为  yyyy-MM-dd HH:mm:ss
 */
+ (NSString *)conversionLinkedTimewith:(NSString *)timeStr;



+ (NSInteger)secondAfterNumWithAnotherDate:(NSDate *)anotherDate selfDate:(NSDate *)selfDate;

@end
