//
//  SignInTimesModel.h
//  SilverFoxWealth
//
//  Created by SilverFox on 16/7/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface SignInTimesModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *signTime;

@end
