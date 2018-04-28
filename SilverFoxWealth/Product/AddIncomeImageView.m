

#import "AddIncomeImageView.h"
#import "StringHelper.h"
#import "UILabel+LabelStyle.h"

@implementation AddIncomeImageView


- (id)initWithAddIncomeValue:(NSString *)value {
    self = [super init];
    if (self) {
        UILabel *incomeTitle=[[UILabel alloc] init];
        incomeTitle.textAlignment=NSTextAlignmentCenter;
        [self addSubview:incomeTitle];
        incomeTitle.attributedText=[StringHelper renderIncreaseInterestWithValue:value valueFont:13 percentFont:13];
        [incomeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@20);
            make.centerY.equalTo(self.mas_centerY).offset(-2);
        }];
    }
    return self;
}

@end
