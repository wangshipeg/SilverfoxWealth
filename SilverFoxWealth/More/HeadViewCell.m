//
//  HeadViewCell.m
//  SilverFoxWealth
//
//  Created by SilverFox on 16/3/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "HeadViewCell.h"
#import "UILabel+LabelStyle.h"
#import "TopBottomBalckBorderView.h"
#import "UMMobClick/MobClick.h"
@implementation HeadViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _bannerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width * 140 / 375)];
        _bannerImage.image = [UIImage imageNamed:@"AdvertDefault.png"];
        [self addSubview:_bannerImage];
        _bannerImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [_bannerImage addGestureRecognizer:tapGesture];
        
        UIView *topView = [[UIView alloc] init];
        topView.backgroundColor = [UIColor whiteColor];
        [self addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@50);
            make.top.equalTo(_bannerImage.mas_bottom);
        }];
        
        _headLB = [[UILabel alloc] init];
        _headLB.font = [UIFont systemFontOfSize:16];
        _headLB.frame = CGRectMake(15, 10, 200, 30);
        [topView addSubview:_headLB];
        
        _headBT = [RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
        _headBT.backgroundColor=[UIColor iconBlueColor];
        _headBT.titleLabel.font=[UIFont systemFontOfSize:15];
        _headBT.titleLabel.textColor = [UIColor whiteColor];
        [_headBT addTarget:self action:@selector(clickChangerRecord:) forControlEvents:UIControlEventTouchUpInside];
        _headBT.frame = CGRectMake(self.frame.size.width - 95, 10, 80, 30);
        [topView addSubview:_headBT];
        
        TopBottomBalckBorderView *headView = [[TopBottomBalckBorderView alloc] init];
        headView.backgroundColor = [UIColor backgroundGrayColor];
        [self addSubview:headView];
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@37);
            make.top.equalTo(topView.mas_bottom).offset(-1);
        }];
        
        _goodsNameLB = [[UILabel alloc] init];
        _goodsNameLB.font = [UIFont systemFontOfSize:16];
        _goodsNameLB.frame = CGRectMake(15, 10, 100, 25);
        _goodsNameLB.text = @"尖货专区";
        _goodsNameLB.textColor = [UIColor characterBlackColor];
        _goodsNameLB.font = [UIFont systemFontOfSize:14];
        [headView addSubview:_goodsNameLB];
        
        _moreBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreBT.titleLabel.font=[UIFont systemFontOfSize:13];
        _moreBT.titleLabel.textColor = [UIColor iconBlueColor];
        [_moreBT addTarget:self action:@selector(clickMoreBt:) forControlEvents:UIControlEventTouchUpInside];
        _moreBT.titleLabel.textAlignment = NSTextAlignmentRight;
        _moreBT.contentMode=UIViewContentModeScaleAspectFit;
        [_moreBT setImage:[UIImage imageNamed:@"AllowRight.png"] forState:UIControlStateNormal];
        [_moreBT setTitleColor:[UIColor iconBlueColor] forState:UIControlStateNormal];
        [headView addSubview:_moreBT];
        [_moreBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(headView.mas_right);
            make.top.equalTo(headView.mas_top).offset(10);
            make.width.equalTo(@40);
            make.height.equalTo(@25);
        }];
    }
    return self;
}

//- (void)layoutSubviews{
//    self.headLB.frame = CGRectMake(15, 0, 200, self.frame.size.height);
//}

- (void)logInWith:(LogInBlock)lgBlock{
    _loginBlock=lgBlock;
}

- (void)userSilverNumWith:(UserSilverNumBlock)siverNumBlock
{
    _silverNum = siverNumBlock;
}
- (void)moreGoodsWith:(MoreGoodsBlock)goodsBlock
{
    [MobClick event:@"silver_store_condition_more"];
    _goodsBlock = goodsBlock;
}
- (void)bannerImageWith:(BannerImageBlock)bannerBlock
{
    _bannerBlock = bannerBlock;
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender
{
    _bannerBlock();
}

- (void)clickChangerRecord:(RoundCornerClickBT *)sender
{
    _silverNum();
}
- (void)clickMoreBt:(UIButton *)sender
{
    _goodsBlock();
}

- (void)logIn:(UIButton *)sender {
    _loginBlock();
}


@end
