

#import <UIKit/UIKit.h>
#import "RecommendAdvertModel.h"

@interface AdvertisementDetailVC : UIViewController
@property (nonatomic, copy) RecommendAdvertModel *advertModel;
@property (strong, nonatomic) UIWebView *webView;

@property (nonatomic, strong) NSString *productDetailActivityTitle;
@property (nonatomic, strong) NSString *productDetailActivityUrl;

@end
