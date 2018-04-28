

#import <UIKit/UIKit.h>
#import "CustomerSeparateTableViewCell.h"

@interface IndividualInfoOneCell : CustomerSeparateTableViewCell
@property (strong, nonatomic) UILabel *titleLB;
@property (strong, nonatomic) UILabel *contentLB;

-(void)showDetailWithDic:(NSDictionary *)dic;


@end
