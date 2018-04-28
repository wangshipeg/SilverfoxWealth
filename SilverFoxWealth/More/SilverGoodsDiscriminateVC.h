//
//  SilverGoodsDiscriminateVC.h
//  SilverFoxWealth
//
//  Created by SilverFox on 2016/12/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SilverGoodsDiscriminateVC : UIViewController
@property (nonatomic, strong) NSMutableArray *isHaveMutArr;
@property (nonatomic, strong) NSMutableArray *noHaveMutArr;
@property (nonatomic, strong) NSString *whereFrom;//从上个界面传进来,判断是点击哪个按钮进来的

@end
