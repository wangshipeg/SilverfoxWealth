
#import <Foundation/Foundation.h>
#import "SilverWealthProductDetailModel.h"
#import "SilverWealthProductCell.h"
#import "AssetFormationModel.h"
#import "RecommendContentModel.h"
#import "ZeroIndianaModel.h"

@interface CalculateProductInfo : NSObject

@property (nonatomic, strong) NSString *dataStr;

/**
 *计算产品收益  
 参数：产品model  购买金额
 */
+ (NSString *)calculateProdcutYearIncome:(SilverWealthProductDetailModel *)productModel purchaseNum:(NSUInteger)purchaseNum;

/**
 *计算产品是否售罄
 */
+ (BOOL)calculateProdcutWhetherSelloutWith:(SilverWealthProductModel *)productModel;

+ (BOOL)calculateProdcutDetailWhetherSelloutWith:(SilverWealthProductDetailModel *)productModel;

+ (NSString *)stringByNotRounding:(double)price afterPoint:(int)position;

+ (NSString *)alculateStringByNotRounding:(double)price afterPoint:(int)position;


/**
 *计算精品推荐页产品是否售罄
 */
+ (BOOL)calculateRefinedProdcutWhetherSelloutWith:(RecommendContentModel *)productModel;

//计算产品是否开售
+ (BOOL)calculateProdcutBeginSaleWith:(SilverWealthProductDetailModel *)productModel;




/**
 *计算产品 剩余可购买金额
 */
+ (NSDecimalNumber *)calculateProdcutSurplusCanPurchaseNumWith:(SilverWealthProductDetailModel *)productModel;


/**
 *计算已购产品里 各种金额
 */
+ (NSString *)calculateAlreadyProdcutNumWith:(NSString *)valueStr isDouble:(BOOL)isDouble;


/**
 *计算产品到期时间 beginTime 为时间字符串 spaceDayTime单位为天
 */
+ (NSString *)calculateExpireTimeWith:(NSString *)beginTime spaceDayTime:(NSString *)spaceDayTime;

/**
 *时间加上天数
 */
+ (NSString *)calculateTimeWith:(NSString *)beginTime spaceDayTime:(NSString *)spaceDayTime;

/**
 *计算产品募集进度
 */
+ (NSDecimalNumber *)calculateProductCollectProgressWith:(SilverWealthProductDetailModel *)productModel;

/**
 *计算0元夺宝兑换进度
 */
+ (NSDecimalNumber *)calculateZeroChangeProgressWith:(ZeroIndianaModel *)productModel;


@end
