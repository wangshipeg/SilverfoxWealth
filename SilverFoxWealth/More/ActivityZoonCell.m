//
//  ActivityZoonCell.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2016/10/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ActivityZoonCell.h"

@implementation ActivityZoonCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _phoneImg = [[UIImageView alloc] init];
        _phoneImg.frame = CGRectMake(15, 0, self.frame.size.width - 30, self.frame.size.height - 30);
        [self.contentView addSubview:_phoneImg];
        
        _viewAlpha = [[UIView alloc] init];
        _viewAlpha.backgroundColor = [UIColor characterBlackColor];
        _viewAlpha.frame = CGRectMake(0, 0, self.frame.size.width - 30, self.frame.size.height - 30);
        [_phoneImg addSubview:_viewAlpha];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"已结束.png"]];
        imgView.center = CGPointMake(_viewAlpha.frame.size.width / 2, _viewAlpha.frame.size.height / 2);
        [_viewAlpha addSubview:imgView];
        
        _nameLB = [[UILabel alloc] init];
        _nameLB.textColor = [UIColor characterBlackColor];
        _nameLB.font = [UIFont systemFontOfSize:13];
        _nameLB.frame = CGRectMake(15, self.frame.size.height - 22, 250, 15);
        _nameLB.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_nameLB];
        
        _statusLB = [[UILabel alloc] init];
        _statusLB.textColor = [UIColor zheJiangBusinessRedColor];
        _statusLB.font = [UIFont systemFontOfSize:13];
        _statusLB.frame = CGRectMake(self.frame.size.width - 60, self.frame.size.height - 22, 45, 15);
        [self.contentView addSubview:_statusLB];
        
    }
    return self;
}

@end
