

#import "AddDetailIncomeImageView.h"
#import "StringHelper.h"
#import "UILabel+LabelStyle.h"

@implementation AddDetailIncomeImageView

- (id)initWithAddIncomeValue:(NSString *)value {
    //self = [super initWithImage:[UIImage imageNamed:@"AddIncome.png"]];
    self = [super init];
    if (self) {
        UILabel *incomeTitle=[[UILabel alloc] init];
        incomeTitle.textAlignment=NSTextAlignmentCenter;
        [self addSubview:incomeTitle];
        incomeTitle.attributedText=[StringHelper renderDetailIncreaseInterestWithValue:value valueFont:16 percentFont:16];
        [incomeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@20);
            make.centerY.equalTo(self.mas_centerY).offset(-2);
        }];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
