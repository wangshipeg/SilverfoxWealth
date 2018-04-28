
#import "CacheClient.h"
#import "PathHelper.h"
#import <sqlite3.h>
#import <FMDB.h>


//NSString *const RecommendDataCacheTableName= @"recommend";
//NSString *const ProductDataCacheTableName = @"product";
//NSString *const AssetDataCacheTableName = @"asset";
//NSString *const UserBankInfo = @"BankInfo";



//static FMDatabase *db=nil;
//
//
@implementation CacheClient
//
//
//+(instancetype)shareCacheClient {
//    static CacheClient *shareClient=nil;
//    static dispatch_once_t onceToken;
//    
//    dispatch_once(&onceToken, ^{
//        shareClient=[[CacheClient alloc] init];
//    });
//    
//    return shareClient;
//}
//
//
////获取文件路径
//-(NSString *)getAccountsStroagePath:(NSString *)fileName {
//    
//    NSString *path=[[PathHelper documentDirectoryPathWithName:@"db"] stringByAppendingPathComponent:fileName];
//    
//    return path;
//    
//    return Nil;
//}
//
//
//-(BOOL)openDB {
//    
//    db=[FMDatabase databaseWithPath:[self getAccountsStroagePath:@"dateCache.sqlite"]];
//    
//    if ([db open]) {
//        NSLog(@"数据库打开成功");
//        return YES;
//    }
//    
//    NSLog(@"数据库打开失败");
//    return NO;
//    
//}
//
//// 精品推荐 recommend
//// 理财产品 product
//// 我的资产 asset
//
////检查某张表是否存在
//-(BOOL)isTable:(NSString *)tableName {
////    select count(*) from sqlite_master  --查询sqlite_master表中共有多少条记录
//    FMResultSet *set=[db executeQuery:@"SELECT count(*) as 'count' FROM sqlite_master WHERE type = 'table' and name = ? ",tableName];
//    while ([set next]) {
//        NSInteger count=[set intForColumn:@"count"];
//        if (0==count) {
//            return NO;
//        }
//        return YES;
//    }
//    
//    return NO;
//}
//
//
////获取某张表中有多少条数据
//-(NSInteger)achieveTableDateNum:(NSString *)tableName {
//    
//    NSString *sqlStr=[NSString stringWithFormat:@"SELECT count(*) as 'count' FROM %@",tableName];
//    FMResultSet *set=[db executeQuery:sqlStr];
//    
//    NSInteger count=0;
//    while ([set next]) {
//        count=[set intForColumn:@"count"];
//    }
//    return count;
//}
//
////删除表
//-(BOOL)deleTable:(NSString *)tableName {
//    
//    NSString *deleSqlStr=[NSString stringWithFormat:@"DELETE FROM '%@'",tableName];
//    BOOL success=[db executeQuery:deleSqlStr];
//    
//    if (success) {
//        NSLog(@"删除表%@成功",tableName);
//        return YES;
//    }
//    
//    NSLog(@"删除表%@失败",tableName);
//    
//    return NO;
//    
//}
//
////清空表里的所有信息
//-(BOOL)eraseTableInfo:(NSString *)tableName {
//    NSString *sqlStr=[NSString stringWithFormat:@"DELETE FROM %@",tableName];
//    BOOL success=[db executeUpdate:sqlStr];
//    if (success) {
//        NSLog(@"清空表%@ 成功",tableName);
//        return YES;
//    }
//    
//    NSLog(@"清空表%@ 失败",tableName);
//    return NO;
//}
//
////关闭表
//-(void)closeDB {
//    [db close];
//}
//
//
//
//
//
//#pragma -mark 精品推荐 
//
////查看是否有精品推荐这张表
//- (BOOL)isHaveRecommendTable {
//   return [self isTable:RecommendDataCacheTableName];
//}
//
//
////创建精品推荐表
//- (BOOL)creatRecommendTable {
//    
//    NSString *sqlstr=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@'(productId INTEGER PRIMARY KEY,name text,categoryId text,lowestMoney text,actualAmount text,totalAmount text,yearIncome text,sortNumber text,shippedTime text,interestDate text,financePeriod text,remark text)",RecommendDataCacheTableName];
//    BOOL seccess=[db executeUpdate:sqlstr];
//    if (seccess) {
//        return YES;
//    }
//    return NO;
//    
//}
//
//- (void)insertRecommendModel:(SilverWealthProductModel *)silverWealthProductModel {
//    
//    NSInteger productId=[silverWealthProductModel.productId integerValue];
//    NSString *name=silverWealthProductModel.name;
//    NSString *categoryId=silverWealthProductModel.categoryId;
//    NSString *lowestMoney=silverWealthProductModel.lowestMoney;
//    NSString *actualAmount=silverWealthProductModel.actualAmount;
//    NSString *totalAmount=silverWealthProductModel.totalAmount;
//    NSString *yearIncome=silverWealthProductModel.yearIncome;
//    NSString *sortNumber=silverWealthProductModel.sortNumber;
//    NSString *shippedTime=silverWealthProductModel.shippedTime;
//    NSString *interestDate=silverWealthProductModel.interestDate;
//    NSString *financePeriod=silverWealthProductModel.financePeriod;
//    NSString *remark=silverWealthProductModel.remark;
//    
//    //如果其中一项为空 就不存
//    if (!productId||!name||!categoryId||!lowestMoney||!actualAmount||!totalAmount||!yearIncome||!sortNumber||!shippedTime||!interestDate||!financePeriod||!remark) {
//        return;
//    }
//    
//    NSString *insertStr=[NSString stringWithFormat:@"INSERT INTO %@ (productId,name,categoryId,lowestMoney,actualAmount,totalAmount,yearIncome,sortNumber,shippedTime,interestDate,financePeriod,remark) VALUES (%ld,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@)",RecommendDataCacheTableName,(long)productId,name,categoryId,lowestMoney,actualAmount,totalAmount,yearIncome,sortNumber,shippedTime,interestDate,financePeriod,remark];
//    BOOL seccess=[db executeUpdate:insertStr];
//    if (seccess) {
//        NSLog(@"精品推荐 数据添加成功 ");
//        return;
//    }
//    NSLog(@"精品推荐 数据添加失败 ");
//}
//
//- (NSInteger)achieveRecommendTableDataNum {
//   return [self achieveTableDateNum:RecommendDataCacheTableName];
//}
//
////productId; //产品id
////name;//产品名称
////lowestMoney;//起投金额
////actualAmount;//实际募捐金额
////totalAmount; //募集总金额
////yearIncome;//预期年化收益
////sortNumber;//30天购买次数
////shippedTime;//上架时间
////interestDate;//起息时间
////financePeriod;//理财期限
////remark; //其它内容描述
//
//
//- (BOOL)updateRecommendModel:(SilverWealthProductModel *)silverWealthProductModel {
//    
//    SilverWealthProductModel *oldProduct=[self selectAllWithRecommendTable];
//    
//    //如果已经添加这个产品了 就 不更新了
//    if ([silverWealthProductModel.productId integerValue]==[oldProduct.productId integerValue]) {
//        return NO;
//    }
//    
//    NSString *updateSqlStr=[NSString stringWithFormat:@"UPDATE %@ SET productId = %ld,name = %@, productId = %@,lowestMoney = %@,actualAmount = %@,totalAmount = %@,yearIncome = %@,sortNumber = %@,shippedTime = %@,interestDate = %@,financePeriod = %@,remark = %@",RecommendDataCacheTableName,(long)[silverWealthProductModel.productId integerValue],silverWealthProductModel.name,silverWealthProductModel.categoryId,silverWealthProductModel.lowestMoney,silverWealthProductModel.actualAmount,silverWealthProductModel.totalAmount,silverWealthProductModel.yearIncome,silverWealthProductModel.sortNumber,silverWealthProductModel.shippedTime,silverWealthProductModel.interestDate,silverWealthProductModel.financePeriod,silverWealthProductModel.remark];
//    
//    BOOL seccess=[db executeUpdate:updateSqlStr];
//    if (seccess) {
//        return YES;
//    }
//    return NO;
//    
//}
//
//
//
//- (SilverWealthProductModel *)selectAllWithRecommendTable {
//    
//    NSString *selectAllDateSql=[NSString stringWithFormat:@"SELECT * FROM %@",RecommendDataCacheTableName];
//    FMResultSet *set=[db executeQuery:selectAllDateSql];
//    SilverWealthProductModel *product=[SilverWealthProductModel new];
//    
//    while ([set next]) {
//        NSString *productId=[NSString stringWithFormat:@"%d",[set intForColumn:@"productId"]];
//        NSString *name=[NSString stringWithFormat:@"%@",[set stringForColumn:@"name"]];
//        NSString *categoryId=[NSString stringWithFormat:@"%@",[set stringForColumn:@"categoryId"]];
//        NSString *lowestMoney=[NSString stringWithFormat:@"%@",[set stringForColumn:@"lowestMoney"]];
//        NSString *actualAmount=[NSString stringWithFormat:@"%@",[set stringForColumn:@"actualAmount"]];
//        NSString *totalAmount=[NSString stringWithFormat:@"%@",[set stringForColumn:@"totalAmount"]];
//        NSString *yearIncome=[NSString stringWithFormat:@"%@",[set stringForColumn:@"yearIncome"]];
//        NSString *sortNumber=[NSString stringWithFormat:@"%@",[set stringForColumn:@"sortNumber"]];
//        NSString *shippedTime=[NSString stringWithFormat:@"%@",[set stringForColumn:@"shippedTime"]];
//        NSString *interestDate=[NSString stringWithFormat:@"%@",[set stringForColumn:@"interestDate"]];
//        NSString *financePeriod=[NSString stringWithFormat:@"%@",[set stringForColumn:@"financePeriod"]];
//        NSString *remark=[NSString stringWithFormat:@"%@",[set stringForColumn:@"remark"]];
//        product.productId=productId;
//        product.name=name;
//        product.categoryId=categoryId;
//        product.lowestMoney=lowestMoney;
//        product.actualAmount=actualAmount;
//        product.totalAmount=totalAmount;
//        product.yearIncome=yearIncome;
//        product.sortNumber=sortNumber;
//        product.shippedTime=shippedTime;
//        product.interestDate=interestDate;
//        product.financePeriod=financePeriod;
//        product.remark=remark;
//    }
//    return product;
// 
//}
//
//
//
//
//
//
//
//
//
//
//#pragma -mark 我的资产
//
////删除我的资产 表
//-(void)deleAssetTable {
//    if ([self isHaveAssetTable]) {
//        [self deleTable:AssetDataCacheTableName];
//    }
//}
//
//
//-(BOOL)isHaveAssetTable {
//    return [self isTable:AssetDataCacheTableName];
//}
//
////创建 我的资产 表
//-(BOOL)creatAssetTable {
//    NSString *sqlstr=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@'(accumulationProfit REAL,yestodayProfit REAL,totalAsset REAL)",AssetDataCacheTableName];
//    BOOL seccess=[db executeUpdate:sqlstr];
//    
//    if (seccess) {
//        return YES;
//    }
//    return NO;
//    
//}
//
////获取我的资产表里有多少数据
//- (NSInteger)achieveAssetTableDataNum {
//    return [self achieveTableDateNum:AssetDataCacheTableName];
//}
//
////往我的资产表中插入数据
//-(void)insertAssetModel:(AssetModel *)assetModel {
//    
//    if (!assetModel.accumulationProfit||!assetModel.yestodayProfit||!assetModel.totalAsset) {
//        return;
//    }
//    
//    NSString *insertStr=[NSString stringWithFormat:@"INSERT INTO %@ (accumulationProfit,yestodayProfit,totalAsset) VALUES (%f,%f,%f)",AssetDataCacheTableName,[assetModel.accumulationProfit floatValue],[assetModel.yestodayProfit floatValue],[assetModel.totalAsset floatValue]];
//    
//    BOOL seccess=[db executeUpdate:insertStr];
//    
//    if (seccess) {
//        NSLog(@"我的资产 数据添加成功 ");
//        return;
//    }
//    
//    NSLog(@"我的资产 数据添加失败 ");
//    
//}
//
////更新asset中的数据 如果相同就不更新了
//-(BOOL)updateAssetModel:(AssetModel *)assetModel {
//    
//   AssetModel *oldAsset=[self selectAllWithAssetTable];
//    
//    //如果和旧数据相同 就 不更新了
//    if (([oldAsset.accumulationProfit floatValue]==[assetModel.accumulationProfit floatValue])&&([oldAsset.yestodayProfit floatValue]==[assetModel.yestodayProfit floatValue])&&([oldAsset.totalAsset floatValue]==[assetModel.totalAsset floatValue])) {
//        return NO;
//    }
//    
//    
//    NSString *updateSqlStr=[NSString stringWithFormat:@"UPDATE asset SET accumulationProfit = %f,yestodayProfit = %f, totalAsset = %f",[assetModel.accumulationProfit floatValue],[assetModel.yestodayProfit floatValue],[assetModel.totalAsset floatValue]];
//    BOOL seccess=[db executeUpdate:updateSqlStr];
//    
//    if (seccess) {
//        return YES;
//    }
//    
//    return NO;
//    
//}
//
//
//
//
////得到我的资产 所有数据
//-(AssetModel *)selectAllWithAssetTable {
//    
//    NSString *selectAllDateSql=[NSString stringWithFormat:@"SELECT * FROM %@",AssetDataCacheTableName];
//    FMResultSet *set=[db executeQuery:selectAllDateSql];
//    
//    AssetModel *asset=[AssetModel new];
//    
//    while ([set next]) {
//        NSString *accumulationProfit=[NSString stringWithFormat:@"%.2f",[set doubleForColumn:@"accumulationProfit"]];
//        NSString *yestodayProfit=[NSString stringWithFormat:@"%.2f",[set doubleForColumn:@"yestodayProfit"]];
//        NSString *totalAsset=[NSString stringWithFormat:@"%.2f",[set doubleForColumn:@"totalAsset"]];
//        
//        asset.accumulationProfit=accumulationProfit;
//        asset.yestodayProfit=yestodayProfit;
//        asset.totalAsset=totalAsset;
//        
//    }
//    return asset;
//
//}











@end
