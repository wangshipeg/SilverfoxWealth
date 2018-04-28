//
//  ZeroMoneyIndianaViewCell.m
//  SilverFoxWealth
//
//  Created by SilverFox on 16/6/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZeroMoneyIndianaViewCell.h"
#import "CalculateProductInfo.h"
#import "UIImageView+WebCache.h"
#import "StringHelper.h"

@implementation ZeroMoneyIndianaViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor backgroundGrayColor];
        UIView *backView = [[UIView alloc] init];
        [self addSubview:backView];
        backView.backgroundColor = [UIColor whiteColor];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
        }];
        
        _phoneImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AdvertDefault.png"]];
        [backView addSubview:_phoneImg];
        if ([ UIScreen mainScreen].bounds.size.width == 414) {
            [_phoneImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(backView.mas_left).offset(15);
                make.right.equalTo(backView.mas_right).offset(-15);
                make.top.equalTo(backView.mas_top);
                make.height.equalTo(@(384 * 165 / 375));
            }];
        }else if ([ UIScreen mainScreen].bounds.size.width == 320) {
            [_phoneImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(backView.mas_left).offset(15);
                make.right.equalTo(backView.mas_right).offset(-15);
                make.top.equalTo(backView.mas_top);
                make.height.equalTo(@(290 * 161 / 375));
            }];
        }else{
            [_phoneImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(backView.mas_left).offset(15);
                make.right.equalTo(backView.mas_right).offset(-15);
                make.top.equalTo(backView.mas_top);
                make.height.equalTo(@(345 * 164 / 375));
            }];
        }
        
        _viewAlpha = [[UIView alloc] init];
        _viewAlpha.backgroundColor = [UIColor characterBlackColor];
        [_phoneImg addSubview:_viewAlpha];
        [_viewAlpha mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.phoneImg.mas_left);
            make.right.equalTo(self.phoneImg.mas_right);
            make.top.equalTo(self.phoneImg.mas_top);
            make.bottom.equalTo(self.phoneImg.mas_bottom);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"已开奖.png"]];
        [_viewAlpha addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.viewAlpha.mas_centerX);
            make.centerY.equalTo(self.viewAlpha.mas_centerY);
        }];
        
        _nameLB = [[UILabel alloc] init];
        _nameLB.textColor = [UIColor characterBlackColor];
        _nameLB.font = [UIFont systemFontOfSize:13];
        _nameLB.frame = CGRectMake(15, self.frame.size.height - 25, 150, 20);
        _nameLB.adjustsFontSizeToFitWidth = YES;
        [backView addSubview:_nameLB];
        [_nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView.mas_left).offset(15);
            make.top.equalTo(self.phoneImg.mas_bottom).offset(5);
            make.height.equalTo(@20);
        }];
        
        _statusLB = [[UILabel alloc] init];
        _statusLB.textColor = [UIColor zheJiangBusinessRedColor];
        _statusLB.textAlignment = NSTextAlignmentRight;
        _statusLB.font = [UIFont systemFontOfSize:13];
        [backView addSubview:_statusLB];
        [_statusLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backView.mas_right).offset(-15);
            make.top.equalTo(self.phoneImg.mas_bottom).offset(5);
            make.height.equalTo(@20);
        }];
        
        _residueLB = [[UILabel alloc] init];
        _residueLB.font = [UIFont systemFontOfSize:13];
        _residueLB.textAlignment = NSTextAlignmentRight;
        [backView addSubview:_residueLB];
        [_residueLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backView.mas_right).offset(-15);
            make.top.equalTo(self.statusLB.mas_bottom).offset(2);
            make.height.equalTo(@20);
        }];
        
        _purchasePregress=[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _purchasePregress.trackTintColor=[UIColor typefaceGrayColor];
        _purchasePregress.progressTintColor=[UIColor zheJiangBusinessRedColor];
        _purchasePregress.transform = CGAffineTransformMakeScale(1.0f, 2.0f);//改变进度条的高度
        _purchasePregress.layer.cornerRadius = 2;
        _purchasePregress.layer.masksToBounds = YES;
        [backView addSubview:_purchasePregress];
        [_purchasePregress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameLB.mas_bottom).offset(11);
            make.right.equalTo(backView.mas_right).offset(-90);
            make.left.equalTo(backView.mas_left).offset(15);
            make.height.equalTo(@3);
        }];

    }
    return self;
}

- (void)showIndinanPageWith:(ZeroIndianaModel *)dic
{
    self.nameLB.text = dic.goodsName;
    if ([dic.stock intValue] - [dic.joinNum intValue] < 1) {
        self.residueLB.attributedText = nil;
    }else{
        self.residueLB.attributedText = [StringHelper renderFrontAndAfterDifferentFontWithValue:@"差" frontFont:13 frontColor:[UIColor characterBlackColor] afterStr:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%d",[dic.stock intValue] - [dic.joinNum intValue]]]  afterFont:13 afterColor:[UIColor zheJiangBusinessRedColor] lastStr:@"份" lastFont:13 lastColor:[UIColor characterBlackColor]];
    }
    //给图片赋值
    NSURL *url = [NSURL URLWithString:dic.url];
    [self.phoneImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"AdvertDefault.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.phoneImg.image = image;
    }];
    if ([dic.stock integerValue] > [dic.joinNum integerValue]) {
        self.statusLB.attributedText = [StringHelper renderFrontAndAfterDifferentFontWithValue:@"" frontFont:13 frontColor:[UIColor characterBlackColor] afterStr:[NSString stringWithFormat:@"%@",dic.consumeSilver]  afterFont:13 afterColor:[UIColor zheJiangBusinessRedColor] lastStr:@"两/次" lastFont:13 lastColor:[UIColor characterBlackColor]];
        self.viewAlpha.alpha = 0;
        self.purchasePregress.hidden = NO;
        self.purchasePregress.progress=[[CalculateProductInfo calculateZeroChangeProgressWith:dic] doubleValue];
        [self.purchasePregress setProgress:self.purchasePregress.progress animated:YES];
    }
    else
    {
        self.statusLB.text = @"已开奖";
        self.viewAlpha.alpha = 0.5;
        self.purchasePregress.hidden = YES;
    }
}

@end


