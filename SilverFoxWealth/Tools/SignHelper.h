//
//  SignHelper.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/8/14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignHelper : NSObject

+ (NSString *)partnerSignOrder:(NSDictionary *)paramDic sig:(NSString *)sig;


@end
