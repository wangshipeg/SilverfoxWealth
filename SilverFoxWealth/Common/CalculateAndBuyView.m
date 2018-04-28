
#import "CalculateAndBuyView.h"
#import "CommunalInfo.h"
#import "FastAnimationAdd.h"

@implementation CalculateAndBuyView


- (void)achieveClickEventWith:(CalculateClickBlock)caBlock buBlock:(BuyClickBlock)buBlock {
    self.calculateBlock=caBlock;
    self.buyBlock=buBlock;
}

- (void)achieveClickEventWithbuyBlock:(BuyClickBlock)bock {
    self.buyBlock=bock;
}


- (instancetype)initWith:(UIButton *)buyBT {
    self = [super init];
    if (self) {
        
        self.translatesAutoresizingMaskIntoConstraints=NO;
        self.backgroundColor=[UIColor whiteColor];
        UIButton *calculateBT=[UIButton buttonWithType:UIButtonTypeCustom];
        [calculateBT setImage:[UIImage imageNamed:@"CalculateBT.png"] forState:UIControlStateNormal];
        [calculateBT addTarget:self action:@selector(calculatePass) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:calculateBT];
        [calculateBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(self.mas_top).offset(5);
            make.height.equalTo(@40);
            make.width.equalTo(@70);
        }];
        
        buyBT.backgroundColor=[UIColor typefaceGrayColor];
        buyBT.userInteractionEnabled=NO;
        //[buyBT setTitle:@"售罄" forState:UIControlStateNormal];
        [buyBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buyBT.titleLabel.font=[UIFont systemFontOfSize:16];
        [self addSubview:buyBT];
        [buyBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(calculateBT.mas_right).offset(15);
            make.top.equalTo(self.mas_top).offset(5);
            make.height.equalTo(@40);
            make.right.equalTo(self.mas_right).offset(-15);
        }];
        [buyBT addTarget:self action:@selector(buyPass) forControlEvents:UIControlEventTouchUpInside];
        [FastAnimationAdd codeBindAnimation:buyBT];
        
    }
    return self;
}



- (instancetype)initNoCaculeteWith:(UIButton *)buyBT {
    
    self = [super init];
    if (self) {
        
        self.translatesAutoresizingMaskIntoConstraints=NO;
        self.backgroundColor=[UIColor whiteColor];
        
        buyBT.backgroundColor=[UIColor typefaceGrayColor];
        buyBT.userInteractionEnabled=NO;
        //[buyBT setTitle:@"售罄" forState:UIControlStateNormal];
        [buyBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buyBT.titleLabel.font=[UIFont systemFontOfSize:16];
        [self addSubview:buyBT];
        [buyBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(self.mas_top).offset(5);
            make.bottom.equalTo(self.mas_bottom).offset(-5);
            make.right.equalTo(self.mas_right).offset(-15);
        }];
        [buyBT addTarget:self action:@selector(buyPass) forControlEvents:UIControlEventTouchUpInside];
        [FastAnimationAdd codeBindAnimation:buyBT];
    }
    return self;
    
}
- (void)calculatePass {
    _calculateBlock();
}

- (void)buyPass {
    _buyBlock();
}
























@end
