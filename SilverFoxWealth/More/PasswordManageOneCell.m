

#import "PasswordManageOneCell.h"
#import "UILabel+LabelStyle.h"

@implementation PasswordManageOneCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleNameLB=[[UILabel alloc] init];
        [self addSubview:_titleNameLB];
        [_titleNameLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:15] characterColor:[UIColor characterBlackColor]];
        [_titleNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@20);
            make.width.equalTo(@150);
        }];
        
        UIImageView *arrowIM=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AllowRight.png"]];
        [self addSubview:arrowIM];
        [arrowIM mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@7);
            make.height.equalTo(@15);
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return self;
}

- (void)showDetailWith:(NSString *)str{
    self.titleNameLB.text = str;
}

@end
