

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>


@interface IndividualInfo : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *cellphone; 
@property (nonatomic, strong) NSString *customerId;
@property (nonatomic, strong) NSString *idcard;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *registerTime;
@property (nonatomic, strong) NSString *silverNumber;
@property (nonatomic, strong) NSString *sendMessage;
@property (nonatomic, strong) NSString *accountId;
@property (nonatomic, strong) NSString *bankStatus;//是否绑定银行卡
@property (nonatomic, strong) NSString *vipLevel;
@property (nonatomic, strong) NSString *headSculptureUrl;
@property (nonatomic, strong) NSString *isVip;

@end
