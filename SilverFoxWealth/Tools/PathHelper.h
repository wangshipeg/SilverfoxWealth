//
//  PathHelper.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/4/14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PathHelper : NSObject

+(NSString *)documentDirectoryPathWithName:(NSString *)name;
+(NSString *)cacheDirectoryPathWithName:(NSString *)name;

@end
