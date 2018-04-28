//
//  WithoutAuthorization.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/6/1.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>


@interface WithoutAuthorization : MTLModel<MTLJSONSerializing>
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *error_msg;


@end
