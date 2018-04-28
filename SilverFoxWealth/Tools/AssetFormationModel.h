

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface AssetFormationModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *sonProductId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *totalAmount;
@property (nonatomic, strong) NSString *actualAmount;

@end
