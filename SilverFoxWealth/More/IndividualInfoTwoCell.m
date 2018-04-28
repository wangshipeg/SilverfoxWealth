

#import "IndividualInfoTwoCell.h"
#import "UILabel+LabelStyle.h"

@implementation IndividualInfoTwoCell

- (id)initWithTitle:(NSString *)title {
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (self) {
        _contentLB=[[UILabel alloc] init];
        [self addSubview:_contentLB];
        _contentLB.text=title;
        [_contentLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor characterBlackColor]];
        [_contentLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@150);
            make.height.equalTo(@20);
        }];
    }
    return self;
}

















@end
