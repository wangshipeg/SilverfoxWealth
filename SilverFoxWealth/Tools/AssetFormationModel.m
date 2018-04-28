

#import "AssetFormationModel.h"

@implementation AssetFormationModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"sonProductId":@"id",@"name":@"name",@"totalAmount":@"totalAmount",@"actualAmount":@"actualAmount"};
}
+ (NSValueTransformer *)sonProductIdJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}
+ (NSValueTransformer *)totalAmountJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}
+ (NSValueTransformer *)actualAmountJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

@end
