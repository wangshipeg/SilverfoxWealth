//
//  CustomerNavgationController.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/10/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CustomerNavgationController.h"

@implementation CustomerNavgationController

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self initNavTitleLabel];
        [self initNavCloseButton];
        [self initNavRightButton];
    }
    return self;
}

- (void)initNavTitleLabel {
    if (IS_iPhoneX) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 44, [[UIScreen mainScreen] bounds].size.width - (75*2), 44)];
    }else{
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 20, [[UIScreen mainScreen] bounds].size.width - (75*2), 44)];
    }
    
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    _titleLabel.textColor = [UIColor characterBlackColor];
    [self addSubview:_titleLabel];
}

- (void)initNavCloseButton {
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (IS_iPhoneX) {
        _leftButton.frame = CGRectMake(5, 44, 65, 44);
    }else{
        _leftButton.frame = CGRectMake(5, 20, 65, 44);
    }
    _leftButton.titleLabel.font = [UIFont systemFontOfSize:13];
    _leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
    [_leftButton setTitleColor:[UIColor iconBlueColor] forState:UIControlStateNormal];
    [_leftButton setImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(closeViewControllerAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_leftButton];
}

- (void)initNavRightButton {
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (IS_iPhoneX) {
        _rightButton.frame = CGRectMake(self.frame.origin.x + self.frame.size.width - 65, 44, 60, 44);
    }else{
        _rightButton.frame = CGRectMake(self.frame.origin.x + self.frame.size.width - 65, 20, 60, 44);
    }
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:13];
    _rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [_rightButton setTitleColor:[UIColor iconBlueColor] forState:UIControlStateNormal];
    _rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    [_rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightButton];
}

- (void)closeViewControllerAction {
    
    if (self.leftViewController) {
        self.leftViewController();
    }
}

- (void)rightButtonAction {
    
    if (self.rightButtonHandle) {
        self.rightButtonHandle();
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithWhite:0.8 alpha:1].CGColor);
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, rect.size.width, 0);
    
    if (IS_iPhoneX) {
        CGContextMoveToPoint(ctx, 0, iPhoneX_Navigition_Bar_Height);
        CGContextAddLineToPoint(ctx, rect.size.width, iPhoneX_Navigition_Bar_Height);
    }else{
        CGContextMoveToPoint(ctx, 0, 64);
        CGContextAddLineToPoint(ctx, rect.size.width, 64);
    }
    
    
    CGContextClosePath(ctx);
    CGContextStrokePath(ctx);
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

