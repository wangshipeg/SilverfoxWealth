

#import "CacheHelper.h"
#import "PathHelper.h"
#import "CommunalInfo.h"
#import "IndividualInfoManage.h"

NSString *const RecommendDataCacheTableName= @"recommend";
NSString *const ProductDataCacheTableName = @"product";
NSString *const FindDataCacheTableName = @"find";
NSString *const AssetDataCacheTableName = @"asset";
NSString *const UserBankInfo = @"BankInfo";
NSString *const FindDataWithGoods = @"goods";
NSString *const FindDataWithExtras = @"extras";

static NSMutableArray *recommendData; //推荐产品缓存
static NSMutableArray *financingProductList; //理财产品列表
static NSMutableArray *findPageData;//发现-活动专区缓存
static NSMutableArray *findGoodsData;
static NSMutableArray *findExtrasData;

static AssetModel *assetData;
static NSString   *assetStr;
static NSMutableDictionary *UserBankInfoDic;

@implementation CacheHelper

#pragma -mark 管理 精品推荐页页 数据缓存

//推荐产品 缓存的路径
+(NSString *)getRecommendDataStroagePath {
    
    NSString *path=[[PathHelper documentDirectoryPathWithName:@"db"] stringByAppendingPathComponent:RecommendDataCacheTableName];
    return path;
    return Nil;
}

+(void)loadRecommendData {
    recommendData=[NSKeyedUnarchiver unarchiveObjectWithFile:[self getRecommendDataStroagePath]];
}

//保存推荐数据
+(void)saveRecommendData:(NSMutableArray *)acc {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSKeyedArchiver archiveRootObject:acc toFile:[self getRecommendDataStroagePath]];
        recommendData=acc;
    });
}

//移除推荐产品数据
+ (void)removeRecommendData {
    if (recommendData) {
        recommendData=Nil;
        [self saveRecommendData:recommendData];
    }
}

//当前缓存的推荐产品数据
+(NSMutableArray *)currentRecommendData {
    if (!recommendData) {
        [self loadRecommendData];
    }
    return recommendData;
}



#pragma -mark 管理 理财产品页 数据缓存
//理财列表 缓存的路径
+(NSString *)getFinancingProductListStroagePath {
    
    NSString *path=[[PathHelper documentDirectoryPathWithName:@"db"] stringByAppendingPathComponent:ProductDataCacheTableName];
    return path;
    return Nil;
}

+(void)loadFinancingProductList {
    
    if (!financingProductList) {
        financingProductList=[NSMutableArray array];
    }
    financingProductList = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getFinancingProductListStroagePath]];
}

//保存理财产品数据
+(void)saveFinancingProductList:(NSArray *)acc {
    
    if (!financingProductList) {
        financingProductList=[NSMutableArray array];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSKeyedArchiver archiveRootObject:acc toFile:[self getFinancingProductListStroagePath]];
        [financingProductList removeAllObjects];
        financingProductList=[NSMutableArray arrayWithArray:acc];
    });
}

//移除理财产品数据
+ (void)removeFinancingProductList {
    if (financingProductList.count != 0) {
        [financingProductList removeAllObjects];
        [self saveFinancingProductList:financingProductList];
    }
}

//当前缓存的推荐产品数据
+(NSMutableArray *)currentFinancingProductList {
    if (!financingProductList) {
        NSLog(@"存在数组");
    }
    [self loadFinancingProductList];
    return financingProductList;
}

#pragma -mark "发现"
+ (void)saveFindPageDataSource:(NSMutableArray *)arr
{
    if (!findPageData) {
        findPageData=[NSMutableArray array];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSKeyedArchiver archiveRootObject:arr toFile:[self getFindDataStroagePath]];
        [findPageData removeAllObjects];
        findPageData=[NSMutableArray arrayWithArray:arr];
    });
}

+(NSString *)getFindDataStroagePath {
    NSString *path = [[PathHelper documentDirectoryPathWithName:@"db"] stringByAppendingPathComponent:FindDataCacheTableName];
    return path;
}
/**
 *当前缓存的"活动专区"数据
 */
+(NSMutableArray *)currentFindPageDataSource
{
    if (!findPageData) {

    }
    [self loadFindData];
    return findPageData;
}

+(void)loadFindData {
    if (!findPageData) {
        findPageData=[NSMutableArray array];
    }
    findPageData = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getFindDataStroagePath]];
}




/**
 *发现--银子商城  数据保存
 */
+ (void)saveFindOfGoodsDataSource:(NSMutableArray *)arr
{
    if (!findGoodsData) {
        findGoodsData = [NSMutableArray array];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSKeyedArchiver archiveRootObject:arr toFile:[self getFindGoodsDataStroagePath]];
        [findGoodsData removeAllObjects];
        findGoodsData=[NSMutableArray arrayWithArray:arr];
    });
}

+ (NSString *)getFindGoodsDataStroagePath
{
    NSString *path = [[PathHelper documentDirectoryPathWithName:@"db"] stringByAppendingPathComponent:FindDataWithGoods];
    return path;
}
/**
 *获取发现--银子商城 数据
 */
+ (NSMutableArray *)currentFindGoodsDataSource
{
    [self loadFindGoodsData];
    return findGoodsData;
}

+ (void)loadFindGoodsData {
    if (!findGoodsData) {
        findGoodsData = [NSMutableArray array];
    }
    findGoodsData = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getFindGoodsDataStroagePath]];
}


/**
 *发现--理财专栏数据保存
 */
+ (void)saveFindExtrasDataSouurce:(NSMutableArray *)arr
{
    if (!findExtrasData) {
        findExtrasData = [NSMutableArray array];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSKeyedArchiver archiveRootObject:arr toFile:[self getFindExtrasDataStroagePath]];
        [findExtrasData removeAllObjects];
        findExtrasData = [NSMutableArray arrayWithArray:arr];
    });
}

+ (NSString *)getFindExtrasDataStroagePath
{
    NSString *path = [[PathHelper documentDirectoryPathWithName:@"db"] stringByAppendingPathComponent:FindDataWithExtras];
    return path;
}
/**
 *获取发现--理财专栏 数据
 */
+ (NSMutableArray *)currentExtrasDataSource
{
    [self loadFindExtrasData];
    return findExtrasData;
}

+ (void)loadFindExtrasData {
    if (!findExtrasData) {
        findExtrasData = [NSMutableArray array];
    }
    findExtrasData = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getFindExtrasDataStroagePath]];
}




#pragma -mark 管理 我的资产页 数据缓存
//我的资产 缓存的路径
+(NSString *)getAssetDataStroagePath {
    NSString *path=[[PathHelper documentDirectoryPathWithName:@"db"] stringByAppendingPathComponent:AssetDataCacheTableName];
    return path;
    return Nil;
}

//我的资产 缓存的路径
+(NSString *)getAssetDataStringPath {
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    //根据用户信息缓存数据
    NSString *path=[[PathHelper documentDirectoryPathWithName:@"db"] stringByAppendingPathComponent:user.customerId];
    return path;
    return Nil;
}

+(void)loadAssetData {
    assetData=[NSKeyedUnarchiver unarchiveObjectWithFile:[self getAssetDataStroagePath]];
}

+ (void)loadAssetStr {
    assetStr=[NSKeyedUnarchiver unarchiveObjectWithFile:[self getAssetDataStringPath]];
}

//保存我的资产数据
+ (void)saveAssetData:(AssetModel *)acc {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSKeyedArchiver archiveRootObject:acc toFile:[self getAssetDataStroagePath]];
        assetData=acc;
    });
}

//移除我的资产数据
+ (void)removeAssetData {
    if (assetData) {
        assetData=Nil;
        [self saveAssetData:assetData];
    }
}

//当前缓存的我的资产数据
+(AssetModel *)currentAssetData {
    if (!assetData) {
        [self loadAssetData];
    }
    return assetData;
}

//存储我的资产数据为****
+ (void)saveTotalAssetDataString:(NSString *)str
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSKeyedArchiver archiveRootObject:str toFile:[self getAssetDataStringPath]];
        assetStr = str;
    });
}

//获取我的资产缓存数据
+ (NSString *)getTotalAssetDataString
{
//    if (!assetStr) {
//        [self loadAssetStr];
//    }
//    return assetStr;
    [self loadAssetStr];
    return assetStr;
}

//删除我的资产数字缓存数据
+ (void)deletTotalAssetDataString
{
    if (assetStr) {
        assetStr=Nil;
        [self saveTotalAssetDataString:assetStr];
    }
}


#pragma -mark 用户银行卡信息
//用户银行卡信息缓存的路径
+(NSString *)getUserBankInfoStroagePath {
    NSString *path=[[PathHelper documentDirectoryPathWithName:@"db"] stringByAppendingPathComponent:UserBankInfo];
    return path;
    return Nil;
}

+(void)loadUserBankInfo {
    [self  userBankInfoDicIsNil];
    id data=[NSKeyedUnarchiver unarchiveObjectWithFile:[self getUserBankInfoStroagePath]];
    if (data==nil) {
        return;
    }
    UserBankInfoDic=data;
}

//保存用户银行卡信息
+(void)saveUserBankInfo:(NSDictionary *)acc {
    [self userBankInfoDicIsNil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [UserBankInfoDic removeAllObjects];
        [UserBankInfoDic setDictionary:acc];
        [NSKeyedArchiver archiveRootObject:UserBankInfoDic toFile:[self getUserBankInfoStroagePath]];
    });
}

//移除用户银行卡信息
+ (void)removeUserBankInfo {
    
    [self userBankInfoDicIsNil];
    if (UserBankInfoDic.count != 0) {
        [UserBankInfoDic removeAllObjects];
    }
    
    [NSKeyedArchiver archiveRootObject:UserBankInfoDic toFile:[self getUserBankInfoStroagePath]];
    
}

//当前缓存的用户银行卡信息
+(NSDictionary *)currentUserBankInfo {
    [self loadUserBankInfo];
    return UserBankInfoDic;
}

+ (void)userBankInfoDicIsNil {
    if (!UserBankInfoDic) {
        // 如果为nil 说明未初始化
        UserBankInfoDic=[NSMutableDictionary dictionary];
    }
}


@end
