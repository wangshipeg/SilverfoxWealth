
#import "AFHTTPSessionManager.h"


@interface DataRequest : AFHTTPSessionManager

/**
 *与银狐内部对接
 */
+ (instancetype)sharedClient;

/**
 *消息中心 即时查询数据
 */
+ (instancetype)sharedMessageCenter;


/**
 *检查网络可达性
 */
- (void)isReachability:(void(^)(BOOL isNet))netBlock;


/**
 *找回密码之 根据手机号确定用户是否为投资客
 */
- (void)provingCustomerStatusAndAchieveCheckingCodeWithCellphone:(NSString *)cellphone
                                                        callback:(void(^)(id obj))callback;

/**
 *用户注册
 */
- (void)registWithPhoneNum:(NSString *)cellphone
                      code:(NSString *)code
                  password:(NSString *)password
                  deviceId:(NSString *)deviceID
                 channelId:(NSString *)channelId
       invitationCellphone:(NSString *)invitationCellphone
                  callback:(void(^)(id obj))callback;
/**
 *银子商城  兑换
 */
- (void)silverTraderChangePagecustomerId:(NSString *)customerId
                                 goodsId:(NSString *)goodsId
                                    name:(NSString *)name
                               cellphone:(NSString *)cellphone
                                 address:(NSString *)address
                                callback:(void(^)(id obj))callback;
/**
 *0元夺宝 夺宝提交页  customerId:用户账号
 goodsId:商品id号
 number：参数次数
 silver：一共所需银子
 */
- (void)IndianaCommitPagecustomerId:(NSString *)customerId
                            goodsId:(NSString *)goodsId
                             portion:(NSString *)portion
                           callback:(void(^)(id obj))callback;
/**
 *我的夺宝 详情页
 */
- (void)MyIndianaDetailPagecustomerId:(NSString *)customerId
                              goodsId:(NSString *)goodsId
                             callback:(void(^)(id obj))callback;
/**
 *我的夺宝 详情页夺宝记录
 */
- (void)MyIndianaRecordWithDetailPageCellphone:(NSString *)cellphone
                                        goodsId:(NSString *)goodsId
                                           page:(int)page
                                       callback:(void(^)(id obj))callback;
/**
 *我的夺宝A值
 */
- (void)MyIndianaAWithDetailPageGoodsId:(NSString *)goodsId
                               callback:(void(^)(id obj))callback;
/**
 *登录
 */
- (void)loginWithCellphone:(NSString *)cellphone
                  password:(NSString *)password
                  callback:(void(^)(id obj))callback;



/**
 *找回登录密码 之 发送短信
 */
- (void)retrieveLoginPasswordForSendNoteWithCellphone:(NSString *)cellphone
                                               idcard:(NSString *)idcard
                                                 sign:(NSString *)sign
                                             callback:(void(^)(id obj))callback;


/**
 *找回登录密码 之 提交新密码
 */
- (void)retrieveLoginPasswordForSubmitNewPasswordWithPhoneNum:(NSString *)cellphone
                                                         code:(NSString *)code
                                                     password:(NSString *)password
                                                     callback:(void(^)(id obj))callback;

/**
 *重新获取验证码 包括 注册 和 登录
 */
- (void)afreshAchieveVerificationCodeWithCellphone:(NSString *)cellphone
                                           smsType:(NSString *)smsType
                                              sign:(NSString *)sign
                                          callback:(void(^)(id obj))callback;



/**
 *已登录状态 修改登录密码
 */
- (void)modifyLoginPasswordWithcustomerId:(NSString *)customerId
                              oldpassword:(NSString *)oldPassword
                              newpassword:(NSString *)newPassword
                                 callback:(void(^)(id obj))callback;




/**
 *设置交易密码
 */
- (void)installTradePasswordWithcustomerId:(NSString *)customerId
                             tradePassword:(NSString *)tradePassword
                                  callback:(void(^)(id obj))callback;

/**
 *更换手机号 之  验证手机号
 */

- (void)exchangePhoneNumberForCensorCodeWithCellphone:(NSString *)cellphone
                                               idCard:(NSString *)idCard
                                              smsCode:(NSString *)smsCode
                                              smsType:(NSString *)smsType
                                             callback:(void(^)(id obj))callback;
/**
 *更换手机号 之  验证新手机号C
 
 */

- (void)exchangeNewPhoneNumberForCensorCodeWithCellphone:(NSString *)cellphone
                                                 smsCode:(NSString *)smsCode
                                                authCode:(NSString *)authCode
                                                 channel:(NSString *)channel
                                               accountId:(NSString *)accountId
                                                callback:(void(^)(id obj))callback;

/**
 *当前手机号审核状态
 */
- (void)startsWithCustomerId:(NSString *)customerId
                    callback:(void(^)(id obj))callback;

/**
 *获取投资客信息
 */
- (void)achieveCustomerUserInfoWithcustomerId:(NSString *)customerId
                                     callback:(void(^)(id obj))callback;



/**
 *获取用户累计投资金额
 */
- (void)AchieveCustomerUserInfoFundTradeAmountWithcustomerId:(NSString *)customerId
                                                    callback:(void(^)(id obj))callback;

/**
 *精品推荐banner
 */
- (void)perfectRecommendationWithCallback:(void(^)(id obj))callback;
/**
 *精品推荐 产品
 */
- (void)perfectRecommendationProductCallback:(void(^)(id obj))callback;
/**
 *首页弹窗
 */
- (void)recommendPopouWithUserId:(NSString *)userId
                            callback:(void(^)(id obj))callback;
/**
 *本月累计签到天数领取奖励列表
 */
- (void)recommendationSignInRewardWithCallback:(void(^)(id obj))callback;
/**
 *补签
 */
- (void)recommendFillSignWithCustomerId:(NSString *)customerId
                                   date:(NSString *)date
                               callback:(void(^)(id obj))callback;
/**
 *领取签到奖品列表
 */
- (void)recommendationSignInPrizeWithcustomerId:(NSString *)customerId
                                        prizeId:(NSString *)prizeId
                                       callback:(void(^)(id obj))callback;
/**
 *领取签到奖品记录
 */
- (void)recommendationSignInRecordWithcustomerId:(NSString *)customerId
                                        callback:(void(^)(id obj))callback;

/**
 *签到奖励
 */
- (void)recommendationSignInTimesWithcustomerId:(NSString *)customerId
                                       callback:(void(^)(id obj))callback;

/**
 *补签卡数量
 */
- (void)recommendFillSignPageNumberWithCustomerId:(NSString *)customerId
                                         callback:(void(^)(id obj))callback;
/**
 *获取银狐财富列表数据
 categoryId
 Status
 period
 
 */
- (void)achieveSilverWealthWithPage:(int)page
                         categoryId:(NSString *)categoryId
                             status:(NSString *)status
                             period:(NSString *)period
                           callback:(void(^)(id obj))callback;

/**
 *产品列表跑马灯
 */
- (void)leightSilverWealthWithListCallback:(void(^)(id obj))callback;

/**
 *银子商城跑马灯
 */
- (void)leightForSilverGoodsWithCustomerId:(NSString *)customerId
                                  callback:(void(^)(id obj))callback;


/**
 *获取产品详情 根据id
 */
- (void)achieveProductDetailWith:(NSString *)productId
                        callback:(void(^)(id obj))callback;


/**
 *获取详情页 购买记录
 */
- (void)achieveProductDetailBuyBlockUpWith:(int)page
                                 productId:(NSString *)productId
                                  callback:(void(^)(id obj))callback;

/**
 * 获取用户的资产
 */
- (void)obtainUserAssetWithcustomerId:(NSString *)customerId
                             callback:(void(^)(id obj))callback;


/**
 *获取用户的银子进出明细
 */
- (void)obtainUserSilverDetailWithcustomerId:(NSString *)customerId
                                     page:(int)page
                                 callback:(void(^)(id obj))callback;

/**
 *获取用户已经绑定的银行卡列表
 */
- (void)obtainUserAlreadyBindCardListWithcustomerId:(NSString *)customerId
                                            channel:(NSString *)channel
                                           callback:(void(^)(id obj))callback;


/**
 *获取用户 已购产品 列表
 */
- (void)obtainUserAlreadyPurchaseProductWithcustomerId:(NSString *)customerId
                                                  type:(NSString *)type
                                                  page:(int)page
                                              callback:(void(^)(id obj))callback;

/**
 *获取用户的红包
 */
- (void)obtainUserRebateWithcustomerId:(NSString *)customerId
                                  page:(int)page
                                  used:(int)used
                                  size:(int)size
                              callback:(void(^)(id obj))callback;

/**
 *获取用户 夺宝列表
 */
- (void)obtainUserIndianaWithcustomerId:(NSString *)customerId
                                   page:(int)page
                               category:(int)category
                               callback:(void(^)(id obj))callback;

/**
 *兑换码
 */
- (void)obtainUserCouponNumberWithcustomerId:(NSString *)customerId
                                        code:(NSString *)code
                                    callback:(void(^)(id obj))callback;


/**
 *已购产品详情
 */
- (void)obtainUserAlreadyPurchaseProductDetailWithOrderNO:(NSString *)orderNO
                                                 callback:(void(^)(id obj))callback ;

/**
 *意见反馈
 */
- (void)ideaFeedbackWithContent:(NSString *)content
                        contact:(NSString *)contact
                     phoneModel:(NSString *)phoneModel
                  deviceVersion:(NSString *)deviceVersion
                     appVersion:(NSString *)appVersion
                       callback:(void(^)(id obj))callback;


/**
 *签到
 */
- (void)signWithcustomerId:(NSString *)customerId
                  callback:(void(^)(id obj))callback;

/**
 *退出登录
 */
- (void)quitLoginWithcustomerId:(NSString *)customerId;

/**
 *获取用户历史 消息
 */
- (void)obtainUserHistoryMessageWithcustomerId:(NSString *)customerId
                                          page:(int)page
                                      callback:(void(^)(id obj))callback;

/**
 *获取用户未读消息
 */
- (void)obtainUserNoReadMessageWithcustomerId:(NSString *)customerId
                                     callback:(void(^)(id obj))callback;

/**
 *读取消息(单个)
 */
- (void)readUserMessageWithcustomerId:(NSString *)customerId
                            messageId:(NSString *)messageId
                             callback:(void(^)(id obj))callback;
/**
 读取消息(一键全读)
 */
- (void)obtainReadAllUserHistoryMessageWithcustomerId:(NSString *)customerId
                                             callback:(void(^)(id obj))callback;


/**
 *检查用户是否已经购买过该产品
 */
- (void)inspectUserIsAlreadyProductWithProductId:(NSString *)productId
                                      customerId:(NSString *)customerId
                                        callback:(void(^)(id obj))callback;

/**
 *使用了邀请红包 分享成功  获取随机红包
 */
- (void)shareSucceedAchieveRebateWithcustomerId:(NSString *)customerId
                                    callback:(void(^)(id obj))callback;

/**
 *授权
 */
- (void)OAuthAuthenticationWithclient_id:(NSString *)client_id response_type:(NSString *)response_type redirect_uri:(NSString *)redirect_uri callback:(void(^)(id obj))callback;

/**
 *认证
 */
- (void)OAuthAuthorizationWithclient_id:(NSString *)client_id
                                compact:(NSString *)compact
                           client_secret:(NSString *)client_secret
                                   code:(NSString *)code
                              grant_type:(NSString *)grant_type
                            redirect_uri:(NSString *)redirect_uri
                               callback:(void(^)(id obj))callback;

/**
 *认证刷新
 */
- (void)OAuthAuthorizationUpdateWithclient_id:(NSString *)client_id
                                compact:(NSString *)compact
                          client_secret:(NSString *)client_secret
                                   code:(NSString *)code
                             grant_type:(NSString *)grant_type
                           redirect_uri:(NSString *)redirect_uri
                          refresh_token:(NSString *)refresh_token
                               callback:(void(^)(id obj))callback;

/**
 *检查最新版本
 */
- (void)inspectAppVersionWithAppDeviceType:(NSString *)deviceType Callback:(void(^)(id obj))callback ;

- (void)JiangXiBankDepositoryNoticeWithCallback:(void(^)(id obj))callback;

//银子商城兑换记录
- (void)silverTraderExchangerRecordcustomerId:(NSString *)customerId
                                      page:(int)page
                   callback:(void(^)(id obj))callback;
//银子商城赚银子
- (void)silverTraderEarnSilverCallback:(void(^)(id obj))callback;

//银子商城分享赚银子
- (void)silverTraderShareEarnSilvercustomerId:(NSString *)customerId callback:(void(^)(id obj))callback;

//0元夺宝首界面
- (void)zeroMoneyFirstPage:(int)page callback:(void(^)(id obj))callback;
//活动专区界面
- (void)activityZoonWithPage:(int)page
                        size:(int)size
                    callback:(void(^)(id obj))callback;
//启动图加载
- (void)startPicturePixels:(NSInteger)Pixels callback:(void(^)(id obj))callback;

//回款日历信息
- (void)requestPaymentCalendarDataWithcustomerId:(NSString *)customerId
                                     paybackMonth:(NSString *)paybackMonth
                                        callback:(void(^)(id obj))callback;

//第三方授权登录 authorisation/login
- (void)thirdAuthorisationLoginCategory:(NSString *)category
                                 openId:(NSString *)openId
                               nickName:(NSString *)nickName
                                headImg:(NSString *)headImg
                               callback:(void(^)(id obj))callback;

//第三方授权登录 绑定手机号(已注册)
- (void)thirdAuthorisationLoginWithCustomerCellphone:(NSString *)cellphone
                                            password:(NSString *)password
                                            category:(NSString *)category
                                              openId:(NSString *)openId
                                            nickName:(NSString *)nickName
                                             headImg:(NSString *)headImg
                                               login:(NSString *)login
                                           callback:(void (^)(id obj))callback;

//第三方授权登录 绑定手机号(未注册)
- (void)thirdAuthorisationLoginWithUesrCellphone:(NSString *)cellphone
                                            code:(NSString *)code
                                        category:(NSString *)category
                                       channelId:(NSString *)channelId
                                          openId:(NSString *)openId
                                        nickName:(NSString *)nickName
                                         headImg:(NSString *)headImg
                                      deviceUUID:(NSString *)deviceUUID
                                        callback:(void (^)(id obj))callback;
//回款短信通知
- (void)paybackSmsResultWithcustomerId:(NSString *)customerId
                                  flag:(NSString *)flag
                              callback:(void(^)(id obj))callback;

//账号绑定
- (void)customerAuthorisationMessageWithcustomerId:(NSString *)customerId
                                       callback:(void(^)(id obj))callback;

//优惠券转赠
- (void)couponGiveToOneWithcustomerId:(NSString *)customerId
                     customerCouponId:(NSString *)customerCouponId
                            cellphone:(NSString *)cellphone
                             callback:(void(^)(id obj))callback;

/**
 *理财专栏
 */
- (void)finaacialColumnListWithPage:(int)page
                           callback:(void(^)(id obj))callback;

/**
 *绑定银行卡
 */
- (void)bindingBankCardWithCustomerId:(NSString *)customerId
                              cardNo:(NSString *)cardNo
                             smsCode:(NSString *)smsCode
                             channel:(NSString *)channel
                            authCode:(NSString *)authCode
                            callback:(void(^)(id obj))callback;

/**
 *获取MD5-key
 */
- (void)requestSendSMSMD5KEYWithCallback:(void(^)(id obj))callback;

/**
 *获取交易明细数据
 */
- (void)requestExchageDetailWithCustomerId:(NSString *)customerId
                                      type:(int)type
                                      page:(int)page
                                   history:(int)history
                                    mobile:(int)mobile
                                 startDate:(NSString *)startDate
                                   endDate:(NSString *)endDate
                                  callback:(void(^)(id obj))callback;

/**
 *获取江西银行短信验证码
 */
- (void)requestJXBankSmsCodeWithCellphone:(NSString *)cellphone
                              serviceCode:(NSString *)serviceCode
                                  channel:(NSString *)channel
                                 callback:(void(^)(id obj))callback;

/**
 *获取充值界面短信验证码
 */
- (void)requestRechargeSmsCodeWithUserId:(NSString *)userId
                               cellphone:(NSString *)cellphone
                                 channel:(NSString *)channel
                                callback:(void((^))(id obj))callback;

/**
 *开户
  */
- (void)requestOpenAmountOfJXWithCellphone:(NSString *)cellphone
                                    idcard:(NSString *)idcard
                                   channel:(NSString *)channel
                                      name:(NSString *)name
                                    cardNO:(NSString *)cardNO
                                  authCode:(NSString *)authCode
                                   smsCode:(NSString *)smsCode
                                  callback:(void(^)(id obj))callback;


- (void)requestQuickPaymentWithCustomerId:(NSString *)customerId
                                  channel:(NSString *)channel
                                 txAmount:(NSString *)txAmount
                                     type:(NSString *)type
                                  smsCode:(NSString *)smsCode
                                 authCode:(NSString *)authCode
                                cellphone:(NSString *)cellphone
                                 callback:(void(^)(id obj))callback;

- (void)requestUserBalanceAmountWithCustomerId:(NSString *)customerId
                                       channel:(NSString *)channel
                                      callback:(void(^)(id obj))callback;

- (void)requsetRelieveBankCardWithCustomerId:(NSString *)customerId
                                      cardNo:(NSString *)cardNo
                                     channel:(NSString *)channel
                                    callback:(void(^)(id obj))callback;

- (void)requestBankLinenoWithCardNO:(NSString *)cardNO
                           callback:(void(^)(id obj))callback;

- (void)requestFreeTimesWithCustomerId:(NSString *)customerId
                              callback:(void(^)(id obj))callback;

- (void)requsetPaymentsWithdrawWithCustomerId:(NSString *)customerId
                                    accountId:(NSString *)accountId
                                      provinceBankNO:(NSString *)provinceBankNO
                                       cardNO:(NSString *)cardNO
                                    principal:(NSString *)principal
                                      channel:(NSString *)channel
                                detailChannel:(NSString *)detailChannel
                                     callback:(void(^)(id obj))callback;

- (void)requestConfirmationProductInfoWithCustomerId:(NSString *)customerId
                                                name:(NSString *)name
                                              idcard:(NSString *)idcard
                                             channel:(NSString *)channel
                                           accountId:(NSString *)accountId
                                           productId:(NSString *)productId
                                           principal:(NSString *)principal
                                    customerCouponId:(NSString *)customerCouponId
                                       detailChannel:(NSString *)detailChannel
                                            callback:(void(^)(id obj))callback;

- (void)requestSilverGoodsDataWithCallback:(void(^)(id obj))callback;

/**
 *是否设置交易密码
 */
- (void)requestWhetherSetUpTradePasswordAccountId:(NSString *)accountId
                                         callback:(void(^)(id obj))callback;

/**
 *返利活动
 */
- (void)requestRebateActivitiesWithProductId:(NSString *)productId
                                    callback:(void(^)(id obj))callback;
/**
 *首页悬浮按钮
 */
- (void)requestIsSuspendShowWithCategory:(NSString *)category
                                callback:(void(^)(id obj))callback;

/**
 *获取补签卡列表
 */
- (void)requestRetroactiveCardListWithCusstomerId:(NSString *)customerId Callback:(void(^)(id obj))callback;

/**
 *产品详情vip加息及银子商城折扣
 */
- (void)requestProductDetailAndSilverStoreCouponWithCustomerId:(NSString *)customerId
                                                          type:(NSString *)type
                                                      callback:(void(^)(id obj))callback;

/**
 *获取VIP福利
 */
- (void)requestMemberPrivilegesWithType:(NSString *)type Callback:(void(^)(id obj))callback;

/**
 *获取待收本金
 */

- (void)requestCollectingOfThePrincipalWithCustomerId:(NSString *)customerId Callback:(void(^)(id obj))callback;


@end
