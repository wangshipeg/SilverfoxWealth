

#import "EstimateRebateUsefulness.h"

@implementation EstimateRebateUsefulness

//红包model  产品model  购买金额  当前用户总共交易金额
+ (BOOL)estimateRebateWhetherUseWith:(RebateModel *)rebateModel productModel:(SilverWealthProductDetailModel *)productModel purchaseNum:(NSString *)purchaseNum totalTradeNum:(NSString *)totalTradeNum {
    if (![productModel.property isEqualToString:@"COMMON"])
    {
        return NO;
    }
    if ([rebateModel.category integerValue] < 4)
    {
        if (!([productModel.financePeriod intValue] >= [rebateModel.financePeriod intValue]))
        {
            return NO;
        }
    }
    if ([rebateModel.category integerValue] > 3)
    {
        if (!([productModel.financePeriod intValue] >= [rebateModel.financePeriod intValue])) {
            return NO;
        }
    }
    double purchaseNumDB = 0;
    double currentTotalTradeNUmDB = 0;
    
    if (purchaseNum) {
      purchaseNumDB = [purchaseNum doubleValue]; //当前购买金额
    }
    if (totalTradeNum) {
       currentTotalTradeNUmDB = [totalTradeNum doubleValue]; //当前用户总共交易金额
    }
    if ([rebateModel.moneyLimit integerValue] == 0) {
        return YES;
    }
    if (([rebateModel.moneyLimit integerValue] == 1) && (purchaseNumDB >= [rebateModel.tradeAmount integerValue]))
    {
        return YES;
    }
    if (([rebateModel.moneyLimit integerValue] == 2) && ((currentTotalTradeNUmDB + purchaseNumDB) >= [rebateModel.tradeAmount integerValue])) {
        return YES;
    }
    return NO;
}


//在购买页面 当购买金额变化时 判断红包是否需要移除;
+ (BOOL)estimateRebateWhetherCanRemove:(RebateModel *)rebateModel {
    return YES;
}


@end
