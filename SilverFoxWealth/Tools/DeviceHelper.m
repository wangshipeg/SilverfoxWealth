

#import "DeviceHelper.h"
#import <UIKit/UIKit.h>
#import <sys/utsname.h>



@implementation DeviceHelper

//设备是iphone或者其它 的几
+(NSString *)deviceType{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString=[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPHONE4 CDMA";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone6";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone6S Plus";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6S";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])   return @"iPhone8";
    if ([deviceString isEqualToString:@"iPhone10,4"])   return @"iPhone8";
    if ([deviceString isEqualToString:@"iPhone10,2"])   return @"iPhone8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,5"])   return @"iPhone8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"])   return @"iPhoneX";
    if ([deviceString isEqualToString:@"iPhone10,6"])   return @"iPhoneX";
    
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5";
    
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2 ";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad mini 1G";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad mini 1G";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad mini 1G";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad mini 2G";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad Mini 2G";
    if ([deviceString isEqualToString:@"iPad4,6"])      return@"iPad Mini 2G";
    if ([deviceString isEqualToString:@"iPad4,7"])      return@"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])      return@"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])      return@"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"])      return@"iPad Mini 4";
    if ([deviceString isEqualToString:@"iPad5,2"])      return@"iPad Mini 4";
    if ([deviceString isEqualToString:@"iPad5,3"])      return@"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return@"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,3"])      return@"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,4"])      return@"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,7"])      return@"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,8"])      return@"iPad Pro 12.9";
    
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    DLog(@"NOTE: Unknown device type: %@", deviceString);
    
    return deviceString;
}




























@end
