//
//  RoundTextField.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2016/12/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "RoundTextField.h"

@implementation RoundTextField

- (void)drawRect:(CGRect)rect {
    self.layer.cornerRadius = 5.0;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor typefaceGrayColor].CGColor;
    self.layer.borderWidth = 1;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
