

#import "NoneInvestView.h"
#import "UILabel+LabelStyle.h"
#import "RoundCornerClickBT.h"
#import "FastAnimationAdd.h"

@implementation NoneInvestView
{
    UIView *upLayerView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        
        _noteLB=[[UILabel alloc] init];
        [self addSubview:_noteLB];
        [_noteLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:15] characterColor:[UIColor characterBlackColor]];
        _noteLB.numberOfLines=0;
        _noteLB.textAlignment=NSTextAlignmentCenter;
        [_noteLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.left.equalTo(self.mas_left).offset(15);
            make.right.equalTo(self.mas_right).offset(-15);
        }];
        
        RoundCornerClickBT *confireBT=[RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
        [self addSubview:confireBT];
        confireBT.backgroundColor=[UIColor zheJiangBusinessRedColor];
        [confireBT addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
        confireBT.titleLabel.font=[UIFont systemFontOfSize:16];
        [confireBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confireBT setTitle:@"确认" forState:UIControlStateNormal];
        [FastAnimationAdd codeBindAnimation:confireBT];
        [confireBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-10);
            make.left.equalTo(self.mas_left).offset(15);
            make.right.equalTo(self.mas_right).offset(-15);
            make.height.equalTo(@45);
        }];
    }
    return self;
}

- (void)show {
    
    UIWindow *window=[[UIApplication sharedApplication] keyWindow];
    
    if (![window.subviews containsObject:self]) {
        CGRect windowFrame = window.frame;
        UIView *overlayView = [[UIView alloc] initWithFrame:windowFrame];
        overlayView.backgroundColor = [UIColor clearColor];
        upLayerView = [[UIView alloc] initWithFrame:windowFrame];
        upLayerView.backgroundColor = [UIColor blackColor];
        upLayerView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
        [upLayerView addGestureRecognizer:tap];
        upLayerView.alpha = 0.0;
        [overlayView addSubview:upLayerView];
        [window addSubview:overlayView];
        [UIView animateWithDuration:0.6 animations:^{
            upLayerView.alpha = 0.3;
        }];
        
        CGFloat surplusHeight = CGRectGetHeight(windowFrame)-216-20-25;
        CGFloat tradePasswordHeight = CGRectGetHeight(self.frame);
        if (surplusHeight < tradePasswordHeight) {
            tradePasswordHeight=surplusHeight;
        }
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.0;
        
        self.frame=CGRectMake(35,CGRectGetHeight(windowFrame)-216-20-tradePasswordHeight , CGRectGetWidth(windowFrame)-35*2, tradePasswordHeight);
        self.alpha=0;
        [overlayView addSubview:self];
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha=1;
        }];
        
    }
}

- (void)dismissView {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha=0;
        upLayerView.alpha=0;
    } completion:^(BOOL finished) {
        [self.superview removeFromSuperview];
    }];
}

- (void)dismiss:(UIButton *)sender {
    [self dismissView];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
