

#import "IndividualInfo.h"

@implementation IndividualInfo

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"cellphone":@"user.cellphone",@"customerId":@"user.id",@"idcard":@"user.idcard",@"name":@"user.name",@"registerTime":@"user.registerTime",@"silverNumber":@"user.silverNumber",@"sendMessage":@"user.sendMessage",@"bankStatus":@"bankStatus",@"accountId":@"user.accountId",@"vipLevel":@"user.vipLevel",@"headSculptureUrl":@"user.headSculptureUrl",@"isVip":@"user.isVip"};
}

+ (NSValueTransformer *)isVipJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

+ (NSValueTransformer *)vipLevelJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

+ (NSValueTransformer *)bankStatusJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

+ (NSValueTransformer *)customerIdJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

+ (NSValueTransformer *)sendMessageJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

+ (NSValueTransformer *)silverNumberJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}




















@end
