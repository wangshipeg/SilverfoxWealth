//
//  CollectPrincipalCell.m
//  SilverFoxWealth
//
//  Created by 丿Love_wcx丶灬丨 紫軒 on 2018/4/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CollectPrincipalCell.h"

@implementation CollectPrincipalCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.collectPrincipalLabel];
        [self addSubview:self.bannerView];
        
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        
        [self.collectPrincipalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 154*default_scale, 0));
        }];
        
        [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(60*default_scale, 0, 15*default_scale, 0));
        }];
    }
    return self;
}

#pragma mark ——— getter
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor backgroundGrayColor];
    }
    return _bgView;
}

- (UILabel *)collectPrincipalLabel {
    if (!_collectPrincipalLabel) {
        _collectPrincipalLabel = [[UILabel alloc] init];
        _collectPrincipalLabel.font = [UIFont systemFontOfSize:14];
        _collectPrincipalLabel.textColor = [UIColor depictBorderGrayColor];
        _collectPrincipalLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _collectPrincipalLabel;
}

- (VipBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[VipBannerView alloc] init];
    }
    return _bannerView;
}

@end
