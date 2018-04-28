

#import "MyMessageCell.h"
#import "DateHelper.h"
#import "UILabel+LabelStyle.h"
#import "SCMeasureDump.h"

@implementation MyMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _messageFromLB = [[UILabel alloc] init];
        [self addSubview:_messageFromLB];
        [_messageFromLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:16] characterColor:[UIColor characterBlackColor]];
        [_messageFromLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(8);
            make.left.equalTo(self.mas_left).offset(15);
            make.width.equalTo(@85);
            make.height.equalTo(@20);
        }];
        
        _messageTimeLB = [[UILabel alloc] init];
        [self addSubview:_messageTimeLB];
        [_messageTimeLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:13] characterColor:[UIColor characterBlackColor]];
        _messageTimeLB.textAlignment=NSTextAlignmentRight;
        [_messageTimeLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.top.equalTo(self.mas_top).offset(8);
            make.width.equalTo(@170);
            make.height.equalTo(@20);
        }];
        
        _messageContentLB = [[UILabel alloc] init];
        [self addSubview:_messageContentLB];
        [_messageContentLB decorateLabelStyleWithCharacterFont:[UIFont systemFontOfSize:13] characterColor:[UIColor characterBlackColor]];
        _messageContentLB.numberOfLines = 0;
        [_messageContentLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.right.equalTo(self.mas_right).offset(-15);
            make.top.equalTo(_messageFromLB.mas_bottom).offset(13);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
        }];
    }
    return self;
}

- (void)showMessageWith:(UserInfoModel *)dic {
    DLog(@"xiaoxi======%@",dic);
    self.messageFromLB.text = dic.title;
    self.messageTimeLB.text = dic.createTime;
    self.messageContentLB.text = dic.message;
    
    if ([dic.status integerValue] == 0) {
        //未读
        self.messageFromLB.textColor = [UIColor zheJiangBusinessRedColor];
        self.messageTimeLB.textColor = [UIColor zheJiangBusinessRedColor];
        self.messageContentLB.textColor = [UIColor zheJiangBusinessRedColor];
        self.userInteractionEnabled = YES;
    }else{
        self.messageFromLB.textColor = [UIColor characterBlackColor];
        self.messageTimeLB.textColor = [UIColor characterBlackColor];
        self.messageContentLB.textColor = [UIColor characterBlackColor];
        self.userInteractionEnabled = NO;
    }
}

- (CGFloat)achieveContentHeight {
    UIScreen *screen=[UIScreen  mainScreen];
    CGSize size = CGSizeMake(screen.bounds.size.width - 30, 1000);
    CGRect rect = [self.messageContentLB.text  boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13],NSFontAttributeName, nil] context:nil];
    CGFloat result = rect.size.height + 60;
    return result;
}




@end
