

#import <UIKit/UIKit.h>
#import "RoundCornerView.h"
#import "BlackPointView.h"

#import "UMMobClick/MobClick.h"

//通过块把输入交易密码的回调回去
typedef void (^inputFinish)(NSString *tradePassword);
typedef void(^inputFinishCancel) (NSString *cancel);
///_inputPasswordFinishBlockCancel(_resultStrCancel);

@interface CheckingTDPasswordView : RoundCornerView <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel *noteLB;
@property (strong, nonatomic) IBOutlet UIView *passWordCoverView;
@property (strong, nonatomic) IBOutlet UITextField *passwordInputTF;

@property (nonatomic, strong) NSMutableDictionary *blackPointList;
@property (strong, nonatomic) IBOutlet UIButton *commitBT;
@property (nonatomic, strong) NSString *resultStr; //输入密码结果
@property (nonatomic, strong) inputFinishCancel inputFinishCancelBlock;
@property (nonatomic, copy) inputFinish inputPasswordFinishBlock;
-(void)show:(inputFinish)myblock;
- (void)cancel:(inputFinishCancel)cancelBlock;


@end
