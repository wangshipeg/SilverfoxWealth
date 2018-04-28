

#import "AnewSendBT.h"
#import "CommunalInfo.h"
#import "StringHelper.h"



@implementation AnewSendBT

- (void)drawRect:(CGRect)rect {
    CGSize strSize=[StringHelper achieveStrRuleSizeWith:rect.size targetStr:_titleStr strFont:14];
    [_titleStr drawInRect:CGRectMake((rect.size.width-strSize.width)/2, (CGRectGetHeight(rect)-16)/2, rect.size.width, 16) withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName,[UIColor colorWithRed:203/255. green:203/255. blue:203/255. alpha:1.0],NSForegroundColorAttributeName, nil]];
}


@end
