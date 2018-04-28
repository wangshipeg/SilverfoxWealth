
#import "CalculateProductInfo.h"
#import "SilverWealthProductCell.h"
#import "SCMeasureDump.h"

@implementation CalculateProductInfo
//计算产品收益  产品model  购买金额
+ (NSString *)calculateProdcutYearIncome:(SilverWealthProductDetailModel *)productModel purchaseNum:(NSUInteger)purchaseNum {
    NSDecimalNumber *number=[[NSDecimalNumber alloc] initWithString:productModel.yearIncome];
    if ([productModel.increaseInterest length] != 0) {
        NSDecimalNumber *interestValue=[NSDecimalNumber decimalNumberWithString:productModel.increaseInterest];
        //如果加息大于0
        if ([interestValue doubleValue] > 0) {
            number = [number decimalNumberByAdding:interestValue];
        }
    }
    //变为百分比
    number = [number decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
    NSInteger financePeriod =[productModel.financePeriod integerValue];
    //购买金额*理财天数*年化收益/365
    double productResult = purchaseNum * financePeriod * [number doubleValue]/365;
    NSString *resultStr = [NSString stringWithFormat:@"%.2f",productResult];
    return resultStr;
}

//计算产品是否开售
+ (BOOL)calculateProdcutBeginSaleWith:(SilverWealthProductDetailModel *)productModel{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [[NSDate alloc] init];
    NSDate *dateTwo = [[NSDate alloc] init];
    date =[formatter dateFromString:productModel.shippedTime];
    dateTwo = [formatter dateFromString:[SCMeasureDump shareSCMeasureDump].nowTime];
    NSComparisonResult result = [dateTwo compare:date];
    if (result < 0) {
        return YES;
    }
    return NO;
}

//计算宝宝类产品是否开售
+ (BOOL)calculateProdcutBeginSaleWithBaoBao:(SilverWealthProductDetailModel *)productModel
{
    //将时间戳转化为字符串类型
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *rigistTime=[NSDate dateWithTimeIntervalSince1970:[productModel.shippedTime longLongValue]/1000];
    NSString *dateStr=[formatter stringFromDate:rigistTime];
    NSDate *date = [[NSDate alloc] init];
    NSDate *dateTwo = [[NSDate alloc] init];
    date =[formatter dateFromString:dateStr];
    
    NSString *dataStr = [SCMeasureDump shareSCMeasureDump].nowTime;
    NSDate *rigistTime2=[NSDate dateWithTimeIntervalSince1970:[dataStr longLongValue]/1000];
    NSString *dateStr2=[formatter stringFromDate:rigistTime2];
    dateTwo = [formatter dateFromString:dateStr2];
    
    //dateTwo = [formatter dateFromString:productModel.currentTime];
    NSComparisonResult result = [dateTwo compare:date];
    if (result < 0) {
        return YES;
    }
    return NO;
}


+ (BOOL)calculateBaoBaoProdcutDetailWhetherSelloutWith:(AssetFormationModel *)productModel
{
    NSDecimalNumber *total=[NSDecimalNumber decimalNumberWithString:productModel.totalAmount];
    NSDecimalNumber *actual=[NSDecimalNumber decimalNumberWithString:productModel.actualAmount];
    
    if ([total doubleValue] <= [actual doubleValue] && [total doubleValue] != 0) {
        return YES;
    }
    return NO;
}

//计算产品是否售罄
+ (BOOL)calculateProdcutWhetherSelloutWith:(SilverWealthProductModel *)productModel {
    NSDecimalNumber *total=[NSDecimalNumber decimalNumberWithString:productModel.totalAmount];
    NSDecimalNumber *actual=[NSDecimalNumber decimalNumberWithString:productModel.actualAmount];
    if ([total doubleValue] <= [actual doubleValue] && [total doubleValue] != 0) {
        return YES;
    }
    return NO;
}

+ (BOOL)calculateProdcutDetailWhetherSelloutWith:(SilverWealthProductDetailModel *)productModel
{
    NSDecimalNumber *total=[NSDecimalNumber decimalNumberWithString:productModel.totalAmount];
    NSDecimalNumber *actual=[NSDecimalNumber decimalNumberWithString:productModel.actualAmount];
    if ([total doubleValue] <= [actual doubleValue] && [total doubleValue] != 0) {
        return YES;
    }
    return NO;
}

/**
 *计算精品推荐页产品是否售罄
 */
+ (BOOL)calculateRefinedProdcutWhetherSelloutWith:(RecommendContentModel *)productModel{
    NSDecimalNumber *total=[NSDecimalNumber decimalNumberWithString:productModel.totalAmount];
    NSDecimalNumber *actual=[NSDecimalNumber decimalNumberWithString:productModel.actualAmount];
    
    if ([total doubleValue] <= [actual doubleValue] && [total doubleValue] != 0) {
        return YES;
    }
    return NO;
}

//计算产品 剩余可购买金额
+ (NSDecimalNumber *)calculateProdcutSurplusCanPurchaseNumWith:(SilverWealthProductDetailModel *)productModel {
    NSDecimalNumber *total=[NSDecimalNumber decimalNumberWithString:productModel.totalAmount];
    NSDecimalNumber *actual=[NSDecimalNumber decimalNumberWithString:productModel.actualAmount];
    NSDecimalNumber *result = [total decimalNumberBySubtracting:actual];
    return result;
}

//计算已购产品里 各种金额
+ (NSString *)calculateAlreadyProdcutNumWith:(NSString *)valueStr isDouble:(BOOL)isDouble {
    if (isDouble) {
        NSString *resultStr=[NSString stringWithFormat:@"%.2lf",round([valueStr doubleValue]*100)/100];
        return resultStr;
    }
    NSString *resultStr=[NSString stringWithFormat:@"%ld",(long)[valueStr integerValue]];
    return resultStr;
}

//对price保留position位小数 进位
+ (NSString *)stringByNotRounding:(double)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundUp scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%.3f元",[roundedOunces doubleValue]];
}
//进位, 保留两位小数
+ (NSString *)alculateStringByNotRounding:(double)price afterPoint:(int)position
{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundUp scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%.2f",[roundedOunces doubleValue]];;
}

//计算产品到期时间 beginTime 为时间字符串 spaceDayTime单位为天
+ (NSString *)calculateExpireTimeWith:(NSString *)beginTime spaceDayTime:(NSString *)spaceDayTime {
    NSDateFormatter *dateFor=[[NSDateFormatter alloc] init];
    [dateFor setDateStyle:NSDateFormatterMediumStyle];
    [dateFor setTimeStyle:NSDateFormatterNoStyle];
    [dateFor setDateFormat:@"yyyy-MM-dd"];
    NSDate *sendDate=[dateFor dateFromString:beginTime];
    NSTimeInterval interval=([spaceDayTime doubleValue]+1)*24*60*60;
    NSDate *toDate=[sendDate  dateByAddingTimeInterval:interval];
    NSString *incomeTimeStr=toDate.description;
    incomeTimeStr=[incomeTimeStr substringToIndex:10];
    return incomeTimeStr;
}

/**
 *时间加上天数
 */
+ (NSString *)calculateTimeWith:(NSString *)beginTime spaceDayTime:(NSString *)spaceDayTime
{
    NSDateFormatter *dateFor=[[NSDateFormatter alloc] init];
    [dateFor setDateFormat:@"yyyy-MM-dd"];
    NSDate *sendDate=[dateFor dateFromString:beginTime];
    NSTimeInterval interval=([spaceDayTime doubleValue]+1)*24*60*60;
    NSDate *toDate=[sendDate  dateByAddingTimeInterval:interval];
    NSString *incomeTimeStr=toDate.description;
    incomeTimeStr = [incomeTimeStr substringToIndex:10];
//    NSString *resultStr = [incomeTimeStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return incomeTimeStr;
}

//计算产品募集进度 
+ (NSDecimalNumber *)calculateProductCollectProgressWith:(SilverWealthProductDetailModel *)productModel {
    
    NSDecimalNumber *totalAmountValue=[NSDecimalNumber decimalNumberWithString:productModel.totalAmount];
    NSDecimalNumber *actualAmountValue=[NSDecimalNumber decimalNumberWithString:productModel.actualAmount];
    
    //未买 直接返回0
    if ([actualAmountValue doubleValue] == 0) {
        return actualAmountValue;
    }
    
    NSDecimalNumber *dividingValue = [actualAmountValue decimalNumberByDividingBy:totalAmountValue]  ;

    //百分比小于0.01 直接使用0.01
    if ([dividingValue doubleValue] <= 0.01 ) {
        return [[NSDecimalNumber alloc] initWithDouble:0.01];
    }
    //正常返回
    return dividingValue;
}

+ (NSDecimalNumber *)calculateZeroChangeProgressWith:(ZeroIndianaModel *)zeroModel
{
    NSDecimalNumber *totalAmountValue=[NSDecimalNumber decimalNumberWithString:zeroModel.stock];
    NSDecimalNumber *actualAmountValue=[NSDecimalNumber decimalNumberWithString:zeroModel.joinNum];
    
    //未买 直接返回0
    if ([actualAmountValue doubleValue] == 0) {
        return actualAmountValue;
    }
    
    NSDecimalNumber *dividingValue = [actualAmountValue decimalNumberByDividingBy:totalAmountValue]  ;
    
    //百分比小于0.01 直接使用0.01
    if ([dividingValue doubleValue] <= 0.01 ) {
        return [[NSDecimalNumber alloc] initWithDouble:0.01];
    }
    //正常返回
    return dividingValue;
}
    


@end
