//
//  ProductCategory.m
//  SilverFoxWealth
//
//  Created by SilverFox on 2017/9/1.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ProductCategory.h"
#import "ProductVC.h"
#import "MonthlyRiseProductVC.h"
#import "DataRequest.h"
#import "SXMarquee.h"
#import "InspectNetwork.h"
#import <SVProgressHUD.h>
#import "PromptLanguage.h"
#import "UMMobClick/MobClick.h"
#import "SCMeasureDump.h"
#import "VCAppearManager.h"
#import "CommunalInfo.h"
#import "UINavigationController+DetectionNetState.h"

@interface ProductCategory ()
@property (nonatomic, strong) SXMarquee *mar;
@property (nonatomic, strong) NSDictionary  *leightDic;
@end

@implementation ProductCategory

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarHeight = 64;
    self.titleArray = @[@"定期产品",@"银升产品"];
    ProductVC *productVC = [[ProductVC alloc] init];
    MonthlyRiseProductVC *monthlyRiseProductVC = [[MonthlyRiseProductVC alloc] init];
    self.controllerArray = @[productVC,monthlyRiseProductVC];
    
    NSNotificationCenter *center=[NSNotificationCenter  defaultCenter];
    [center addObserver:self selector:@selector(entryActiveLoadProductListData) name:UIApplicationDidEnterBackgroundNotification  object:nil];
    [center addObserver:self selector:@selector(updateCurrentNetState:) name:Network_State_name object:nil];
    // Do any additional setup after loading the view.
}

- (void)entryActiveLoadProductListData
{
    [self removerMarqueeView];
    [self marqueeRequsetData];
}

//即时更新网络状态
- (void)updateCurrentNetState:(NSNotification *)note
{
    BOOL isnet=[[note.userInfo objectForKey:@"state"] boolValue];
    [self.navigationController detectionCurrentNetWith:isnet];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self removerMarqueeView];
    [self marqueeRequsetData];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    NSNotificationCenter *messageCenter=[NSNotificationCenter  defaultCenter];
    [messageCenter postNotificationName:@"ProductVC" object:Nil userInfo:nil];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)removerMarqueeView
{
    if (_mar) {
        [self handleRemoveMar];
    }
}

- (void)marqueeRequsetData
{
    [[DataRequest sharedClient] leightSilverWealthWithListCallback:^(id obj) {
        DLog(@"跑马灯返回结果=====%@",obj);
        if ([obj isKindOfClass: [NSDictionary class]]) {
            if ([obj[@"code"] intValue] == 2000) {
                _leightDic = obj[@"data"];
                if (![_leightDic isEqual:[NSNull null]]) {
                    [self leightWithList];
                }
            }else{
                [self handleRemoveMar];
            }
        } else {
            [self handleRemoveMar];
        }
    }];
    
    if (![InspectNetwork connectedToNetwork]){
        [SVProgressHUD showErrorWithStatus:NotHaveNetwork];
    }
}

- (void)leightWithList
{
    _mar = [[SXMarquee alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 25) speed:4 Msg:_leightDic[@"remark"] bgColor:[UIColor iconBlueColor] txtColor:[UIColor whiteColor]];
    [_mar changeMarqueeLabelFont:[UIFont systemFontOfSize:14]];
    [_mar changeTapMarqueeAction:^{
        [MobClick event:@"product_list_click_marquee"];
        if ([_leightDic[@"type"] intValue] == 1) {
            [SCMeasureDump shareSCMeasureDump].productListId = _leightDic[@"outLink"];
            [VCAppearManager pushNewH5VCWithCurrentVC:self workS:productAdContent];
        } else {
            [SCMeasureDump shareSCMeasureDump].productListId = _leightDic[@"id"];
            [VCAppearManager pushNewH5VCWithCurrentVC:self workS:productAdPage];
        }
    }];
    [self.view addSubview:_mar];
    [_mar start];
    
    UIButton *deleteBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBT setImage:[UIImage imageNamed:@"closeLight.png"] forState:UIControlStateNormal];
    [_mar addSubview:deleteBT];
    deleteBT.frame = CGRectMake(self.view.frame.size.width - 30, 0, 30, 25);
    [deleteBT addTarget:self action:@selector(handleRemoveMar) forControlEvents:UIControlEventTouchUpInside];
}

- (void)handleRemoveMar
{
    [_mar removeFromSuperview];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if (self.isViewLoaded && !self.view.window)
    {
        self.view = nil;
    }
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
