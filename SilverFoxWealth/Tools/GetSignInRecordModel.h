//
//  GetSignInRecordModel.h
//  SilverFoxWealth
//
//  Created by SilverFox on 16/7/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface GetSignInRecordModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *recordIdStr;

@end
