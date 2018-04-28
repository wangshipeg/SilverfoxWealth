

#import "UIColor+CustomColors.h"

@implementation UIColor (CustomColors)

//icon蓝
+ (UIColor *)iconBlueColor {
   return  [self colorWithRed:76 green:167 blue:238];
}
//黄
+ (UIColor *)yellowSilverfoxColor {
    return [self colorWithRed:248 green:202 blue:98];
}


//浙商红
+ (UIColor *)zheJiangBusinessRedColor {
    return [self colorWithRed:238 green:91 blue:76];
}

//字体黑
+ (UIColor *)characterBlackColor {
    return [self colorWithRed:77 green:77 blue:77];
}

//背景灰色 238  238  238
+ (UIColor *)backgroundGrayColor {
    return [self colorWithRed:248 green:248 blue:248];
}

//不可点击
+ (UIColor *)typefaceGrayColor {
    return [self colorWithRed:203 green:203 blue:203];
}

//字体灰
+ (UIColor *)depictBorderGrayColor {
    return [self colorWithRed:156 green:156 blue:156];
}

+ (UIColor *)cyanGronudColor
{
    return [self colorWithRed:246 green:249 blue:251];
}

+ (UIColor *)colorWithRed:(NSUInteger)red
                    green:(NSUInteger)green
                     blue:(NSUInteger)blue
{
    return [UIColor colorWithRed:(float)(red/255.f)
                           green:(float)(green/255.f)
                            blue:(float)(blue/255.f)
                           alpha:1.f];
}

//+ (UIColor *)colorWithRGB:(CGColorRef)color
//{
//   return [UIColor colorWithCGColor:color];
//}



@end
