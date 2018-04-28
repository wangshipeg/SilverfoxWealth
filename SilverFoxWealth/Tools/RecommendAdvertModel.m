

#import "RecommendAdvertModel.h"

@implementation RecommendAdvertModel

//前面是model中的属性名  后面的是json中的key
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"title":@"title",@"outLink":@"outLink",@"type":@"type",@"idStr":@"id",@"url":@"url",@"shareContent":@"shareContent"};
}

+ (NSValueTransformer *)idStrJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}

+ (NSValueTransformer *)typeJSONTransformer {
    return [MTLValueTransformer  transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSNumber *num=value;
        return [num stringValue];
    }];
}


@end
