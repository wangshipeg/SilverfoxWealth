//
//  RefinedAdvertView.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/7/22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "RefinedAdvertView.h"
#import "RecommendAdvertModel.h"
#import <UIImageView+WebCache.h>
#import "UMMobClick/MobClick.h"
#import "UserDefaultsManager.h"

@implementation RefinedAdvertView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _advertBackSV=[[SDCycleScrollView alloc] init];
        [self addSubview:_advertBackSV];
        _advertBackSV.placeholderImage = [UIImage imageNamed:@"AdvertDefault.png"];
        [_advertBackSV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.bottom.equalTo(self.mas_bottom);
            make.right.equalTo(self.mas_right);
        }];
    }
    return self;
}


@end
