

#import "AFHTTPSessionManager.h"
#import "CommunalInfo.h"

@interface NetRequestClass : AFHTTPSessionManager

#pragma 监测网络的可链接性
- (void)isReachability:(void(^)(BOOL isNet))netBlock urlStr:(NSString *)urlStr;

/**
 *与银狐内部对接
 */
+ (instancetype)sharedClient;

- (void)operateSilverFoxDataWith:(NSString *)method
                             url:(NSString *)url
                          params:(NSDictionary *)params
            WithReturnValeuBlock: (ReturnValueBlock) block
              WithErrorCodeBlock: (ErrorCodeBlock) errorBlock
                WithFailureBlock: (FailureBlock) failureBlock;


@end

