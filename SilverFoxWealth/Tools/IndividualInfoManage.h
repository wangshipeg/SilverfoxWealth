

#import <Foundation/Foundation.h>
#import "IndividualInfo.h"

@interface IndividualInfoManage : IndividualInfo

/**
 *保存账户
 */
+(void)saveAccount:(IndividualInfoManage *)acc;

/**
 *移除当前账户
 */
+(void)removeAccount;

/**
 *获取当前账户
 */
+(IndividualInfoManage *)currentAccount;

/**
 *更新当前账户
 */
+ (void)updateAccountWith:(IndividualInfoManage *)acc;


@end
