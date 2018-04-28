

#import "AddBankCardCell.h"
#import "AddCancelButton.h"

@implementation AddBankCardCell

- (id)initWithTitle:(NSString *)title inputTF:(UITextField *)inputTF leftViewWidth:(CGFloat)leftViewWidth {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (self) {
                
        [self addSubview:inputTF];
        inputTF.font=[UIFont systemFontOfSize:14];
        inputTF.textColor = [UIColor characterBlackColor];
        inputTF.backgroundColor=[UIColor whiteColor];
        [inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right).offset(-15);
            make.bottom.equalTo(self.mas_bottom).offset(-0.5);
        }];
        
        UIView *phoneLB = [AddCancelButton addTextFieldLeftViewWithTitle:title width:leftViewWidth];
        [inputTF setLeftView:phoneLB];
        inputTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

@end
