
#import "ParseHelper.h"
#import "IndividualInfoManage.h"
#import <SVProgressHUD.h>
#import <MTLJSONAdapter.h>
#import "AssetModel.h"
#import "RecommendAdvertModel.h"
#import "SilverWealthProductDetailModel.h"
#import "SilverWealthProductModel.h"
#import "AlreadyPurchaseProductModel.h"
#import "BankAndIdentityInfoModel.h"
#import "SupportBankModel.h"
#import "RebateModel.h"
#import "WithoutAuthorization.h"
#import "FundProductModel.h"
#import "VersionInfoModel.h"
#import "UserInfoModel.h"
#import "SystemInfoModel.h"
#import "AssetFormationModel.h"
#import "DetailPageBuyBlockModel.h"
#import "SCMeasureDump.h"
#import "RecommendContentModel.h"
#import "SignInTimesModel.h"
#import "ExchangerRecordModel.h"
#import "EarnSilversModel.h"
#import "SignInPrizeListModel.h"
#import "ZeroIndianaModel.h"
#import "IndianaRecordsModel.h"
#import "PopupModel.h"
#import "ActivityZoonModel.h"
#import "WidgetManager.h"
#import "SilverGoodsLeightModel.h"
#import "FinancialColumnModel.h"
#import "FindSilverTraderModel.h"
#import "LastTimeUseBankModel.h"
#import "AlreadyBuyProductsDetailModel.h"
#import "ExchangeRecordModel.h"
#import "BackRebateActivityModel.h"
#import "RetroactiveCardModel.h"

@implementation ParseHelper


+(id)parseToUserRebate:(NSData *)responseData
{
    if (!responseData) {
        return nil;
    }
    NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    return dicData;
}

//解析至 设置交易密码
+(id)parseToSetTradePassword:(NSData *)responseData {
    
    if (!responseData) {
        return nil;
    }
    NSDictionary *dicData=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    
    if ([dicData[@"code"] integerValue]==200) {
        NSError *err=nil;
        IndividualInfoManage *user=[MTLJSONAdapter modelOfClass:[IndividualInfoManage class] fromJSONDictionary:dicData[@"msg"] error:&err];
        if (err) {
            DLog(@"解析user出错===%@",err.description);
            return nil;
        }
        return user;
    }
    
    if ([dicData[@"code"] integerValue] == 403  || [dicData[@"code"] integerValue] == 401 || [dicData[@"code"] integerValue] == 406 || [dicData[@"code"] integerValue] == 415 || [dicData[@"code"] integerValue] == 404) {
       return [self parseIncludeAuthorizationOfDic:dicData];
    }
    
    return dicData;
}


+(id)parseToDic:(NSData *)responseData {
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    switch ([dic[@"code"] integerValue]) {
        case 2000:
            return dic[@"data"];
        default:
            return dic[@"msg"];
            break;
    }
    return nil;
}

//解析至身份证验证字典
+(id)parseToIdCardDic:(NSData *)responseData {
    
    if (!responseData) {
        return nil;
    }
    
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    
    return dic;
}

+ (id)parseToCode:(NSData *)responseData
{
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    return dic;
}


//解析历史消息
+(id)parseToUserMessage:(NSData *)responseData {
    if (!responseData) {
        return nil;
    }
    
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    
    switch ([dic[@"code"] integerValue]) {
        case 200:
        {
            NSArray *resultArray=dic[@"msg"];
            if (resultArray.count) {
              return [resultArray  objectAtIndex:0];
            }
            return nil;
        }
            break;
        case 403:
           return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 401:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 406:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 415:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 404:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        default:
            break;
    }
    return nil;
}

//解析系统消息
+ (id)parseToSystemMessage:(NSData *)responseData {
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    DLog(@"系统消息返回信息====%@",dic);
    if (dic) {
        NSArray *array=[dic objectForKey:@"systemMessage"];
        if (![array isKindOfClass:[NSNull class]]) {
            if (array.count != 0) {
                NSMutableArray *resultArray=[NSMutableArray array];
                NSError *error=nil;
                for (NSDictionary *subDic in array) {
                    SystemInfoModel *model=[MTLJSONAdapter modelOfClass:[SystemInfoModel class] fromJSONDictionary:subDic error:&error];
                    if (error) {
                        DLog(@"解析系统消息错误==%@",error.localizedDescription);
                    }
                    [resultArray addObject:model];
                }
                return resultArray;
            }
            return nil;
        }        
    }
    return nil;
}

+ (id)parseToExchangeDetail:(NSData *)responseData
{
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    DLog(@"交易明细====%@",dic);
    NSArray *array = [NSArray array];
    if ([dic isKindOfClass:[NSDictionary class]]) {
        if ([dic[@"code"] intValue] == 2000) {
            NSDictionary *dict = dic[@"data"];
            array = dict[@"records"];
            if (array.count == 0) {
                return nil;
            }
            NSMutableArray *resultArray = [NSMutableArray array];
            NSError *error=nil;
            for (NSDictionary *subDic in array) {
                ExchangeRecordModel *model=[MTLJSONAdapter modelOfClass:[ExchangeRecordModel class] fromJSONDictionary:subDic error:&error];
                if (error) {
                    DLog(@"解析交易明细错误==%@",error.localizedDescription);
                }
                [resultArray addObject:model];
            }
            return resultArray;
        }
        if ([dic[@"code"] integerValue] == 403 || [dic[@"code"] integerValue] == 401 || [dic[@"code"] integerValue] == 406 || [dic[@"code"] integerValue] == 415 || [dic[@"code"] integerValue] == 404) {
            return [self parseIncludeAuthorizationOfDic:dic];
        }
    }
    return nil;
}

//解析签到
+(id)parseToUserSign:(NSData *)responseData {
    
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    DLog(@"签到======%@",dic);
    switch ([dic[@"code"] integerValue]) {
        case 2000:
        {
            NSDictionary *rusultDic = dic[@"data"];
            return rusultDic;
        }
            break;
        case 403:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 401:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 406:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 415:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 404:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        default:
            break;
    }
    return nil;
}

//解析至 投资客
+(id)parseToCustomer:(NSData *)responseData {
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    DLog(@"获取投资客信息=====%@",dic);
    if ([dic[@"code"] integerValue] == 2000) {
        NSError *error=nil;
        NSDictionary *resultDic = dic[@"data"];
        if ([resultDic isKindOfClass:[NSNull class]]) {
            return nil;
        }
        IndividualInfoManage *user=[MTLJSONAdapter modelOfClass:[IndividualInfoManage class] fromJSONDictionary:resultDic error:&error];
        if (error) {
            DLog(@"解析独立user出错===%@",error.description);
        }
        return user;
    }
    return dic;
}

//解析至我的资产
+(id)parseToMyAsset:(NSData *)responseData{
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    if (!dic) {
        return nil;
    }
    switch ([dic[@"code"] integerValue]) {
        case 2000:
        {
            NSDictionary *dict = dic[@"data"];
            NSError *err=nil;
            AssetModel *asset=[MTLJSONAdapter modelOfClass:[AssetModel class] fromJSONDictionary:dict error:&err];
            if (err) {
                DLog(@"我的资产解析出错==%@",err.description);
                return nil;
            }
            return asset;
        }
            break;
        case 403:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 401:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 406:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 415:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 404:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        default:
            break;
    }
    
    return nil;
    
}


//解析银子明细
+(id)parseTosilverClear:(NSData *)responseData {
    
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    switch ([dic[@"code"] integerValue]) {
        case 2000:
        {
            return dic;
        }
            break;
        case 403:
        {
            return [self parseIncludeAuthorizationOfDic:dic];
        }
            break;
        case 401:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 406:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 415:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        default:
            return nil;
            break;
    }
    return nil;
}

//解析至 我的推荐
+(id)parseToRecommend:(NSData *)responseData {
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    DLog(@"精品推荐banner 加载结果===%@",dic);
    if ([dic[@"code"] intValue] == 2000) {
        NSDictionary *dict = dic[@"data"];
        NSError *advertErr=nil;
        if (dict == nil || [dict isEqual:[NSNull null]]) {
            return nil;
        }
        NSArray *advertArray=dict[@"images"];
        NSMutableArray *resultAdvertArray=[NSMutableArray array];
        for (NSDictionary *subDic in advertArray) {
            RecommendAdvertModel *advertM=[MTLJSONAdapter modelOfClass:[RecommendAdvertModel class] fromJSONDictionary:subDic error:&advertErr];
            if (advertErr) {
                DLog(@"解析推荐产品广告出错==%@",advertErr.description);
            }
            [resultAdvertArray addObject:advertM];
        }
        return resultAdvertArray;
    }
    return nil;
}


+(id)parseToRecommendProduct:(NSData *)responseData
{
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    DLog(@"精品推荐 产品 加载结果===%@",dic);
    //打包推荐里的定期产品
    NSError *productsErr=nil;
    if ([dic[@"code"] intValue] == 2000) {
        NSDictionary *dict = dic[@"data"];
        NSArray *productsArray=dict[@"recommendProducts"];
        //保存产品数据, 供widget使用
        [WidgetManager saveWidgetData:productsArray];
        
        NSMutableArray *resultProductsArray=[NSMutableArray array];
        for (NSDictionary *subDic in productsArray) {
            SilverWealthProductModel *productModel=[MTLJSONAdapter modelOfClass:[SilverWealthProductModel class] fromJSONDictionary:subDic error:&productsErr];
            [resultProductsArray addObject:productModel];
        }
        NSString *currentTime = dict[@"currentTime"];
        [SCMeasureDump shareSCMeasureDump].nowTime = currentTime;
        return resultProductsArray;
        
    }
    return nil;
}

+ (id)parseToRebateAcitvity:(NSData *)responseData
{
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    DLog(@"返利活动 加载结果===%@",dic);
    NSError *productsErr = nil;
    if ([dic[@"code"] intValue] == 2000) {
        NSDictionary *dict = dic[@"data"];
        NSArray *productsArray = dict[@"bonusDetails"];
        NSMutableArray *resultProductsArray = [NSMutableArray array];
        for (NSDictionary *subDic in productsArray) {
            BackRebateActivityModel *productModel=[MTLJSONAdapter modelOfClass:[BackRebateActivityModel class] fromJSONDictionary:subDic error:&productsErr];
            
            [resultProductsArray addObject:productModel];
        }
        return resultProductsArray;
    }
    return nil;
}


//解析我的消息 历史数据
+(id)parseToUserHistoryMessageList:(NSData *)responseData {
    if (!responseData) {
        return nil;
    }    
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    DLog(@"用户个人消息原始数据=====%@",dic);
    switch ([dic[@"code"] integerValue]) {
        case 2000:
        {
            NSDictionary *dictionary = dic[@"data"];
            if ([dictionary isEqual:[NSNull null]]) {
                return nil;
            }
            [SCMeasureDump shareSCMeasureDump].myMessagePages = dictionary[@"pages"];
            if (dictionary) {
                NSArray *array = dictionary[@"myMessage"];
                if (array.count != 0) {
                    NSMutableArray *resultArray=[NSMutableArray array];
                    NSError *error=nil;
                    for (NSDictionary *subDic in array) {
                        UserInfoModel *model=[MTLJSONAdapter modelOfClass:[UserInfoModel class] fromJSONDictionary:subDic error:&error];
                        [resultArray addObject:model];
                    }
                    return resultArray;
                }
                return nil;
            }
        }
            break;
        case 403:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 401:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 406:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 415:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 404:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        default:
            break;
    }
    return nil;
}

/**
 *解析签到奖励
 */
+(id)monthSignInRewardList:(NSData *)responseData
{
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    return dic;
}
/**
 *解析签到奖励领取记录
 */
+(id)monthSignInGetRecordList:(NSData *)responseData
{
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    DLog(@"领取签到奖品记录原始数据=======%@",dic);
    if ([dic[@"code"] integerValue] == 2000) {
        NSDictionary *dict = dic[@"data"];
        if ([dict isEqual:[NSNull null]]) {
            return nil;
        }
        NSString *resultStr = dict[@"prizeIds"];
        return resultStr;
    }
    return nil;
}
//
+ (id)parseToFinanclalConumnList:(NSData *)responseData
{
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    if (!dic || [dic isKindOfClass:[NSNull class]]) {
        return nil;
    }
    if ([dic isKindOfClass:[NSDictionary class]]) {
        if ([dic[@"code"] intValue] == 2000) {
            NSDictionary *dict = dic[@"data"];
            NSArray *array = dict[@"financeNews"];
            if (array.count != 0) {
                NSMutableArray *resultArray=[NSMutableArray array];
                NSError *error=nil;
                for (NSDictionary *subDic in array) {
                    FinancialColumnModel *model=[MTLJSONAdapter modelOfClass:[FinancialColumnModel class] fromJSONDictionary:subDic error:&error];
                    [resultArray addObject:model];
                }
                return resultArray;
            }
        }
    }
    return nil;
}

/**
 *解析奖励列表
 */
+(id)monthSignInPrizeListList:(NSData *)responseData
{
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    DLog(@"签到奖品列表返回原始数据======%@",dic);
    if ([dic[@"code"] integerValue] == 2000) {
        NSDictionary *dict = dic[@"data"];
        if ([dict isEqual:[NSNull null]]) {
            return nil;
        }
        NSArray *array = dict[@"signPrizes"];
        DLog(@"====%lu",(unsigned long)array.count);
        if (array.count != 0) {
            NSMutableArray *resultArray=[NSMutableArray array];
            NSError *error=nil;
            for (NSDictionary *subDic in array) {
                SignInPrizeListModel *model=[MTLJSONAdapter modelOfClass:[SignInPrizeListModel class] fromJSONDictionary:subDic error:&error];
                [resultArray addObject:model];
            }
            return resultArray;
        }
    }
    return nil;
}

+(id)monthSignInTimesList:(NSData *)responseData {
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    DLog(@"本月累计签到天数原始数据===%@",dic);
    if ([dic[@"code"] integerValue] == 2000) {
        NSDictionary *dict = dic[@"data"];
        if ([dict isEqual:[NSNull null]]) {
            return nil;
        }
        NSArray *array = dict[@"signRecords"];
        if ([array isEqual:[NSNull null]]) {
            return nil;
        }
        if (array.count != 0) {
            NSMutableArray *resultArray=[NSMutableArray array];
            NSError *error=nil;
            for (NSDictionary *subDic in array) {
                SignInTimesModel *model=[MTLJSONAdapter modelOfClass:[SignInTimesModel class] fromJSONDictionary:subDic error:&error];
                [resultArray addObject:model];
            }
            return resultArray;
        }
    }
    else if ([dic[@"code"] integerValue] == 403)
    {
        return [self parseIncludeAuthorizationOfDic:dic];
    }
        return nil;
}



//解析至 银狐财富列表数据
+(id)parseToSilverWealthList:(NSData *)responseData {
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    DLog(@"产品列表原始数据====%@",dic);
    if ([dic[@"code"] intValue] == 2000) {
        NSDictionary *dict = dic[@"data"];
        NSMutableArray *longTermResultArray = [NSMutableArray array];
        NSArray *silverFoxWealthArray = dict[@"products"];
        if ([dict[@"products"] isEqual:[NSNull null]]) {
            return nil;
        }
        if (silverFoxWealthArray.count != 0) {
            NSError *longTermError=nil;
            for (NSDictionary *longTermDic in silverFoxWealthArray) {
                SilverWealthProductModel *procuct=[MTLJSONAdapter modelOfClass:[SilverWealthProductModel class] fromJSONDictionary:longTermDic error:&longTermError];
                [longTermResultArray addObject:procuct];
            }
        }
        NSString *currentTime = dict[@"currentTime"];
        [SCMeasureDump shareSCMeasureDump].nowTime = currentTime;
        return longTermResultArray;
    }
    return nil;
}


//解析已购产品 列表
+ (id)parseToAlreadyPurchaseProduct:(NSData *)responseData {
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    switch ([dic[@"code"] integerValue]) {
        case 2000:
        {
            NSArray *dataMutArr = [NSArray array];
            NSDictionary *dataArray = dic[@"data"];
            if ([dataArray isEqual:[NSNull null]]) {
                return nil;
            }
            dataMutArr = dataArray[@"orders"];
            NSMutableArray *resultArray=[NSMutableArray array];
            NSError *err=nil;
            for (NSDictionary *subDic in dataMutArr) {
                AlreadyPurchaseProductModel *already=[MTLJSONAdapter modelOfClass:[AlreadyPurchaseProductModel class] fromJSONDictionary:subDic error:&err];
                if (err) {
                    DLog(@"解析已购产品出错==%@",err.description);
                }
                [resultArray addObject:already];                
            }
            return resultArray;
        }
            break;
        case 403:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 401:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 406:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 415:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 404:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        default:
            break;
    }
    return nil;
}

//解析已购产品详情 
+ (id)parseToAlreadyPurchaseProductDetail:(NSData *)responseData {
    
    if (!responseData) {
        return nil;
    }
    
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    DLog(@"已购产品详情========%@",dic);
    switch ([dic[@"code"] integerValue]) {
        case 2000:
        {
            NSDictionary *dataDic = dic[@"data"];
            NSError *error=nil;
            AlreadyBuyProductsDetailModel *product=[MTLJSONAdapter modelOfClass:[AlreadyBuyProductsDetailModel class] fromJSONDictionary:dataDic error:&error];
            return product;
        }
            break;
        case 403:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 401:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 406:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 415:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 404:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        default:
            break;
    }
    
    return nil;
    
}

//解析已绑银行卡 列表
+ (id)parseToAlreadyBindBankCardWith:(NSData *)responseData {
    
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    DLog(@"解析已绑银行卡=====%@",dic);
    switch ([dic[@"code"] integerValue]) {
        case 2000:
        {
            NSDictionary *dictData = dic[@"data"];
            if ([dictData isEqual:[NSNull null]]) {
                return nil;
            }
            if (dictData != nil && ![dictData isEqual:@""]) {
                BankAndIdentityInfoModel *bank = [MTLJSONAdapter modelOfClass:[BankAndIdentityInfoModel class] fromJSONDictionary:dictData error:nil];
                return bank;
            }
        }
            break;
        case 403:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 401:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 406:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 415:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 404:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        default:
            break;
    }
    return nil;
}


+ (id)parseToSilverWealthProductDetailButBlockUpWith:(NSData *)responseData {
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    DLog(@"详情购买记录=====%@",dic);
    if ([dic[@"code"] intValue] == 2000) {
        NSDictionary *dict = dic[@"data"];
        if ([dict isEqual:[NSNull null]]) {
            return nil;
        }
        [SCMeasureDump shareSCMeasureDump].detailRecordPages = dict[@"pages"];
        NSArray *silverFoxWealthArray = dict[@"boughtRecords"];
        NSMutableArray *longTermResultArray=[NSMutableArray array];
        if (silverFoxWealthArray.count != 0) {
            NSError *longTermError=nil;
            for (NSDictionary *longTermDic in silverFoxWealthArray) {
                DetailPageBuyBlockModel *procuct=[MTLJSONAdapter modelOfClass:[DetailPageBuyBlockModel class] fromJSONDictionary:longTermDic error:&longTermError];
                if (longTermError) {
                    DLog(@"购买记录解析错误===%@",longTermError);
                }
                [longTermResultArray addObject:procuct];
            }
            return longTermResultArray;
        }
    }
    return nil;
}

+ (id)parseToSilverWealthProductDetailButBlockUpAWith:(NSData *)responseData {
    
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    DLog(@"详情页  资产组成==%@",dic);
    NSArray *silverFoxWealthArray=dic[@"products"];
    NSMutableArray *longTermResultArray=[NSMutableArray array];
    
    if (silverFoxWealthArray.count != 0) {
        NSError *longTermError=nil;
        for (NSDictionary *longTermDic in silverFoxWealthArray) {
            AssetFormationModel *procuct=[MTLJSONAdapter modelOfClass:[AssetFormationModel class] fromJSONDictionary:longTermDic error:&longTermError];
            [longTermResultArray addObject:procuct];
        }
    }
    return longTermResultArray;
}

//解析银狐财富产品详情
+ (id)parseToSilverWealthProductDetailWith:(NSData *)responseData {
    
    if (!responseData) {
        return nil;
    }
    NSDictionary *dataDic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    NSError *error=nil;
    DLog(@"产品详情原始数据========%@",dataDic);
    if ([dataDic[@"code"] intValue] == 2000) {
        NSDictionary *dict = dataDic[@"data"];
        [SCMeasureDump shareSCMeasureDump].nowTime = dict[@"currentTime"];
        NSDictionary *productDict = dict[@"product"];
        SilverWealthProductDetailModel *resultModel=[MTLJSONAdapter modelOfClass:[SilverWealthProductDetailModel class] fromJSONDictionary:productDict error:&error];
        if (error) {
            DLog(@"解析银狐财富产品详情出错===%@",error.description);
        }
        return resultModel;
    }
    return nil;
}

+ (id)parseToBankSupportListWith:(NSData *)responseData {
    
    if (!responseData) {
        return nil;
    }
    NSArray *dataArray=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    DLog(@"银行卡列表加载结果====%@",dataArray);
    NSMutableArray *resultArray=[NSMutableArray array];
    NSError *error=nil;
    for (NSDictionary *subDic in dataArray) {
        SupportBankModel *support=[MTLJSONAdapter modelOfClass:[SupportBankModel class] fromJSONDictionary:subDic error:&error];
        if (error) {
            DLog(@"解析银行卡列表出错=%@",error.description);
        }
        [resultArray addObject:support];
    }
    return resultArray;
    
}

//解析我的红包
+(id)parseToRebate:(NSData *)responseData {
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    
    DLog(@"红包原始数据===%@",dic);
    
    switch ([dic[@"code"] integerValue]) {
        case 2000:
        {
            NSDictionary *dict = dic[@"data"];
            NSArray *array = dict[@"customerCoupons"];
            if ([array isEqual:[NSNull null]] || array == nil) {
                return nil;
            }
            NSMutableArray *resultArray=[NSMutableArray array];
            NSError *error=nil;
            for (NSDictionary *subDic in array) {
                RebateModel *rebate=[MTLJSONAdapter modelOfClass:[RebateModel class] fromJSONDictionary:subDic error:&error];
                [resultArray addObject:rebate];
                if (error) {
                    DLog(@"解析我的红包出错==%@",error.description);
                    return nil;
                }
            }
            [SCMeasureDump shareSCMeasureDump].rebatePages = dic[@"pages"];
            return resultArray;
        }
            break;
        case 403:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 401:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 406:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 415:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 404:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        default:
            break;
    }
    
    return nil;
}

+ (id)parseToRollOutOrderNum:(NSData *)responseData{
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    
    DLog(@"解析转出订单号=====%@",dic);
    switch ([dic[@"code"] integerValue]) {
        case 200:
            return dic; //返回订单号
            break;
        case 403:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 401:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 406:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 415:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 404:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        default:
            break;
    }
    return nil;

}
+ (id)parseToBinDingBankUser:(NSData *)responseData{
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    
    DLog(@"解析转出银行卡=====%@",dic);
    switch ([dic[@"code"] integerValue]) {
        case 200:
            return dic[@"msg"];
            break;
        default:
            break;
    }
    return nil;
    
}

//解析订单号
+ (id)parseToOrderNum:(NSData *)responseData {
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    DLog(@"解析订单号22a=====%@",dic);
    switch ([dic[@"code"] integerValue]) {
        case 200:
            return dic[@"msg"]; //返回订单号
            break;
        default:
            break;
    }
    return nil;
}

+ (NSError *)parseToError:(id)error {
    
    NSError *err=error;
    return err;
}

//解析所有包括需要授权才能查看的数据
+ (id)parseIncludeAuthorizationOfDic:(NSDictionary *)dic {
    NSError *err=nil;
    WithoutAuthorization *noAuthorization=[MTLJSONAdapter modelOfClass:[WithoutAuthorization class] fromJSONDictionary:dic error:&err];
    if (err) {
        DLog(@"解析授权出错==%@",err.description);
    }
    return noAuthorization;
    return [NSNumber numberWithBool:NO];
}



//有授权时 成功数据为数组时 使用这个解析
+ (id)parseToArrayOfDic:(NSDictionary *)dic {
    
    NSArray *array=dic[@"msg"];
    return array;
}

#pragma -mark OAuth 解析
//授权
+(NSString *)parseToAuthenticationDic:(NSData *)responseData  {
    
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    switch ([dic[@"code"] integerValue]) {
        case 200:
        {
            NSDictionary *codeDic=dic[@"data"];
            NSString *codeStr=codeDic[@"code"];
            return codeStr;
        }
            break;
        case 401:
            return nil;
            break;
        case 403:
            return nil;
            break;
        case 404:
            return nil;
            break;
        case 406:
            return nil;
            break;
        case 415:
            return nil;
            break;
        default:
            break;
    }
    return nil;
}

//认证
+ (id)parseToAuthorizationDic:(NSData *)responseData {
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    switch ([dic[@"code"] integerValue]) {
        case 200:
        {
            NSDictionary *codeDic = dic[@"data"];
            return codeDic;
        }
            break;
        case 406:
            return nil;
            break;
        case 403:
            return nil;
            break;
            case 404:
            return nil;
            break;
            case 401:
            return nil;
            break;
            case 415:
            return nil;
            
        default:
            break;
    }
    return nil;
    
}


+ (NSString *)parseToWhetherAlreadyBuyProduct:(NSData *)responseData {
    
    if (!responseData) {
        return nil;
    }
    
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    
    switch ([dic[@"code"] integerValue]) {
        case 2000:
            return @"2000";
            break;
        case 403:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 401:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 406:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 415:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 404:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        default:
            break;
    }
    return nil;
}


+ (id)silverTraderExchangeRecord:(NSData *)silverTrader
{
    if (!silverTrader) {
        return nil;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:silverTrader options:NSJSONReadingAllowFragments error:nil];
    DLog(@"检查银子商城兑换记录返回结果%@",dic);
    switch ([dic[@"code"] integerValue]) {
        case 2000:
        {
            NSDictionary *dicMsg = dic[@"data"];
            if ([dicMsg isEqual:[NSNull null]]) {
                return nil;
            }
            [SCMeasureDump shareSCMeasureDump].recordPages = dicMsg[@"pages"];
            NSArray *array = dicMsg[@"exchangeGoodses"];
            if ([array isEqual:[NSNull null]]) {
                return nil;
            }
            if (array.count != 0) {
                NSMutableArray *resultArray = [NSMutableArray array];
                NSError *error = nil;
                for (NSDictionary *subDic in array) {
                    ExchangerRecordModel *model = [MTLJSONAdapter modelOfClass:[ExchangerRecordModel class] fromJSONDictionary:subDic error:&error];
                    [resultArray addObject:model];
                }
                return resultArray;
            }
        }
            break;
            
        default:
            break;
    }
    return nil;
}

+ (id)silverTrader:(NSData *)silverData{
    if (!silverData) {
        return nil;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:silverData options:NSJSONReadingAllowFragments error:nil];
    DLog(@"银子商城首页返回数据=====%@",dic);
    switch ([dic[@"code"] integerValue]) {
        case 2000:
        {
            return dic;
        }
            break;
        case 403:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 401:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 406:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 415:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 404:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
         default:
            break;
    }
    return nil;

}

//0元夺宝
+ (id)zeroIndianaData:(NSData *)responseData
{
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    switch ([dic[@"code"] integerValue]) {
        case 2000:
        {
            NSDictionary *dict = dic[@"data"];
            if ([dict isEqual:[NSNull null]]) {
                return nil;
            }
            NSArray *array=dict[@"races"];
            if (array.count != 0) {
                NSMutableArray *resultArray=[NSMutableArray array];
                NSError *error=nil;
                for (NSDictionary *subDic in array) {
                    ZeroIndianaModel *model=[MTLJSONAdapter modelOfClass:[ZeroIndianaModel class] fromJSONDictionary:subDic error:&error];
                    [resultArray addObject:model];
                }
                return resultArray;
            }
        }
        break;
        default:
        break;
    }
    return nil;
}

+ (id)activityZoonData:(NSData *)responseData
{
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    if ([dic[@"code"] intValue] == 2000) {
        NSDictionary *dict=dic[@"data"];
        [SCMeasureDump shareSCMeasureDump].dateActivity = dict[@"currentTime"];
        NSArray *array = dict[@"activities"];
        if (array.count != 0) {
            NSMutableArray *resultArray=[NSMutableArray array];
            NSError *error=nil;
            for (NSDictionary *subDic in array) {
                ActivityZoonModel *model=[MTLJSONAdapter modelOfClass:[ActivityZoonModel class] fromJSONDictionary:subDic error:&error];
                [resultArray addObject:model];
            }
            return resultArray;
        }
    }
    return nil;
}

/**
 *解析赚银子接口
 */
+ (id)earnSilverInfo:(NSData *)responseData
{
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];    
    switch ([dic[@"code"] integerValue]) {
        case 2000:
        {
            NSDictionary *dict = dic[@"data"];
            NSArray *array=dict[@"earnSilvers"];
            if (array.count != 0) {
                NSMutableArray *resultArray=[NSMutableArray array];
                NSError *error=nil;
                for (NSDictionary *subDic in array) {
                    EarnSilversModel *model=[MTLJSONAdapter modelOfClass:[EarnSilversModel class] fromJSONDictionary:subDic error:&error];
                    [resultArray addObject:model];
                }
                return resultArray;
            }
        }
            break;
            
        default:
            break;
    }
    return dic;
}
/**
 *解析我的夺宝记录
 */
+ (id)myIndianaRecordsInfo:(NSData *)responseData
{
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    DLog(@"我的夺宝记录返回数据==%@",dic);
    switch ([dic[@"code"] integerValue]) {
        case 2000:
        {
            NSDictionary *dict = dic[@"data"];
            NSArray *array = dict[@"exchangeRecords"];
            if (array.count != 0) {
                NSMutableArray *resultArray = [NSMutableArray array];
                NSError *error=nil;
                for (NSDictionary *subDic in array) {
                    IndianaRecordsModel *model = [MTLJSONAdapter modelOfClass:[IndianaRecordsModel class] fromJSONDictionary:subDic error:&error];
                    [resultArray addObject:model];
                }
                return resultArray;
            }
        }
            break;
            
        default:
            break;
    }
    return nil;
}

+ (id)silverTraderExchangeHH:(NSData *)responseData
{
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    
    if ([dic[@"code"] integerValue] == 403 || [dic[@"code"] integerValue] == 401 || [dic[@"code"] integerValue] == 406 || [dic[@"code"] integerValue] == 415 || [dic[@"code"] integerValue] == 404) {
        return [self parseIncludeAuthorizationOfDic:dic];
    }
    
    return dic;
}

+ (id)startPicture:(NSData *)startPic{
    if (!startPic) {
        return nil;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:startPic options:NSJSONReadingAllowFragments error:nil];
    DLog(@"检查启动页返回结果=====%@",dic);
    if ([dic[@"code"] intValue] == 2000) {
        return dic[@"data"];
    }
    return nil;
}

+ (id)parseToRecommendPopup:(NSData *)responseData
{
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    DLog(@"优惠券弹框返回数据=====%@",dic);
    switch ([dic[@"code"] integerValue]) {
        case 2000:
        {
            NSDictionary *dict = dic[@"data"];
            if ([dict isEqual:[NSNull null]]) {
                return nil;
            }
            [SCMeasureDump shareSCMeasureDump].totalRebate = dict[@"total"];
            NSArray *array=dict[@"coupons"];
            if (array.count != 0) {
                NSMutableArray *resultArray=[NSMutableArray array];
                NSError *error=nil;
                for (NSDictionary *subDic in array) {
                    PopupModel *model=[MTLJSONAdapter modelOfClass:[PopupModel class] fromJSONDictionary:subDic error:&error];
                    [resultArray addObject:model];
                }
                return resultArray;
            }
        }
            break;
            
        default:
            break;
    }
    return nil;
}

+ (id)parseToCustomerLastTimeUseBank:(NSData *)responseData
{
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    switch ([dic[@"code"] intValue]) {
        case 200:
        {
            NSError *error=nil;
            NSDictionary *resultDic=dic[@"data"];
            if ([resultDic[@"defaultBank"] isKindOfClass:[NSString class]]) {
                return nil;
            }
            LastTimeUseBankModel *bankInfo=[MTLJSONAdapter modelOfClass:[LastTimeUseBankModel class] fromJSONDictionary:resultDic error:&error];
            if (error) {
                DLog(@"解析上次使用银行卡出错===%@",error.description);
            }
            return bankInfo;
        }
            break;
        case 403:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 401:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 406:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 415:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        case 404:
            return [self parseIncludeAuthorizationOfDic:dic];
            break;
        default:
            break;
    }
    return nil;
}

+ (id)parseToSilverGoods:(NSData *)responseData
{
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    if ([dic isKindOfClass:[NSDictionary class]]) {
        if ([dic[@"code"] intValue] == 2000) {
            NSArray *goodsArr = [NSArray array];
            NSDictionary *dict = dic[@"data"];
            goodsArr = dict[@"goodses"];
            NSMutableArray *mutArr = [NSMutableArray array];
            if (goodsArr.count != 0) {
                for (NSDictionary *subDic in goodsArr) {
                    FindSilverTraderModel *silverModel=[MTLJSONAdapter modelOfClass:[FindSilverTraderModel class] fromJSONDictionary:subDic error:nil];
                    [mutArr addObject:silverModel];
                }
                return mutArr;
            }
        }
    }
    return nil;
}
+ (id)parseToFirstPageButton:(NSData *)responseData
{
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    if ([dic isKindOfClass:[NSDictionary class]]) {
        if ([dic[@"code"] intValue] == 2000) {
            return dic[@"data"];
        }
    }
    return nil;
}


+ (id)parseToRetroactiveCardList:(NSData *)responseData
{
    if (!responseData) {
        return nil;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    switch ([dic[@"code"] integerValue]) {
        case 2000:
        {
            NSArray *dataMutArr = [NSArray array];
            NSDictionary *dataArray = dic[@"data"];
            if ([dataArray isEqual:[NSNull null]]) {
                return nil;
            }
            dataMutArr = dataArray[@"logs"];
            NSMutableArray *resultArray = [NSMutableArray array];
            NSError *err=nil;
            for (NSDictionary *subDic in dataMutArr) {
                RetroactiveCardModel *already=[MTLJSONAdapter modelOfClass:[RetroactiveCardModel class] fromJSONDictionary:subDic error:&err];
                if (err) {
                    DLog(@"解析补签卡列表出错==%@",err.description);
                }
                [resultArray addObject:already];
            }
            return resultArray;
        }
            break;
        default:
            break;
    }
    
    return nil;
}





@end











