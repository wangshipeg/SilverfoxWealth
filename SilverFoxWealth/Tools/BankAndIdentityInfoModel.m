

#import "BankAndIdentityInfoModel.h"

@implementation BankAndIdentityInfoModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"bankName":@"bank.name",@"bankNO":@"bank.bankNO",@"bankId":@"bank.id",@"cardNO":@"bank.cardNO",@"dayLimit":@"bank.dayLimit",@"singleLimit":@"bank.singleLimit",@"canUnbinding":@"canUnbinding"};
}

+ (NSValueTransformer *)canUnbindingJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

+ (NSValueTransformer *)bankIdJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}
+ (NSValueTransformer *)dayLimitJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}
+ (NSValueTransformer *)singleLimitJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}
@end
