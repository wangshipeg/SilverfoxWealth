//
//  MyIndianaCell.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2016/12/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MyIndianaCell.h"

@implementation MyIndianaCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _phoneImg = [[UIImageView alloc] init];
        _phoneImg.frame = CGRectMake(15, 0, self.frame.size.width - 30, self.frame.size.height - 30);
        _phoneImg.image = [UIImage imageNamed:@"AdvertDefault.png"];
        [self.contentView addSubview:_phoneImg];
        
        _viewAlpha = [[UIView alloc] init];
        _viewAlpha.backgroundColor = [UIColor characterBlackColor];
        _viewAlpha.frame = CGRectMake(0, 0, self.phoneImg.frame.size.width, self.frame.size.height - 30);
        [_phoneImg addSubview:_viewAlpha];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"已开奖.png"]];
        imgView.center = CGPointMake(_viewAlpha.frame.size.width / 2, _viewAlpha.frame.size.height / 2);
        [_viewAlpha addSubview:imgView];
        
        _nameLB = [[UILabel alloc] init];
        _nameLB.textColor = [UIColor characterBlackColor];
        _nameLB.font = [UIFont systemFontOfSize:12];
        _nameLB.frame = CGRectMake(15, self.frame.size.height - 20, 150, 20);
        _nameLB.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_nameLB];
        
        _residueLB = [[UILabel alloc] init];
        _residueLB.font = [UIFont systemFontOfSize:13];
        _residueLB.textAlignment = NSTextAlignmentRight;
        _residueLB.frame = CGRectMake(self.frame.size.width - 130, self.frame.size.height - 25, 80, 20);
        [self.contentView addSubview:_residueLB];
        
        _statusLB = [[UILabel alloc] init];
        _statusLB.textColor = [UIColor zheJiangBusinessRedColor];
        _statusLB.textAlignment = NSTextAlignmentRight;
        _statusLB.font = [UIFont systemFontOfSize:13];
        _statusLB.frame = CGRectMake(self.frame.size.width - 70, self.frame.size.height - 20, 55, 20);
        [self.contentView addSubview:_statusLB];
    }
    return self;
}

@end
