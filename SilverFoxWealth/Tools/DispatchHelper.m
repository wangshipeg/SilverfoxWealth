

#import "DispatchHelper.h"


@implementation DispatchHelper

+ (void)afreshSendShortMessageWith:(AnewSendBT *)targetBT {
    
    __block int timeout = 59 ;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(source, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(source, ^{
        if (timeout<=0) {
            dispatch_source_cancel(source);
            dispatch_async(dispatch_get_main_queue(), ^{
                targetBT.titleStr=nil;
                [targetBT setNeedsDisplay];
                [targetBT setTitle:@"重发" forState:UIControlStateNormal];
                targetBT.userInteractionEnabled=YES;
            });
        }else {
            int seconds=timeout%60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [targetBT setTitle:nil forState:UIControlStateNormal];
                NSString *resultStr=[NSString stringWithFormat:@"重发(%@秒)",strTime];
                targetBT.titleStr=resultStr;
                [targetBT setNeedsDisplay];
                targetBT.userInteractionEnabled=NO;
            });
            timeout--;
        }
    });
    
    dispatch_resume(source);
}

//新用户添加银行卡后 进入购买页面就开始计时
+ (void)newUserAddBankCardCountDownWithCallback:(void(^)(BOOL isComplete))callback {
    
    __block int timeout = 60*4 ;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(source, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(source, ^{
        if (timeout<=0) {
            dispatch_source_cancel(source);
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(YES);
            });
        }else {
            timeout--;
        }
    });
    dispatch_resume(source);
}

//用户排队购买尾单, 如果排上队可以购买就开始计时, 如果两分钟还未购买, 就提示重新排队
+ (void)newUserCommitOrderNOWithCallback:(void(^)(BOOL isComplete))callback
{
    __block int timeout = 60*2 ;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(source, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(source, ^{
        if (timeout<=0) {
            dispatch_source_cancel(source);
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(YES);
            });
        }else {
            timeout--;
        }
    });
    dispatch_resume(source);
}

@end
