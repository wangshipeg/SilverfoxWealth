//
//  MembershipBenefitsCell.m
//  SilverFoxWealth
//
//  Created by 丿Love_wcx丶灬丨 紫軒 on 2018/4/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MembershipBenefitsCell.h"
#import "IndividualInfoManage.h"

@implementation MembershipBenefitsCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconImgView];
        [self addSubview:self.titleLabel];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).with.offset(15*default_scale);
            make.centerX.mas_equalTo(self.mas_centerX);
//            make.centerY.mas_equalTo(self.mas_centerY).with.offset(-5*default_scale);
            make.size.mas_equalTo(CGSizeMake(44*default_scale, 44*default_scale));
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.iconImgView.mas_bottom).with.offset(10*default_scale);
            make.left.mas_equalTo(self);
            make.right.mas_equalTo(self);
            make.height.mas_equalTo(16*default_scale);
        }];
    }
    return self;
}

- (void)setKeyWord:(NSString *)keyWord {
    _keyWord = keyWord;
}

- (void)setKeyWord1:(NSString *)keyWord1 {
    _keyWord1 = keyWord1;
}

- (void)setCellIndex:(NSInteger)cellIndex {
    _cellIndex = cellIndex;
}

- (void)setLevel:(NSInteger)level {
    _level = level;
}
- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    NSArray *iconArray = @[@"withdrawals", @"brithday", @"patch_card", @"coupon", @"discount", @"adviser", @"interest", @"bill", @"forward"];
    NSArray *no_iconArray = @[@"withdrawals_no", @"brithday_no", @"patch_card_no", @"coupon_no", @"discount_no", @"adviser_no", @"interest_no", @"bill_no", @"forward_no"];
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:_dict[_keyWord]];
    self.isFree = NO;
    for (NSDictionary *obj in array) {
        NSString *level = obj[@"level"];
        if ([level integerValue] == self.level) {
            if ([_keyWord1 isEqualToString:@"count"] || [_keyWord1 isEqualToString:@"isExist"]) {
                if ([obj[_keyWord1] isEqualToString:@"0"]) {
                    self.isFree = NO;
                }else {
                    self.isFree = YES;
                }
            }
            if ([_keyWord1 isEqualToString:@"money"]) {
                double b = 0.0;
                if ([obj[_keyWord1] doubleValue] == b) {
                    self.isFree = NO;
                }else {
                    self.isFree = YES;
                }
            }
            if ([_keyWord1 isEqualToString:@"rate"]) {
                double b = 0.0;
                if ([_keyWord isEqualToString:@"discount"]) {
                    b = 10.0;
                }
                if ([obj[_keyWord1] doubleValue] == b) {
                    self.isFree = NO;
                }else {
                    self.isFree = YES;
                }
            }
            if ([_keyWord1 isEqualToString:@"type"]) {
                NSString *type = obj[_keyWord1];
                if (type.length == 0) {
                    self.isFree = NO;
                }else {
                    self.isFree = YES;
                }
            }
        }
    }

    self.iconImgView.image = [UIImage imageNamed:self.isFree ? iconArray[_cellIndex] : no_iconArray[_cellIndex]];
    self.titleLabel.textColor = self.isFree ? [UIColor characterBlackColor] : [UIColor depictBorderGrayColor];
    if (_cellIndex == 8) {
        self.iconImgView.image = [UIImage imageNamed:@"forward_no"];
        self.titleLabel.textColor = [UIColor depictBorderGrayColor];
    }
}

#pragma mark ——— getter

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}

- (UIImageView *)subIconImgView {
    if (!_subIconImgView) {
        _subIconImgView = [[UIImageView alloc] init];
    }
    return _subIconImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor characterBlackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)subLabel {
    if (!_subLabel) {
        _subLabel = [[UILabel alloc] init];
    }
    return _subLabel;
}

@end
