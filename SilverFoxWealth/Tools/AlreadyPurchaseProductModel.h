
//已购产品 model

#import "MTLModel.h"
#import <Mantle/Mantle.h>


@interface AlreadyPurchaseProductModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *principal;
@property (nonatomic, strong) NSString *profit; //收益
@property (nonatomic, strong) NSString *orderNO;
@property (nonatomic, strong) NSString *payBackAmount;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *remainingDays;
@property (nonatomic, strong) NSString *financePeriod;
@property (nonatomic, strong) NSString *status;//2-募集中
@property (nonatomic, strong) NSString *paybackDate;
@property (nonatomic, strong) NSString *interestType;//是否是募集中产品
@property (nonatomic, strong) NSString *currentVipLevel;
@end



