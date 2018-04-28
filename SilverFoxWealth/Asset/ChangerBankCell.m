

#import "ChangerBankCell.h"
#import "UILabel+LabelStyle.h"

@implementation ChangerBankCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        UIImageView *addIM=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Add.png"]];
        [self addSubview:addIM];
        [addIM mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.width.equalTo(@28);
            make.height.equalTo(@28);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        UILabel *titleLB=[[UILabel alloc] init];
        [self addSubview:titleLB];
        titleLB.text=@"绑定银行卡";
        [titleLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor iconBlueColor]];
        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@180);
            make.height.equalTo(@20);
            make.left.equalTo(self.mas_left).offset(50);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
                
    }
    return self;
}


@end
