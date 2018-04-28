

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface DetailPageBuyBlockModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, strong) NSString *cellphone;//电话号码
@property (nonatomic, strong) NSString *orderTime;//订单时间
@property (nonatomic, strong) NSString *principal;//购买金额
@property (nonatomic, strong) NSString *lastOrderType;//1固定金额 2万分比金额 3银子
@property (nonatomic, strong) NSString *amount;
@end
