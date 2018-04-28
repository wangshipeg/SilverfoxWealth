
#import "ViewModelClass.h"
#import "NetRequestClass.h"

@implementation ViewModelClass

#pragma 获取网络可到达状态//在这里处理断网情况下,页面布置
-(void) netWorkStateWithNetConnectBlock: (NetWorkBlock) netConnectBlock WithURlStr: (NSString *) strURl;
{
    [[NetRequestClass sharedClient] isReachability:^(BOOL isNet) {
        netConnectBlock(isNet);
    } urlStr:strURl];
}

#pragma 接收穿过来的block
-(void) setBlockWithReturnBlock: (ReturnValueBlock) returnBlock
                 WithErrorBlock: (ErrorCodeBlock) errorBlock
               WithFailureBlock: (FailureBlock) failureBlock
{
    _returnBlock = returnBlock;
    _errorBlock = errorBlock;
    _failureBlock = failureBlock;
}

@end
