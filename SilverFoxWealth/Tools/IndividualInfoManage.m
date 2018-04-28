

#import "IndividualInfoManage.h"
#import "PathHelper.h"
#import <objc/runtime.h>


static IndividualInfoManage *account;

@implementation IndividualInfoManage

+(NSString *)getAccountsStroagePath {
    
    NSString *path=[[PathHelper documentDirectoryPathWithName:@"db"] stringByAppendingPathComponent:@"accounts"];
    return path;
}

+(void)loadAccount {
    account=[NSKeyedUnarchiver unarchiveObjectWithFile:[self getAccountsStroagePath]];
}

+(void)saveAccount:(IndividualInfoManage *)acc {
    [NSKeyedArchiver archiveRootObject:acc toFile:[self getAccountsStroagePath]];
    account = acc;
}

+(void)removeAccount{
    if (account) {
        account = Nil;
        [self saveAccount:account];
    }
}

+(IndividualInfoManage *)currentAccount {
    if (!account) {
        [self loadAccount];
    }
    return account;
}


+ (void)updateAccountWith:(IndividualInfoManage *)acc  {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self removeAccount];
            [self saveAccount:acc];
    });
    
}


@end
