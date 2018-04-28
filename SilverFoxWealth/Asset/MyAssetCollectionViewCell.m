//
//  MyAssetCollectionViewCell.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2018/4/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MyAssetCollectionViewCell.h"
#import "StringHelper.h"

@implementation MyAssetCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 10, 23.5, 28, 28)];
        [self addSubview:_imageView];
        
        _textLB = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 3.3, 20, self.frame.size.width / 4 * 3, 17.5)];
        [_textLB decorateLabelStyleWithCharacterFont:[UIFont fontWithName:@"Helvetica" size:15] characterColor:[UIColor characterBlackColor]];
        [self addSubview:_textLB];
        
        _viceNameLB = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 3.3, 37.5, self.frame.size.width / 4 * 3, 17.5)];
        [_viceNameLB decorateLabelStyleWithCharacterFont:[UIFont fontWithName:@"Helvetica" size:13] characterColor:[UIColor depictBorderGrayColor]];
        [self addSubview:_viceNameLB];
        
//        [_textLB mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.mas_centerX);
//            make.centerY.equalTo(self.mas_centerY);
//            make.height.equalTo(@75);
//            //make.width.equalTo(@100);
//        }];
    }
    return self;
}
- (void)assetCellContentWith:(NSDictionary *)dic
{
    _imageView.image = [UIImage imageNamed:dic[@"imageName"]];
    _viceNameLB.text = dic[@"viceName"];
    if ([dic[@"name"] isEqualToString:@"会员中心"]) {
        _textLB.attributedText = [StringHelper renderImageAndTextWithValue:[NSString stringWithFormat:@"会员中心 "] valueFont:15 valueColor:[UIColor characterBlackColor] image:[UIImage imageNamed:@"vipCenterNew.png"] imageFrame:CGRectMake(0, -2, 30, 15) index:5];
    } else {
        _textLB.text = dic[@"name"];
    }
}

@end
