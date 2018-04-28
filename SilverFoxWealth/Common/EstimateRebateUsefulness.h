

//判断红包是否可用

#import <Foundation/Foundation.h>
#import "RebateModel.h"
#import "SilverWealthProductDetailModel.h"



@interface EstimateRebateUsefulness : NSObject


/**
 *判断红包是否可用 红包model  产品model  购买金额  当前用户总共交易金额
 */
+ (BOOL)estimateRebateWhetherUseWith:(RebateModel *)rebateModel productModel:(SilverWealthProductDetailModel *)productModel purchaseNum:(NSString *)purchaseNum totalTradeNum:(NSString *)totalTradeNum;

/**
 *在购买页面 当购买金额变化时 判断红包是否需要移除
 */
+ (BOOL)estimateRebateWhetherCanRemove:(RebateModel *)rebateModel;






@end
