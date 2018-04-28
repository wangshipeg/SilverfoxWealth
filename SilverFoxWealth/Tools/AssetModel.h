

//我的资产model

#import "MTLModel.h"
#import <Mantle/Mantle.h>


@interface AssetModel : MTLModel<MTLJSONSerializing>


@property (nonatomic, strong) NSString *accumulationProfit;
@property (nonatomic, strong) NSString *totalAsset;
@property (nonatomic, strong) NSString *balance;
@property (nonatomic, strong) NSString *yesterdayProfit;


@end
