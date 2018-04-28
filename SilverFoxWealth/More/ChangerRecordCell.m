//
//  ChangerRecordCell.m
//  SilverFoxWealth
//
//  Created by SilverFox on 16/7/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ChangerRecordCell.h"
#import "UILabel+LabelStyle.h"
#import "UIImageView+WebCache.h"
#import "DateHelper.h"
#import "StringHelper.h"

@implementation ChangerRecordCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _goodsImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AdvertDefault.png"]];
        [self addSubview:_goodsImage];
        [_goodsImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@60);
            make.height.equalTo(@50);
        }];
        
        _goodsNameLB = [[UILabel alloc] init];
        [self addSubview:_goodsNameLB];
        [_goodsNameLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:14] characterColor:[UIColor characterBlackColor]];
        [_goodsNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_goodsImage.mas_right).offset(10);
            make.top.equalTo(_goodsImage.mas_top);
            make.height.equalTo(@15);
        }];
        
        _changerTimeLB = [[UILabel alloc] init];
        [self addSubview:_changerTimeLB];
        _changerTimeLB.font = [UIFont systemFontOfSize:13];
        _changerTimeLB.textColor = [UIColor depictBorderGrayColor];
        [_changerTimeLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_goodsImage.mas_right).offset(10);
            make.bottom.equalTo(_goodsImage.mas_bottom);
            //make.width.equalTo(@100);
            make.height.equalTo(@15);
        }];
        
        _silverLB = [[UILabel alloc] init];
        [self addSubview:_silverLB];
        _silverLB.font = [UIFont systemFontOfSize:14];
        _silverLB.textAlignment = NSTextAlignmentRight;
        [_silverLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self.mas_centerY);
            //make.width.equalTo(@60);
            make.height.equalTo(@20);
        }];
        
        _changerNum = [[UILabel alloc] init];
        [self addSubview:_changerNum];
        _changerNum.font = [UIFont systemFontOfSize:10];
        _changerNum.textColor = [UIColor zheJiangBusinessRedColor];
        [_changerNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_goodsImage.mas_right).offset(10);
            make.top.equalTo(_goodsNameLB.mas_bottom);
            //make.width.equalTo(@100);
            make.height.equalTo(@20);
        }];
        _copynumBT = [UIButton buttonWithType:UIButtonTypeCustom];

    }
    return self;
}

- (void)clickCopyNumBT:(UIButton *)sender
{
    _copyBlock();
}

- (void)copyNumberBlock:(CopyNumberBlock)copyNumberBlock
{
    _copyBlock = copyNumberBlock;
}

- (void)showExchangerRecordDataWithDic:(ExchangerRecordModel *)dic
{
    self.goodsNameLB.text = dic.goodsName;
    self.changerTimeLB.text = [NSString stringWithFormat:@"兑换时间: %@",dic.exchangeTime];
    self.silverLB.attributedText = [StringHelper renderFrontAndAfterDifferentFontWithValue:@"" frontFont:15 frontColor:[UIColor characterBlackColor] afterStr:[NSString stringWithFormat:@"%@",dic.cost]  afterFont:16 afterColor:[UIColor zheJiangBusinessRedColor] lastStr:@"两" lastFont:16 lastColor:[UIColor characterBlackColor]];
    //给图片赋值
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",dic.url]];
    [self.goodsImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"AdvertDefault.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.goodsImage.image = image;
    }];
    //如果有第三方兑换码 才显示
    if (dic.thirdPartyNO.length > 0) {
        self.changerNum.text = dic.thirdPartyNO;
        //显示复制按钮
        [self addSubview:_copynumBT];
        [_copynumBT setTitle:@"复制" forState:UIControlStateNormal];
        [_copynumBT setTitleColor:[UIColor iconBlueColor] forState:UIControlStateNormal];
        _copynumBT.titleLabel.font = [UIFont systemFontOfSize:14];
        [_copynumBT addTarget:self action:@selector(clickCopyNumBT:) forControlEvents:UIControlEventTouchUpInside];
        [_copynumBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_changerNum.mas_right).offset(5);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@30);
            make.height.equalTo(@20);
        }];
    }
}

@end


