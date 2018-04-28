

#import <Foundation/Foundation.h>
#import "AssetModel.h"
#import "RecommendAdvertModel.h"
#import "SilverWealthProductDetailModel.h"





@interface CacheClient : NSObject

//
//+(instancetype)shareCacheClient;
//
////打开数据库
//-(BOOL)openDB;
//
///**
// *检查数据库中是否有某张表
// */
//-(BOOL)isTable:(NSString *)tableName;
//
///**
// *删除数据库中的某张表
// */
//-(BOOL)deleTable:(NSString *)tableName;
//
///**
// *清空数据库里的某张表的所有信息
// */
//-(BOOL)eraseTableInfo:(NSString *)tableName;
//
///**
// *获取某张表中有条数据
// */
//-(NSInteger)achieveTableDateNum:(NSString *)tableName;
//
///**
// *关闭表
// */
//-(void)closeDB;
//
//
/////////////////////// 精品推荐
//
///**
// *检查是否有精品推荐表
// */
//- (BOOL)isHaveRecommendTable;
//
///**
// *创建 精品推荐 表
// */
//- (BOOL)creatRecommendTable;
//
///**
// *往精品推荐表中插入数据
// */
//- (void)insertRecommendModel:(SilverWealthProductModel *)silverWealthProductModel;
//
///**
// *获取精品推荐里有多少数据
// */
//- (NSInteger)achieveRecommendTableDataNum;
//
///**
// *更新精品推荐中的数据 如果相同就不更新了
// */
//- (BOOL)updateRecommendModel:(SilverWealthProductModel *)silverWealthProductModel;
//
///**
// *得到精品推荐 推荐产品数据
// */
//- (SilverWealthProductModel *)selectAllWithRecommendTable;













///////////////////// 理财产品

















/////////////////////// 我的资产
//
///**
// *删除我的资产 表
// */
//-(void)deleAssetTable;
//
///**
// *检查是否有我的资产表
// */
//-(BOOL)isHaveAssetTable ;
//
///**
// *创建 我的资产 表
// */
//-(BOOL)creatAssetTable;
//
///**
// *往我的资产表中插入数据
// */
//-(void)insertAssetModel:(AssetModel *)assetModel;
//
///**
// *获取我的资产里有多少数据
// */
//- (NSInteger)achieveAssetTableDataNum;
//
///**
// *更新asset中的数据 如果相同就不更新了
// */
//-(BOOL)updateAssetModel:(AssetModel *)assetModel;
//
///**
// *得到我的资产 所有数据
// */
//-(AssetModel *)selectAllWithAssetTable;
//
//

@end
