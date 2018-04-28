//
//  FinancialColumnCell.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/1/3.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "FinancialColumnCell.h"
#import "UILabel+LabelStyle.h"
#import "UIImageView+WebCache.h"


@implementation FinancialColumnCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor backgroundGrayColor];
        UIView *backView = [[UIView alloc] init];
        [self addSubview:backView];
        backView.backgroundColor = [UIColor whiteColor];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_top).offset(10);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        _contentImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AdvertDefault.png"]];
        [backView addSubview:_contentImage];
        [_contentImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.mas_centerY);
            make.top.equalTo(self.mas_top).offset(20);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
            make.width.equalTo(@105);
        }];
        
        _contentNameLB = [[UILabel alloc] init];
        [backView addSubview:_contentNameLB];
        _contentNameLB.numberOfLines = 2;
        [_contentNameLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:14] characterColor:[UIColor characterBlackColor]];
        [_contentNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentImage.mas_right).offset(15);
            make.top.equalTo(_contentImage.mas_top);
            make.height.equalTo(@40);
            make.right.equalTo(self.mas_right).offset(-15);
        }];
        
        _contentSummaryLB = [[UILabel alloc] init];
        [backView addSubview:_contentSummaryLB];
        _contentSummaryLB.numberOfLines = 2;
        _contentSummaryLB.font = [UIFont systemFontOfSize:11];
        _contentSummaryLB.textColor = [UIColor typefaceGrayColor];
        [_contentSummaryLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentImage.mas_right).offset(15);
            make.bottom.equalTo(_contentImage.mas_bottom);
            make.height.equalTo(@30);
            make.right.equalTo(self.mas_right).offset(-15);
        }];
    }
    return self;
}

- (void)showFinancialColumnList:(FinancialColumnModel *)dic
{
    //给图片赋值
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",dic.imageUrl]];
    [self.contentImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"AdvertDefault.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //当网络请求到图片时, 会执行此block回调方法
        self.contentImage.image = image;
    }];
    _contentNameLB.text = dic.title;
    _contentSummaryLB.text = dic.remark;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
