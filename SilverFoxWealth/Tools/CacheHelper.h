#import <Foundation/Foundation.h>
//#import "CacheClient.h"
#import "SilverWealthProductDetailModel.h"
#import "AssetModel.h"


@interface CacheHelper : NSObject

/**
 *保存推荐数据
 */
+(void)saveRecommendData:(NSMutableArray *)acc;

/**
 *当前缓存的推荐产品数据
 */
+(NSMutableArray *)currentRecommendData;


//--------------

/**
 *保存理财产品数据
 */
+(void)saveFinancingProductList:(NSArray *)acc;


/**
 *当前缓存的推荐产品数据
 */
+(NSMutableArray *)currentFinancingProductList;


//--------------

//--------------
/**
 *保存"发现--活动专区"数据
 */
+ (void)saveFindPageDataSource:(NSMutableArray *)arr;
/**
 *当前缓存的"发现--活动专区"数据
 */
+(NSMutableArray *)currentFindPageDataSource;

//--------------
/**
 *发现--银子商城  数据保存
 */
+ (void)saveFindOfGoodsDataSource:(NSMutableArray *)arr;
/**
 *获取发现--银子商城 数据
 */
+ (NSMutableArray *)currentFindGoodsDataSource;

/**
 *发现--理财专栏数据保存
 */
+ (void)saveFindExtrasDataSouurce:(NSMutableArray *)arr;
/**
 *获取发现--理财专栏 数据
 */
+ (NSMutableArray *)currentExtrasDataSource;


/**
 *保存我的资产数据
 */
+(void)saveAssetData:(AssetModel *)acc;

/**
 *移除我的资产数据
 */
+ (void)removeAssetData;

/**
 *当前缓存的我的资产数据
 */
+(AssetModel *)currentAssetData;

//存储我的资产数据为****
+ (void)saveTotalAssetDataString:(NSString *)str;
//获取我的资产缓存数据
+ (NSString *)getTotalAssetDataString;
//删除我的资产数字缓存数据
+ (void)deletTotalAssetDataString;




/**
 *保存用户银行卡信息
 */
+(void)saveUserBankInfo:(NSDictionary *)acc;

/**
 *移除用户银行卡信息
 */
+ (void)removeUserBankInfo;

/**
 *当前缓存的用户银行卡信息
 */
+(NSDictionary *)currentUserBankInfo;



@end
