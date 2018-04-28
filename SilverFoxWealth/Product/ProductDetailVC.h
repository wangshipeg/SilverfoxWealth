

//银狐财富产品详情
#import <UIKit/UIKit.h>
#import "BaseViewController.h"
typedef NS_ENUM(NSInteger, SuspendType){
    IMAGEVIEW =1,//图片
};
@interface ProductDetailVC : BaseViewController
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, assign) SuspendType suspendType;

@end
