

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AnewSendBT.h"


@interface DispatchHelper : NSObject

/**
 *重新发送短信通知 button上字符变化控制
 */
+ (void)afreshSendShortMessageWith:(AnewSendBT *)targetBT ;

/**
 *新用户添加银行卡后 进入购买页面就开始计时
 */
+ (void)newUserAddBankCardCountDownWithCallback:(void(^)(BOOL isComplete))callback;

+ (void)newUserCommitOrderNOWithCallback:(void(^)(BOOL isComplete))callback;

@end
