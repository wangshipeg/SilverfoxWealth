

#import "SilverClearCell.h"
#import "CommunalInfo.h"
#import "DateHelper.h"
#import "StringHelper.h"

@implementation SilverClearCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _contentLBView=[[ThreeEquelPartByLBView alloc] init];
        [self addSubview:_contentLBView];
        [_contentLBView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.top.equalTo(self.mas_top);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    return self;
}

//显示我的夺宝记录详情
- (void)showMyIndianaWithDic:(IndianaRecordsModel *)data
{
    self.contentLBView.twoLB.text = data.cellphone;
    self.contentLBView.oneLB.text = data.createTime;
    self.contentLBView.threeLB.attributedText = [StringHelper renderFrontAndAfterDifferentFontWithValue:@"参与了" frontFont:14 frontColor:[UIColor characterBlackColor] afterStr:data.joinCode  afterFont:14 afterColor:[UIColor zheJiangBusinessRedColor] lastStr:@"次夺宝" lastFont:14 lastColor:[UIColor characterBlackColor]];
}

//银子详情
-(void)showInfoWithDic:(NSDictionary *)dic {
    self.contentLBView.oneLB.text = dic[@"createTime"];
    self.contentLBView.twoLB.text=dic[@"channel"];
    
    if ([dic[@"amount"] floatValue] > 0) {
        self.contentLBView.threeLB.text=[NSString stringWithFormat:@"+%@两",[dic[@"amount"] stringValue]];
        self.contentLBView.threeLB.textColor=[UIColor zheJiangBusinessRedColor];
        return;
    }
    
    if ([dic[@"amount"] floatValue] < 0) {
        self.contentLBView.threeLB.text=[NSString stringWithFormat:@"%@两",[dic[@"amount"] stringValue]];
        self.contentLBView.threeLB.textColor=[UIColor iconBlueColor];
    }
}

- (void)showExchangeRecordWith:(ExchangeRecordModel *)model
{
    self.contentLBView.oneLB.text = model.tradeTime;
    self.contentLBView.twoLB.text = model.purpose;
    NSString *amount = [StringHelper roundValueToDoubltValue:model.amount];
    if ([model.amount floatValue] > 0) {
        self.contentLBView.threeLB.text=[NSString stringWithFormat:@"+%.2f元",[amount doubleValue]];
        self.contentLBView.threeLB.textColor=[UIColor zheJiangBusinessRedColor];
        return;
    }    
    if ([model.amount floatValue] < 0) {
        self.contentLBView.threeLB.text=[NSString stringWithFormat:@"%.2f元",[amount doubleValue]];
        self.contentLBView.threeLB.textColor=[UIColor iconBlueColor];
    }
}

@end

