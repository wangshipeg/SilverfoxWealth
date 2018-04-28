

#import "AssetModel.h"

@implementation AssetModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{@"accumulationProfit":@"accumulationProfit",@"totalAsset":@"totalAsset",@"balance":@"balance",@"yesterdayProfit":@"yesterdayProfit"};
}

+ (NSValueTransformer *)yesterdayProfitJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}


+ (NSValueTransformer *)balanceJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}


+ (NSValueTransformer *)totalAssetJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

+ (NSValueTransformer *)accumulationProfitJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}




@end
