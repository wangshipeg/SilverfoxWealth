

#import "DetailPageBuyBlockModel.h"

@implementation DetailPageBuyBlockModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"cellphone":@"cellphone",@"orderTime":@"orderTime",@"principal":@"principal",@"lastOrderType":@"lastOrderType",@"amount":@"amount"};
}

+ (NSValueTransformer *)amountJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

+ (NSValueTransformer *)lastOrderTypeJSONTransformer {
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
