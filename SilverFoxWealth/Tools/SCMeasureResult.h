//
//  SCMeasureResult.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/7/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCMeasureDump.h"


typedef struct _scResultFunc {
    BOOL (*isRightSignStr)(NSString *keyStr,NSString *signStr);
}SCMeasureResult_t;

#define SHARE_SCMEASURERESULT ([SCMeasureResult shareSCMeasureResult])

@interface SCMeasureResult : NSObject

+ (SCMeasureResult_t *)shareSCMeasureResult;


@end
