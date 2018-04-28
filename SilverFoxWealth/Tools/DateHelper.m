

#import "DateHelper.h"

@implementation DateHelper

+ (NSInteger)secondAfterNumWithAnotherDate:(NSDate *)anotherDate selfDate:(NSDate *)selfDate
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitSecond;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:selfDate toDate:anotherDate options:0];
    return [comps second];
}


//转换一个时间戳为 yyyy-MM-dd 格式
+ (NSString *)conversionTimeStampToHorizontalLineWith:(NSString *)timeStamp {
    
    NSDateFormatter *dateFor=[[NSDateFormatter alloc] init];
    [dateFor setDateStyle:NSDateFormatterMediumStyle];
    [dateFor setTimeStyle:NSDateFormatterNoStyle];
    [dateFor setDateFormat:@"yyyy-MM-dd"];
    NSDate *rigistTime=[NSDate dateWithTimeIntervalSince1970:[timeStamp longLongValue]/1000];
    NSString *dateStr=[dateFor stringFromDate:rigistTime];
    return dateStr;
}
+ (NSString *)conversionTimeStampToHorizontalAloneDayWith:(NSString *)timeStamp
{
    NSString *signTime = [timeStamp substringToIndex:10];
    NSString *dateStr = [signTime stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return dateStr;
}
//把一个时间戳转换为 年月日时分秒 比较紧凑的 yyyyMMddHHmmss
+ (NSString *)conversionTimeStampToCompactWith:(NSString *)timeStamp {
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *rigistTime=[NSDate dateWithTimeIntervalSince1970:[timeStamp longLongValue]/1000];
    NSString *dateStr=[formatter stringFromDate:rigistTime];
    
    return dateStr;
    
}


//把一个时间戳转换为 年月日时分秒 斜线的 yyyy-MM-dd HH:mm:ss
+ (NSString *)conversionTimeStampToDiagonalwith:(NSString *)timeStamp {
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *rigistTime=[NSDate dateWithTimeIntervalSince1970:[timeStamp longLongValue]/1000];
    NSString *dateStr=[formatter stringFromDate:rigistTime];
    return dateStr;
}

//把一个时间戳转换为 月日 时分 斜线的 MM/dd HH:mm
+ (NSString *)conversionTimeStampToShortStyleWith:(NSString *)timeStamp {
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *rigistTime=[NSDate dateWithTimeIntervalSince1970:[timeStamp longLongValue]/1000];
    NSString *dateStr=[formatter stringFromDate:rigistTime];
    return dateStr;
    
}

//把一个时间转换为 yyyyMMdd 格式的字符串
+ (NSString *)conversionTimeToShortStyleWith:(NSDate *)time {
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *dateStr=[formatter stringFromDate:time];
    return dateStr;
}

//把系统当前时间转换为 yyyy-MM-dd 格式的字符串
+ (NSString *)conversionCurrentTime {
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr=[formatter stringFromDate:[NSDate date]];
    return dateStr;
}

+ (NSString *)conversionLinkedTimewith:(NSString *)timeStr {
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *date=[formatter dateFromString:timeStr];
    
    NSDateFormatter *formatter1=[[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr=[formatter1 stringFromDate:date];
    return dateStr;
}

//把系统当前时间转换为 yyyyMMdd 格式的字符串
+ (NSString *)conversionCurrentTimeForLineFormat {
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *dateStr=[formatter stringFromDate:[NSDate date]];
    return dateStr;
}


@end
