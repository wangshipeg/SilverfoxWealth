//
//  SilverGoodsBannerModel.h
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/7/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface SilverGoodsBannerModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString  *link;
@property (nonatomic, strong) NSString  *category;
@property (nonatomic, strong) NSString  *idStr;
@property (nonatomic, strong) NSString  *url;

@end
