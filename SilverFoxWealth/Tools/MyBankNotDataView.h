//
//  MyBankNotDataView.h
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/6/26.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundCornerClickBT.h"

typedef void (^BindingBlock)();

@interface MyBankNotDataView : UIView
@property (nonatomic, copy) BindingBlock bindingBlock;

- (id)initWithFrame:(CGRect)frame noteTitle:(NSString *)noteTitle btTitle:(NSString *)btTitle;

- (void)bindingBlockWith:(BindingBlock)bindingBlock;

@end
