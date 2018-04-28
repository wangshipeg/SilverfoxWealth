

#import "IndividualInfoOneCell.h"
#import "UILabel+LabelStyle.h"

@implementation IndividualInfoOneCell




- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLB=[[UILabel alloc] init];
        [self addSubview:_titleLB];
        [_titleLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:15] characterColor:[UIColor characterBlackColor]];
        [_titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@90);
            make.height.equalTo(@20);
        }];
        
        _contentLB=[[UILabel alloc] init];
        [self addSubview:_contentLB];
        [_contentLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:15] characterColor:[UIColor characterBlackColor]];
        _contentLB.textAlignment=NSTextAlignmentLeft;
        [_contentLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleLB.mas_right);
            make.centerY.equalTo(self.mas_centerY);
            make.width.equalTo(@190);
            make.height.equalTo(@20);
        }];
    }
    return self;
}

-(void)showDetailWithDic:(NSDictionary *)dic{
    self.titleLB.text = dic[@"name"];
    if ([dic[@"value"] isKindOfClass:[NSAttributedString class]]) {
        self.contentLB.attributedText = dic[@"value"];
    }else{
        self.contentLB.text = dic[@"value"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
