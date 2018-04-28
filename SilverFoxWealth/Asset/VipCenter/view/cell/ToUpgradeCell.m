//
//  ToUpgradeCell.m
//  SilverFoxWealth
//
//  Created by 丿Love_wcx丶灬丨 紫軒 on 2018/4/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ToUpgradeCell.h"

@implementation ToUpgradeCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor backgroundGrayColor];
        [self addSubview:self.toUpgradeBtn];
        [self.toUpgradeBtn addTarget:self action:@selector(toUpgradeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.toUpgradeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(0*default_scale);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.width.mas_equalTo(210*default_scale);
            make.height.mas_equalTo(34*default_scale);
        }];
        
    }
    return self;
}

- (void)toUpgradeBtnClick {
    if (self.clickCallBack) {
        self.clickCallBack();
    }
    
}

- (UIButton *)toUpgradeBtn {
    if (!_toUpgradeBtn) {
        _toUpgradeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _toUpgradeBtn.layer.masksToBounds = YES;
        _toUpgradeBtn.layer.cornerRadius = 5;
        [_toUpgradeBtn setTitle:@"立即升级" forState:UIControlStateNormal];
        [_toUpgradeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _toUpgradeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _toUpgradeBtn.backgroundColor = [UIColor colorWithRed:205.0f/255.0f green:177.0f/255.0f blue:126.0f/255.0f alpha:1.0f];
    }
    return _toUpgradeBtn;
}
@end
