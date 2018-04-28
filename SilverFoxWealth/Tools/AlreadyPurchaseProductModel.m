
#import "AlreadyPurchaseProductModel.h"

@implementation AlreadyPurchaseProductModel

/*
 principal : 88800;
 profit : 3033;
 orderNO : SFf333333333333333;v
 payBackAmount : 8883033;
 productName : “银贷通”;
 remainingDays : 33;
 Status:1
 */

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"principal":@"principal",@"profit":@"profit",@"orderNO":@"orderNO",@"payBackAmount":@"payBackAmount",@"productName":@"productName",@"remainingDays":@"remainingDays",@"status":@"status",@"paybackDate":@"paybackDate",@"interestType":@"interestType",@"financePeriod":@"financePeriod",@"currentVipLevel":@"currentVipLevel"};
}

+ (NSValueTransformer *)currentVipLevelJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

+ (NSValueTransformer *)financePeriodJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

+ (NSValueTransformer *)interestTypeJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}


+ (NSValueTransformer *)statusJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

+ (NSValueTransformer *)profitJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}


+ (NSValueTransformer *)remainingDaysJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}


+ (NSValueTransformer *)payBackAmountJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

+ (NSValueTransformer *)principalJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}




@end
