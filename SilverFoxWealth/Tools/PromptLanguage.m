
#import "PromptLanguage.h"

@implementation PromptLanguage

NSString *const ModifiySucceed = @"修改成功！";
NSString *const ModifiyFail    = @"修改失败！";

NSString *const TradePasswordForTwiceDifferent=@"土豪，两次输入的交易密码不一致哦！";
NSString *const TradePasswordForNewAndOldPasswordCannotSame=@"土豪，新交易密码不能和原交易密码相同哦！";

NSString *const CellphoneNORegister = @"该手机号还未注册,请先注册!";
NSString *const UserPhoneNumberOrIdCardError = @"您输入的身份证号或者手机号有误!";
NSString *const UserNameOrIdCardError=@"您输入的姓名或身份证号码有误！";
NSString *const IdCardError=@"您的银行卡有误，请重试！";
NSString *const CellphoneNumError=@"没有这样的手机号！";
NSString *const ExchangeTelephoneBillForSilverDeficiency=@"土豪，您的银子不够，请再去赚点儿吧！";
NSString *const ExchangeTelephoneBillForWithoutTrade=@"土豪,您还未购买过任何产品呢,做点投资后再来吧！";
NSString *const ModifiyLoginPasswordForOriginalError=@"土豪，原密码有误！";
NSString *const ModifiyLoginPasswordForOriginalFormatError=@"土豪，原密码格式有误！";
NSString *const ModifiyLoginPasswordForNewFormatError=@"土豪，新密码格式有误！";
NSString *const ModifiyLoginPasswordForNewAndOldPasswordCannotSame=@"土豪，新密码不能和原密码相同哦！";
NSString *const ModifiyLoginPasswordForTwiceDifferent=@"土豪，两次输入的密码不一致哦！";

NSString *const GesturePasswordForNeedFourSpot=@"土豪，手势密码至少需要连接四个点哦！";
NSString *const GesturePasswordForrTwiceDifferent=@"土豪，两次手势密码不一致\n请重新输入！";
NSString *const IdeaFeedbackForSucceed=@"提交成功，感谢您的反馈！";
NSString *const LoginForPasswordError=@"土豪，您输入的密码有误！";
NSString *const LoginForPasswordFormatError=@"土豪，密码格式有误！";
NSString *const LoginForIdCardError=@"土豪，身份证号码有误！";
NSString *const LoginForIdCardFormatError=@"土豪，身份证号码格式有误！";
NSString *const LoginForCheckingCodeError=@"土豪，请输入验证码！";
NSString *const LoginForCensorInput=@"请检查输入是否有误！";

NSString *const WithoutAgreeProtocol=@"您未同意我们的协议哦！";
NSString *const PleaseAddBankCard=@"请先添加银行卡哦！";
NSString *const PleaseChooseBank=@"请选择银行！";
NSString *const JackerooSpeciallyPatent=@"抱歉，该产品为新手专享~~";
NSString *const OrderNoRequestError=@"订单号请求出错,请重试！";
NSString *const CheckingCodeError=@"土豪,您输入的验证码有误！";

NSString *const BankCardNumFormatError=@"银行卡号格式有误！";
NSString *const BankCardNumDetectionError=@"您的银行卡有误，请重试！";

NSString *const SetSucceed                                = @"设置成功！";
NSString *const AlreadySign                               = @"土豪,今天已经签到过了哦";
NSString *const NotHaveNetwork                            = @"网络连接超时,请重试!";
NSString *const TradePasswordErrorFiveOnce                = @"土豪，交易密码因错误次数太多而被锁定，请找回交易密码！";
NSString *const FeedBackContentTooLength                  = @"土豪,您反馈的内容太长了,请分条发送！";
NSString *const FeedBackConnectionTooLength               = @"土豪,您输入的联系方式太长了！";
NSString *const FeedBackFail                              = @"加载错误,反馈失败！";
NSString *const AnnouncementListNotInvest                 = @"土豪，您还未做过投资，暂无排名！";
NSString *const IdCardAlreadyBind                         = @"该身份证已和其他账号绑定！";
NSString *const AccumulateRebateMoreLess                  = @"该红包满10元才可使用！";
NSString *const ShareSuccess                              = @"分享成功！";
NSString *const WrongLoginPasswordVerify                  = @"土豪，不能用自己的账号找回别人的手势呢！";
NSString *const PayForSignFail                            = @"受不可抗力影响，支付失败了...";
NSString *const PaymentCardWithPurchaseMoneyDif           = @"土豪，您只能购买跟支付卡同等面额的产品！";
NSString *const FaultExchangeUserCanSetTradePasswordAgain = @"您非投资客，可重新设置交易密码";
NSString *const ProductWithoutSurplus                     = @"抱歉,该产品已售罄！";
NSString *const RegisterForBeyondTheLimit                 = @"该设备注册次数已超出上限!";
NSString *const AddBankCardForInfoNotAccordance           = @"两次提交的信息不一致，请5分钟后重试！";
NSString *const AddBankCardForWaitOvertime                = @"由于您长时间未操作，请重新选择银行卡！";
NSString *const UpdateCollectProgressFail                 = @"抱歉，当前还有用户正在购买该产品，请5分钟后重试" ;
NSString *const NowNotMoneyRollOut                = @"您当前没有可转出金额" ;
NSString *const TheMinimumInvestmentIs500Yuan             = @"最低投资500元哦";
NSString *const PleaseWaitALittleWhile = @"请稍候...";
NSString *const AuthorizationSuccess = @"程序进入前台,刷新授权成功";
NSString *const AuthorizationFalse = @"程序进入前台,刷新授权失败";
NSString *const PleaseToMyCouponListLookUp = @"请在'我的优惠券'中查看";
#pragma -mark 用户未输入
//输入框为空时 提示请输入***!
+ (NSString *)pleaseInputeWith:(NSString *)text {
    NSString *str=[NSString stringWithFormat:@"请输入%@!",text];
    return str;
}


//土豪，求抱大腿~该产品最多可购买%@元
+ (NSString *)buyNumAmountSuperscaleWithAmount:(NSString *)amount {
    NSString *str=[NSString stringWithFormat:@"土豪,该产品最多可购买%@元",amount];
    return str;
}

//已经购买过三种产品
+ (NSString *)alreadyBuyThisProductWith:(NSString *)productProperty {
    NSString *str=@"";
    if ([productProperty isEqualToString:@"NOVICE"]) {
       str=[NSString stringWithFormat:@"抱歉，您已购买过新手专享产品"];
    }
    return str;
}









@end
