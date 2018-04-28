//
//  FindSIlverGoodsCell.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/1/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "FindSIlverGoodsCell.h"
#import "UILabel+LabelStyle.h"
#import "UIImageView+WebCache.h"

@implementation FindSIlverGoodsCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _phoneImg = [[UIImageView alloc] init];
        _phoneImg.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 50);
        [self.contentView addSubview:_phoneImg];
        
        _alphaGrayView = [[UIView alloc] init];
        _alphaGrayView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 50);
        _alphaGrayView.backgroundColor = [UIColor characterBlackColor];
        _alphaGrayView.alpha = .5;
        [self.phoneImg addSubview:_alphaGrayView];
        
        _discountImgV = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 35, 0, 30, 30)];
        _discountImgV.image = [UIImage imageNamed:@"hot.png"];
        [self.contentView addSubview:_discountImgV];
        
        _discountLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, 30, 15)];
        [_discountLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:11] characterColor:[UIColor whiteColor]];
        _discountLB.textAlignment = NSTextAlignmentCenter;
        _discountLB.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hot.png"]];
        [_discountImgV addSubview:_discountLB];
        
        _nameLB = [[UILabel alloc] init];
        _nameLB.textColor = [UIColor characterBlackColor];
        _nameLB.font = [UIFont systemFontOfSize:14];
        _nameLB.frame = CGRectMake(5, self.frame.size.height - 45, 120, 20);
        _nameLB.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_nameLB];
        
        _silverLB = [[UILabel alloc] init];
        _silverLB.textColor = [UIColor zheJiangBusinessRedColor];
        _silverLB.font = [UIFont systemFontOfSize:13];
        //_silverLB.frame = CGRectMake(5, self.frame.size.height - 25, 80, 20);
        [self.contentView addSubview:_silverLB];
        [_silverLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(5);
            make.top.equalTo(self.nameLB.mas_bottom);
            //make.width.equalTo(@25);
            make.height.equalTo(@20);
        }];
        
        _residueLB = [[UILabel alloc] init];
        _residueLB.textColor = [UIColor zheJiangBusinessRedColor];
        _residueLB.textAlignment = NSTextAlignmentRight;
        _residueLB.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_residueLB];
        [_residueLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.top.equalTo(self.nameLB.mas_bottom);
            //make.width.equalTo(@25);
            make.height.equalTo(@20);
        }];
    }
    return self;
}

- (void)setUpSilverGoodsListData:(FindSilverTraderModel *)dic discountStr:(NSString *)discount
{
    self.nameLB.text = dic.name;
    if ([discount intValue] == 10 || [discount intValue] == 0) {
        self.silverLB.text = [NSString stringWithFormat:@"%@两",dic.consumeSilver];
        if ([dic.stock intValue] <= 0) {
            self.residueLB.text = @"售罄";
            self.residueLB.textColor = [UIColor typefaceGrayColor];
            self.nameLB.textColor = [UIColor typefaceGrayColor];
            self.silverLB.textColor = [UIColor typefaceGrayColor];
            self.alphaGrayView.hidden = NO;
        }else{
            self.residueLB.text = [NSString stringWithFormat:@"剩%@件",dic.stock];
            self.residueLB.textColor = [UIColor zheJiangBusinessRedColor];
            self.nameLB.textColor = [UIColor characterBlackColor];
            self.silverLB.textColor = [UIColor zheJiangBusinessRedColor];
            self.alphaGrayView.hidden = YES;
        }
    }else{
        //只进不舍
        if ([dic.stock intValue] <= 0) {
            self.nameLB.textColor = [UIColor typefaceGrayColor];
            self.silverLB.textColor = [UIColor typefaceGrayColor];
            self.alphaGrayView.hidden = NO;
        }else{
            self.residueLB.text = [NSString stringWithFormat:@"剩%@件",dic.stock];
            self.residueLB.textColor = [UIColor zheJiangBusinessRedColor];
            self.nameLB.textColor = [UIColor characterBlackColor];
            self.silverLB.textColor = [UIColor zheJiangBusinessRedColor];
            self.alphaGrayView.hidden = YES;
        }
    }
    if ([dic.vipDiscount integerValue] == 1 && [discount doubleValue] > 0 && [discount doubleValue] < 10) {
        _discountImgV.hidden = NO;
        _discountImgV.image = [UIImage imageNamed:@"hot.png"];
        _discountLB.hidden = NO;
        _discountLB.text = [NSString stringWithFormat:@"%@折",@((float)[discount doubleValue]).description];
        float newPrice = [dic.consumeSilver intValue] * [discount floatValue] / 10;
        int resultPrice = (int)ceilf(newPrice);
        self.silverLB.text = [NSString stringWithFormat:@"会员价:%d两",resultPrice];
    } else if([dic.vipDiscount integerValue] == 1 && ([discount doubleValue] == 10 || !discount)){
        _discountImgV.hidden = NO;
        _discountImgV.image = [UIImage imageNamed:@"noVipDiscount.png"];
        float newPrice = [dic.consumeSilver intValue];
        int resultPrice = (int)ceilf(newPrice);
        self.silverLB.text = [NSString stringWithFormat:@"%d两",resultPrice];
        _discountLB.hidden = YES;
    }else{
        float newPrice = [dic.consumeSilver intValue];
        int resultPrice = (int)ceilf(newPrice);
        self.silverLB.text = [NSString stringWithFormat:@"%d两",resultPrice];
        _discountLB.hidden = YES;
        _discountImgV.hidden = YES;
    }
    //给图片赋值
    NSURL *url = [NSURL URLWithString:dic.url];
    [self.phoneImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"AdvertDefault.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //当网络请求到图片时, 会执行此block回调方法
        self.phoneImg.image = image;
    }];
}

- (void)silverGoodsOne:(SilverGoodsOneBlock)oneBlock
{
    _oneBlcok = oneBlock;
}

- (void)silverGoodsTwo:(SilverGoodsTwoBlock)twoBlock
{
    _twoBlock = twoBlock;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
