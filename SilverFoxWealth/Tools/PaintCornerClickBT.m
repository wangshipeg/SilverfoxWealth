//
//  PaintCornerClickBT.m
//  SilverFoxWealth
//
//  Created by SilverFox on 16/1/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PaintCornerClickBT.h"

@implementation PaintCornerClickBT

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect {
    self.layer.borderWidth=1;
    self.layer.borderColor=(__bridge CGColorRef _Nullable)([UIColor typefaceGrayColor]);
}

@end
