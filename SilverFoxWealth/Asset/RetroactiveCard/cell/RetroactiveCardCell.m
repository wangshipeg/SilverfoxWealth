//
//  RetroactiveCardCell.m
//  SilverFoxWealth
//
//  Created by 丿Love_wcx丶灬丨 紫軒 on 2018/4/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "RetroactiveCardCell.h"

@implementation RetroactiveCardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.contentView addSubview:self.bgImgView];
        [self.contentView addSubview:self.imgView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.useBtn];
        
        [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
            make.edges.mas_equalTo(UIEdgeInsetsMake(5, 15, 5, 15));
        }];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgImgView.mas_left).with.offset(22);
            make.centerY.mas_equalTo(self.bgImgView);
            make.size.mas_equalTo(CGSizeMake(35, 35));
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgView.mas_top).with.offset(-5);
            make.left.equalTo(self.imgView.mas_right).with.offset(5);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(18);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.left.equalTo(self.titleLabel.mas_left);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(16);
        }];
        [self.useBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bgImgView.mas_right).with.offset(-15);
            make.centerY.mas_equalTo(self.bgImgView);
            make.size.mas_equalTo(CGSizeMake(71, 28));
        }];
    }
    return self;
}

- (void)setModel:(RetroactiveCardModel *)model {
    _model = model;
    NSArray *array = [_model.expireTime componentsSeparatedByString:@"-"];
    self.timeLabel.text = [NSString stringWithFormat:@"有效期：至%@年%@月%@日",array[0],array[1],array[2]];
}

#pragma mark ——— getter

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        _imgView.backgroundColor = [UIColor redColor];
    }
    return _imgView;
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        _bgImgView.backgroundColor = [UIColor cyanColor];
    }
    return _bgImgView;
}

- (UILabel *)titleLabel {
    if (!_timeLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"补签卡";
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.font = [UIFont systemFontOfSize:13];
    }
    return _timeLabel;
}

- (UIButton *)useBtn {
    if (!_useBtn) {
        _useBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_useBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_useBtn setTitle:@"立即使用" forState:UIControlStateNormal];
        [_useBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _useBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _useBtn;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
