//
//  MQGradientProgressView.m
//  MQGradientProgress
//
//  Created by 小马 on 2017/7/24.
//  Copyright © 2017年 maqi. All rights reserved.
//

#import "MQGradientProgressView.h"


@interface MQGradientProgressView ()

@property (nonatomic, strong) CALayer *bgLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;


@end


@implementation MQGradientProgressView

#pragma mark -
#pragma mark - GET ---> view

- (CALayer *)bgLayer {
    if (!_bgLayer) {
        _bgLayer = [CALayer layer];
        //一般不用frame，因为不支持隐式动画
        _bgLayer.bounds = CGRectMake(0, 0, self.bounds.size.width * self.progress, 1);
        _bgLayer.anchorPoint = CGPointMake(0, 0);
        _bgLayer.backgroundColor = self.bgProgressColor.CGColor;
        //_bgLayer.cornerRadius = self.frame.size.height / 2.;
        [self.layer addSublayer:_bgLayer];
    }
    return _bgLayer;
}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.bounds = CGRectMake(0, 0, self.bounds.size.width * self.progress, 1);
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(1, 0);
        _gradientLayer.anchorPoint = CGPointMake(0, 0);
        NSArray *colorArr = self.colorArr;
        _gradientLayer.colors = colorArr;
        _gradientLayer.cornerRadius = self.frame.size.height / 2.;
        [self.layer addSublayer:_gradientLayer];
    }
    return _gradientLayer;
}

#pragma mark -
#pragma mark - SET ---> data

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self updateView];
}

- (void)setColorArr:(NSArray *)colorArr {
    if (colorArr.count >= 2) {
        _colorArr = colorArr;
        [self updateView];
    }else {
        NSLog(@">>>>>颜色数组个数小于2，显示默认颜色");
    }
}

#pragma mark -
#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
        [self simulateViewDidLoad];
        self.colorArr = @[(id)MQRGBColor(252, 244, 77).CGColor,(id)MQRGBColor(252, 93, 59).CGColor];
        self.progress = 0;
    }
    return self;
}

- (void)simulateViewDidLoad {
    [self addSubViewTree];
}

- (void)config {
    self.bgProgressColor = MQRGBColor(216., 216., 156.);
}

- (void)addSubViewTree {
    [self bgLayer];
    [self gradientLayer];
}

- (void)updateView {
    self.gradientLayer.bounds = CGRectMake(0, 0, self.bounds.size.width * self.progress, 1);
    self.gradientLayer.colors = self.colorArr;
}

@end
