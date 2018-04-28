

//已绑银行卡 中的 数据model

#import "MTLModel.h"
#import <Mantle/Mantle.h>


@interface BankAndIdentityInfoModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *bankName;
@property (nonatomic, strong) NSString *bankNO;
@property (nonatomic, strong) NSString *bankId;
@property (nonatomic, strong) NSString *cardNO;
@property (nonatomic, strong) NSString *dayLimit; //限额
@property (nonatomic, strong) NSString *singleLimit;
@property (nonatomic, strong) NSString *canUnbinding;

//bank:[
//      id : 1;
//      name : "\U5de5\U5546\U94f6\U884c";
//      remark : "1/50/50";
//      bankNO : 01020000;
//      cardNO : 6121222222222222222;
//      ]
//dayLimit":500000,
//"id":1,
//"monthLimit":50000,
//"name":"工商银行",
//"singleLimit":20000



@end




