//
//  ShareView.h
//  SilverFoxWealth
//
//  Created by SilverFox on 15/6/25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundCornerView.h"



typedef void (^ShareToBlock)(NSInteger PlatformTag);

@interface ShareView : RoundCornerView
@property (nonatomic, copy) ShareToBlock platformTagBK;

-(void)show:(ShareToBlock)myblock;

@end
