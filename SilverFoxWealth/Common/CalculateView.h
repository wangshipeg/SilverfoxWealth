
#import <UIKit/UIKit.h>
#import "RoundCornerView.h"
#import "CommunalInfo.h"
#import "SilverWealthProductDetailModel.h"
#import "RoundCornerClickBT.h"


@interface CalculateView : RoundCornerView<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *sumTF;
@property (strong, nonatomic) IBOutlet UILabel *dateLB;
@property (strong, nonatomic) IBOutlet UILabel *showResultLB;
@property (strong, nonatomic) IBOutlet UILabel *bankResultLB;
@property (nonatomic, copy) SilverWealthProductDetailModel *productModel;
@property (strong, nonatomic) IBOutlet RoundCornerClickBT *jsBT;

-(void)show;


@end
