
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PromptLanguage : NSObject

//修改成功!
UIKIT_EXTERN NSString *const ModifiySucceed;
// = @"设置成功!"
UIKIT_EXTERN NSString *const SetSucceed;
// = @"修改失败!"
UIKIT_EXTERN NSString *const ModifiyFail;
//土豪,两次输入的交易密码不一致哦!
UIKIT_EXTERN NSString *const TradePasswordForTwiceDifferent;
UIKIT_EXTERN NSString *const CellphoneNORegister;

//=@"土豪，新交易密码不能和原交易密码相同哦!"
UIKIT_EXTERN NSString *const TradePasswordForNewAndOldPasswordCannotSame;

//@"您输入的姓名或身份证号码有误!";
UIKIT_EXTERN NSString *const UserNameOrIdCardError;
//@"您的银行卡有误，请重试!";
UIKIT_EXTERN NSString *const IdCardError;
//@"没有这样的手机号!";
UIKIT_EXTERN NSString *const CellphoneNumError;
//@"土豪,您的银子不够，请再去赚点儿吧!";
UIKIT_EXTERN NSString *const ExchangeTelephoneBillForSilverDeficiency;

//=@"土豪,您还没有交易过哦!"
UIKIT_EXTERN NSString *const ExchangeTelephoneBillForWithoutTrade;

//@"原密码有误!";
UIKIT_EXTERN NSString *const ModifiyLoginPasswordForOriginalError;
//@"原密码格式有误!";
UIKIT_EXTERN NSString *const ModifiyLoginPasswordForOriginalFormatError;
//@"新密码格式有误!";
UIKIT_EXTERN NSString *const ModifiyLoginPasswordForNewFormatError;
//@"新密码不能和原密码相同哦!";
UIKIT_EXTERN NSString *const ModifiyLoginPasswordForNewAndOldPasswordCannotSame;
//@"两次输入的密码不一致哦!";
UIKIT_EXTERN NSString *const ModifiyLoginPasswordForTwiceDifferent;
//@"土豪,手势密码至少需要连接四个点哦!"
UIKIT_EXTERN NSString *const GesturePasswordForNeedFourSpot;
//@"两次手势密码不一致，请重新输入!"
UIKIT_EXTERN NSString *const GesturePasswordForrTwiceDifferent;
//@"提交成功，感谢您的反馈!"
UIKIT_EXTERN NSString *const IdeaFeedbackForSucceed;
//@"您输入的密码有误!"
UIKIT_EXTERN NSString *const LoginForPasswordError;
//@"密码格式有误!"
UIKIT_EXTERN NSString *const LoginForPasswordFormatError;
//@"身份证号码有误!"
UIKIT_EXTERN NSString *const LoginForIdCardError;
//@"身份证号码格式有误!"
UIKIT_EXTERN NSString *const LoginForIdCardFormatError;
//@"请输入验证码!"
UIKIT_EXTERN NSString *const LoginForCheckingCodeError;
//=@"请检查输入是否有误!"
UIKIT_EXTERN NSString *const LoginForCensorInput;
//=@"您未同意我们的协议哦!"
UIKIT_EXTERN NSString *const WithoutAgreeProtocol;
//=@"请先添加银行卡哦!"
UIKIT_EXTERN NSString *const PleaseAddBankCard;
//=@"请选择银行!"
UIKIT_EXTERN NSString *const PleaseChooseBank;
//=@"抱歉，该产品为首次购买银狐财富产品用户专享!"
UIKIT_EXTERN NSString *const JackerooSpeciallyPatent;
//=@"订单号请求出错,请重试!"
UIKIT_EXTERN NSString *const OrderNoRequestError;
//=@"验证码错误!"
UIKIT_EXTERN NSString *const CheckingCodeError;
//=@"银行卡号格式有误!"
UIKIT_EXTERN NSString *const BankCardNumFormatError;
//=@"您的银行卡有误，请重试!"
UIKIT_EXTERN NSString *const BankCardNumDetectionError;
////=@"您的银行卡号和所选银行不对应!"
//UIKIT_EXTERN NSString *const BankCardNumIsNoHomologous;

// @"您已签过到了!"
UIKIT_EXTERN NSString *const AlreadySign ;
// @"您的身份证号或者手机号有误!!"
UIKIT_EXTERN NSString *const UserPhoneNumberOrIdCardError;
// @"网络连接超时,请重试!"
UIKIT_EXTERN NSString *const NotHaveNetwork;
//
UIKIT_EXTERN NSString *const TradePasswordErrorFiveOnce;

//= @"土豪,您反馈的内容太长了,请分条发送!"
UIKIT_EXTERN NSString *const FeedBackContentTooLength;

// @"土豪,您输入的联系方式太长了!"
UIKIT_EXTERN NSString *const FeedBackConnectionTooLength;

//= @"加载错误,反馈失败!"
UIKIT_EXTERN NSString *const FeedBackFail;

// = @"土豪，您还未做过投资，暂无排名!"
UIKIT_EXTERN NSString *const AnnouncementListNotInvest;

//= @"该身份证已和其他账号绑定!"
UIKIT_EXTERN NSString *const IdCardAlreadyBind ;


UIKIT_EXTERN NSString *const AccumulateRebateMoreLess;

//= @"分享成功!"
UIKIT_EXTERN NSString *const ShareSuccess ;

//= @"土豪，不能用自己的账号找回别人的手势呢!"
UIKIT_EXTERN NSString *const WrongLoginPasswordVerify ;

//受不可抗力影响，支付失败了...
UIKIT_EXTERN NSString *const PayForSignFail;

// = @"土豪，您只能购买跟支付卡同等面额的产品！"
UIKIT_EXTERN NSString *const PaymentCardWithPurchaseMoneyDif;

// = @"您非投资客，可重新设置交易密码"
UIKIT_EXTERN NSString *const FaultExchangeUserCanSetTradePasswordAgain;

// = @"抱歉,该产品已售罄！"
UIKIT_EXTERN NSString *const ProductWithoutSurplus;

// = @"该设备注册次数已超出上限!"
UIKIT_EXTERN NSString *const RegisterForBeyondTheLimit;

//两次提交的信息不一致，请5分钟后重试！
UIKIT_EXTERN NSString *const AddBankCardForInfoNotAccordance;

//@"由于您长时间未操作，请重新选择银行卡！"
UIKIT_EXTERN NSString *const AddBankCardForWaitOvertime;

//= @"更新募集进度失败,请稍后再试！"
UIKIT_EXTERN NSString *const UpdateCollectProgressFail ;

//= @"您当前没有可转出金额！"
UIKIT_EXTERN NSString *const NowNotMoneyRollOut ;
UIKIT_EXTERN NSString *const TheMinimumInvestmentIs500Yuan;

UIKIT_EXTERN NSString *const PleaseWaitALittleWhile;
UIKIT_EXTERN NSString *const AuthorizationSuccess;
UIKIT_EXTERN NSString *const AuthorizationFalse;
UIKIT_EXTERN NSString *const PleaseToMyCouponListLookUp;
//输入框为空时 提示请输入***!
+ (NSString *)pleaseInputeWith:(NSString *)text;
//土豪，求抱大腿~该产品最多可购买%@元
+ (NSString *)buyNumAmountSuperscaleWithAmount:(NSString *)amount;

//已经购买过三种产品
+ (NSString *)alreadyBuyThisProductWith:(NSString *)productProperty;




@end
