//
//  FinancialColumnModel.h
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/1/3.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface FinancialColumnModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type;//1-内部上传 2-外部链接
@property (nonatomic, strong) NSString *imageUrl;//图标地址
@property (nonatomic, strong) NSString *outLink;//外链地址
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) NSString *shareDesc;
@property (nonatomic, strong) NSString *remark;

@end
