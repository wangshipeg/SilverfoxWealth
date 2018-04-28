//
//  VipBannerView.m
//  SilverFoxWealth
//
//  Created by 丿Love_wcx丶灬丨 紫軒 on 2018/4/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "VipBannerView.h"
#import "IndividualInfoManage.h"

@implementation VipBannerViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.vipImgView];
        [self addSubview:self.currentLevelLabel];
        [self addSubview:self.principalLabel];
        
        [self.vipImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        [self.currentLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(60*default_scale);
            make.left.equalTo(self.mas_left).with.offset(111*default_scale);
            make.right.equalTo(self.mas_right).with.offset(-110*default_scale);
            make.height.mas_equalTo(10*default_scale);
        }];
        [self.principalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.currentLevelLabel.mas_bottom).with.offset(16*default_scale);
            make.left.equalTo(self.mas_left).with.offset(20*default_scale);
            make.right.equalTo(self.mas_right).with.offset(-20*default_scale);
            make.height.mas_equalTo(12*default_scale);
        }];

    }
    return self;
}

- (UIImageView *)vipImgView {
    if (!_vipImgView) {
        _vipImgView = [[UIImageView alloc] init];
    }
    return _vipImgView;
}

- (UILabel *)currentLevelLabel {
    if (!_currentLevelLabel) {
        _currentLevelLabel = [[UILabel alloc] init];
        _currentLevelLabel.textColor = [UIColor whiteColor];
        _currentLevelLabel.text = @"当前等级";
        _currentLevelLabel.alpha = 0.6;
        _currentLevelLabel.font = [UIFont systemFontOfSize:9];
    }
    return _currentLevelLabel;
}

- (UILabel *)principalLabel {
    if (!_principalLabel) {
        _principalLabel = [[UILabel alloc] init];
        _principalLabel.textColor = [UIColor whiteColor];
        _principalLabel.font = [UIFont systemFontOfSize:12];
        _principalLabel.text = @"待收本金>50万元";
        _principalLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _principalLabel;
}

@end

@implementation VipBannerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor backgroundGrayColor];
        self.myCarousel = ({
            iCarousel *icarousel = [[iCarousel alloc] init];
            icarousel.dataSource = self;
            icarousel.delegate = self;
            
            icarousel.type = iCarouselTypeCustom;
            icarousel.scrollSpeed = 1.0;
            icarousel.pagingEnabled = YES;
            
            icarousel.decelerationRate = 1.0;
            icarousel.clipsToBounds = YES;
            icarousel.bounceDistance = 0.5;
            
            [self addSubview:icarousel];
            
            [icarousel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
            
            icarousel;
        });
    }
    return self;
}

- (void)setRangeArray:(NSArray *)rangeArray {
    _rangeArray = rangeArray;
    [self.myCarousel reloadData];
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    [self.myCarousel scrollToItemAtIndex:[user.vipLevel integerValue] == 0 ? [user.vipLevel integerValue] : [user.vipLevel integerValue] - 1 animated:NO];
}

#pragma mark - ICarousel 协议
-(NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    if ([user.vipLevel integerValue] == 0) {
        return 1;
    }else {
        return 8;
    }
}

-(UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    
    if (view == nil) {
        view = [[VipBannerViewCell alloc] initWithFrame:CGRectMake(60, 60, 260*default_scale, 130*default_scale)];
    }
    VipBannerViewCell *vipView = (VipBannerViewCell *)view;
    vipView.vipImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"v%ld",index + 1]];
    NSString *str = self.rangeArray[index + 1][@"range"];
    NSArray *strA = [str componentsSeparatedByString:@"-"];
    NSString *str0 = strA[0];
    NSString *str1 = strA[1];
    if (str1.length == 0) {
        str = [str stringByReplacingOccurrencesOfString:@"-" withString:@"万元≤待收本金"];
    }else if (str0.length == 0) {
        str = [str stringByReplacingOccurrencesOfString:@"-" withString:@"待收本金<"];
        str = [NSString stringWithFormat:@"%@万元",str];
    }else {
        str = [str stringByReplacingOccurrencesOfString:@"-" withString:[str0 isEqualToString:@"0"] ? @"万元<待收本金<" : @"万元≤待收本金<"];
        str = [NSString stringWithFormat:@"%@万元",str];
    }
    vipView.principalLabel.text = str;
    
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    if ([user.vipLevel integerValue] == index + 1) {
        vipView.currentLevelLabel.hidden = NO;
    }else {
        vipView.currentLevelLabel.hidden = YES;
    }
    
    if ([user.vipLevel integerValue] == 0) {
        vipView.currentLevelLabel.hidden = YES;
        vipView.principalLabel.hidden = YES;
        vipView.vipImgView.image = [UIImage imageNamed:@"非会员卡"];
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        [vipView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        
        NSString *str = @"您还不是会员\n\n升级领取更多福利";
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:str];
        [attributeString setAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:18]} range:NSMakeRange(0, 6)];
        [attributeString setAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:15]} range:NSMakeRange(6, str.length - 6)];
        label.attributedText = attributeString;
    }
    
    return view;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
    if (self.selectedCallBack) {
        self.selectedCallBack(carousel.currentItemIndex);
    }
}

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform {
    static CGFloat max_sacle = 1.0f;
    static CGFloat min_scale = 0.8f;
    if (offset <= 1 && offset >= -1) {
        float tempScale = offset < 0 ? 1 + offset : 1 - offset;
        float slope = (max_sacle - min_scale) / 1;
        CGFloat scale = min_scale + slope*tempScale;
        transform = CATransform3DScale(transform, scale, scale, 1);
    }else{
        transform = CATransform3DScale(transform, min_scale, min_scale, 1);
    }
    return CATransform3DTranslate(transform, offset * self.myCarousel.itemWidth * 1.2, 0.0, 0.0);
}
@end
