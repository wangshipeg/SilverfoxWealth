


//本页面包括 产品预告 和 常见问题
#import <UIKit/UIKit.h>

typedef enum {
    frequentQuestion,    //常见问题
    rebateUseInfo,       //红包使用说明
    silverUseInfo,       //银子使用说明
    limitInfo,           //限额说明
    accountServiceAgreement, //用户服务协议
    signature,  //电子签章
    openAccount, //开户协议
    userPersonal  //开户-用户协议
}Work_State;

@interface HTMLVC : UIViewController

@property (nonatomic, assign) Work_State  work;
@property (nonatomic, copy) NSString *account;
@property (nonatomic , copy)NSString *productOfID;
@property (nonatomic, strong) NSString *questionnaire;         //调查问卷

@end





