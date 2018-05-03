//
//  VipCenterView.m
//  SilverFoxWealth
//
//  Created by 丿Love_wcx丶灬丨 紫軒 on 2018/4/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "VipCenterView.h"
#import "CollectPrincipalCell.h"
#import "MembershipBenefitsCell.h"
#import "ToUpgradeCell.h"
#import "RetroactiveCardViewController.h"
#import "BennfitsHeaderCell.h"
#import "IndividualInfoManage.h"
#import "ProductVC.h"
#import "NewHTMLVC.h"

static NSString *membershipBenefitsCell = @"MembershipBenefitsCell";
static NSString *collectPrincipalCell = @"CollectPrincipalCell";
static NSString *toUpgradeCell = @"ToUpgradeCell";
static NSString *bennfitsHeaderCell = @"BennfitsHeaderCell";
static NSInteger currentVipLevel;

@interface VipCenterView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    NSArray *titleArray;
    NSArray *keyArray1;
}
@property (nonatomic, strong) NSArray *keyArray;


@end

@implementation VipCenterView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.keyArray = @[@"withdrawals", @"brithday", @"patch_card", @"coupon", @"discount", @"adviser", @"interest", @"bill", @"forward"];
        keyArray1 = @[@"count", @"money", @"count", @"money", @"rate", @"type", @"rate", @"isExist", @"134"];
        titleArray = @[@"提现次数", @"生日福利", @"补签卡", @"专属优惠券", @"银子商城折扣", @"专享理财顾问", @"专属加息", @"月度账单", @"敬请期待"];
        currentVipLevel = 0;
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    [self.collectionView reloadData];
}

- (void)setUnPaybackPrincipalDict:(NSDictionary *)unPaybackPrincipalDict {
    _unPaybackPrincipalDict = unPaybackPrincipalDict;
    CollectPrincipalCell *cell = (CollectPrincipalCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    if(cell != nil) {
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    }
    
}

#pragma mark ——— UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (_dict || _unPaybackPrincipalDict) {
        return 3;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        IndividualInfoManage *user = [IndividualInfoManage currentAccount];
        if ([user.vipLevel integerValue] < currentVipLevel) {
            return 1;
        }else {
            return 0;
        }
    }else {
        return 9;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CollectPrincipalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectPrincipalCell forIndexPath:indexPath];
        cell.bannerView.rangeArray = self.dict[@"level_range"];
        cell.bannerView.selectedCallBack = ^(NSInteger index) {
            currentVipLevel = index + 1;
            [UIView animateWithDuration:0.4 delay:0.2 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
                [collectionView performBatchUpdates:^{
                    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
                } completion:^(BOOL finished) {
                    [collectionView performBatchUpdates:^{
                        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
                    } completion:nil];
                }];
            } completion:nil];
        };
        NSString *str = [_unPaybackPrincipalDict[@"unPaybackPrincipal"] stringValue];
        if ((str == nil || (NSNull *)str == [NSNull null] || str.length == 0)) {
            cell.collectPrincipalLabel.attributedText = [self setStringColorWithStr:[NSString stringWithFormat:@"我的待收本金%@元",@"0"]];
        }else {
            cell.collectPrincipalLabel.attributedText = [self setStringColorWithStr:[NSString stringWithFormat:@"我的待收本金%@元",str]];
        }
        return cell;
    }else if (indexPath.section == 1) {
        ToUpgradeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:toUpgradeCell forIndexPath:indexPath];
        cell.clickCallBack = ^{
            ProductVC *product = [[ProductVC alloc] init];
            product.hidesBottomBarWhenPushed = YES;
            [self.vipVC.navigationController pushViewController:product animated:YES];
        };
        return cell;
    }
    else {
        MembershipBenefitsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:membershipBenefitsCell forIndexPath:indexPath];
        cell.titleLabel.text = titleArray[indexPath.item];
        cell.keyWord = _keyArray[indexPath.item];
        cell.keyWord1 = keyArray1[indexPath.item];
        cell.cellIndex = indexPath.item;
        IndividualInfoManage *user = [IndividualInfoManage currentAccount];
        cell.level = [user.vipLevel isEqualToString:@"0"] ? 0 : currentVipLevel;
        cell.dict = self.dict;
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, 209*default_scale);
    }else if (indexPath.section == 1) {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, 54*default_scale);
    }
    else {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width/3, 89*default_scale);
    }
    return CGSizeMake(0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, 49*default_scale);
    }
    return CGSizeMake(0, 0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (indexPath.section == 2) {
        if (kind == UICollectionElementKindSectionHeader) {
            BennfitsHeaderCell *headerCell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:bennfitsHeaderCell forIndexPath:indexPath];
            reusableview = headerCell;
        }
        return reusableview;
    }else {
        return reusableview;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        if (indexPath.item != 8) {
            NewHTMLVC *html = [[NewHTMLVC alloc] init];
            switch (indexPath.item) {
                case 0:
                {
                    html.work = MemberWithdrawals;
                }
                    break;
                case 1:
                {
                    html.work = MemberBirthday;
                }
                    break;

                case 5:
                {
                    html.work = MemberAdviser;
                }
                    break;

                case 2:
                {
                    html.work = MemberPatch_card;
                }
                    break;
                case 3:
                {
                    html.work = MemberCoupon;
                }
                    break;

                case 4:
                {
                    html.work = MemberDiscount;
                }
                    break;

                case 6:
                {
                    html.work = MemberInterest;
                }
                    break;
                case 7:
                {
                    html.work = MemberBill;
                }
                    break;
                default:
                    break;
            }
            [self.vipVC.navigationController pushViewController:html animated:YES];
        }
    }
}
// cell点击变色
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// cell点击变色
- (void)collectionView:(UICollectionView *)collectionView  didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{}
#pragma mark ——— getter

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;//垂直滑动
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);  //上左下右四个偏移量
        layout.minimumLineSpacing = 0.0;
        layout.minimumInteritemSpacing = 0.0; //每个cell之间的间距
        layout.footerReferenceSize = CGSizeZero;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerClass:[CollectPrincipalCell class] forCellWithReuseIdentifier:collectPrincipalCell];
        [_collectionView registerClass:[MembershipBenefitsCell class] forCellWithReuseIdentifier:membershipBenefitsCell];
        [_collectionView registerClass:[ToUpgradeCell class] forCellWithReuseIdentifier:toUpgradeCell];
        [_collectionView registerClass:[BennfitsHeaderCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:bennfitsHeaderCell];
    }
    return _collectionView;
}

/** 设置颜色
 * @brief 修改指定数字颜色
 */
- (NSMutableAttributedString *)setStringColorWithStr:(NSString *)str {
    NSArray *numbers =@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"."];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:str];
    for (int i = 0; i < str.length; i ++) {
        NSString *a = [str substringWithRange:NSMakeRange(i, 1)];
        if ([numbers containsObject:a]) {
            [attributeString setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor], NSFontAttributeName:[UIFont systemFontOfSize:16]} range:NSMakeRange(i, 1)];
        }
    }
    return attributeString;
}

- (void)dealloc {
    currentVipLevel = 0;
}


@end
