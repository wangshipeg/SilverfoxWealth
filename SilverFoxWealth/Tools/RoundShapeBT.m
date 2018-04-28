//
//  RoundShapeBT.m
//  SilverFoxWealth
//
//  Created by SilverFox on 15/5/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "RoundShapeBT.h"

@implementation RoundShapeBT

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.layer.masksToBounds=YES;
    self.layer.cornerRadius=rect.size.width/2.0;
}
@end
