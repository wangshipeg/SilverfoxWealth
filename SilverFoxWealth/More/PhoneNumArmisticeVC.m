//
//  PhoneNumArmisticeVC.m
//  SilverFoxWealth
//
//  Created by SilverFox on 16/3/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PhoneNumArmisticeVC.h"
#import "RoundCornerClickBT.h"
#import "AddCancelButton.h"
#import "AddBankCardCell.h"
#import "FastAnimationAdd.h"
#import "SVProgressHUD.h"
#import "PromptLanguage.h"
#import "AuditVC.h"
#import "DataRequest.h"
#import "AFHTTPSessionManager.h"
#import "SCMeasureDump.h"
#import "AnewSendBT.h"
#import "SignHelper.h"
#import "Validation.h"
#import "DispatchHelper.h"

#define kWidth [UIScreen mainScreen].bounds.size.width

@interface PhoneNumArmisticeVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UITextField *phoneNumberTF;
@property (nonatomic, strong) AnewSendBT *afreshSendBT;
@property (nonatomic, strong) UITextField *smsAuthNumTF;

@property (nonatomic, strong) UIButton *handsetPhoto;//手持照
@property (nonatomic, strong) UIButton *frontPhoto;//正面照
@property (nonatomic, strong) UIButton *backPhoto;//背面照
@property (nonatomic, strong) RoundCornerClickBT *submitBT;//提交审核
@property (nonatomic, strong) UILabel *labelOne;
@property (nonatomic, strong) UILabel *labelTwo;
@property (nonatomic, strong) UILabel *labelThree;
@property (nonatomic, strong) UIImageView *imageOne;
@property (nonatomic, strong) UIImageView *imageTwo;
@property (nonatomic, strong) UIImageView *imageThree;
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UIImageView *image2;
@property (nonatomic, strong) UIImageView *image3;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) NSData *imageData2;
@property (nonatomic, strong) NSData *imageData3;

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) NSDictionary *dict;

@property (nonatomic, strong) UIImage *imagePhone;
@property (nonatomic, strong) UILabel *promptLB;
@property (nonatomic, strong) CustomerNavgationController *customNav;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation PhoneNumArmisticeVC
{
    NSInteger bottonWorkType; //1手持照片   2是正面照 3背面照
    AFHTTPSessionManager *manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIDecorate];
    // Do any additional setup after loading the view.
}
- (void)checkSendAuthCodeBT:(RoundCornerClickBT *)sender
{
    IndividualInfoManage *user = [IndividualInfoManage currentAccount];
    if (!_imageData || !_imageData2 || !_imageData3) {
        [SVProgressHUD showErrorWithStatus:@"请上传全部照片"];
        return;
    }
    [SVProgressHUD showWithStatus:PleaseWaitALittleWhile];
    [[DataRequest sharedClient]exchangePhoneNumberForCensorCodeWithCellphone:self.phoneNumberTF.text idCard:user.idcard smsCode:_smsAuthNumTF.text smsType:@"changecellphonenew" callback:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"code"] intValue] == 2000) {
                //照片上传
                [self upDateHeadIcon:_imagePhone];
            }else{
                [SVProgressHUD showErrorWithStatus:obj[@"msg"]];
            }
        }
    }];
}

- (void)afreshSetTradePassword
{
    AuditVC *auditVC = [[AuditVC alloc] init];
    [self.navigationController pushViewController:auditVC animated:YES];
}

- (void)checkPhone:(UIButton *)sender
{
    switch (sender.tag) {
        case 1:
        {
            bottonWorkType = 1;
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];//UIActionSheet初始化，并设置delegate
            actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
            [actionSheet showFromRect:self.view.bounds inView:self.view animated:YES]; // actionSheet弹出位置
        }
            break;
        case 2:
        {
            bottonWorkType = 2;
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];//UIActionSheet初始化，并设置delegate
            actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
            [actionSheet showFromRect:self.view.bounds inView:self.view animated:YES]; // actionSheet弹出位置
        }
            break;
        case 3:
        {
            bottonWorkType = 3;
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];//UIActionSheet初始化，并设置delegate
            actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
            [actionSheet showFromRect:self.view.bounds inView:self.view animated:YES]; // actionSheet弹出位置
        }
            break;
            
            
        default:
            break;
    }
    
    
}

#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"打开系统照相机");
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor iconBlueColor]} forState:UIControlStateNormal];
                picker.delegate = self;//设置UIImagePickerController的代理，同时要遵循UIImagePickerControllerDelegate，UINavigationControllerDelegate协议
                picker.allowsEditing = YES;//设置拍照之后图片是否可编辑，如果设置成可编辑的话会在代理方法返回的字典里面多一些键值。PS：如果在调用相机的时候允许照片可编辑，那么用户能编辑的照片的位置并不包括边角。
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;//UIImagePicker选择器的类型，UIImagePickerControllerSourceTypeCamera调用系统相机
                [self presentViewController:picker animated:YES completion:nil];
            }
            else{
                //如果当前设备没有摄像头
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"哎呀，当前设备没有摄像头。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
            }
            break;
        }
        case 1:
        {
            NSLog(@"打开系统图片库");
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                UIImagePickerController * picker = [[UIImagePickerController alloc]init];
                [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor iconBlueColor]} forState:UIControlStateNormal];
                picker.delegate = self;
                picker.allowsEditing = YES;//是否可以对原图进行编辑
                
                //打开相册选择照片
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:picker animated:YES completion:nil];
            }
            else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"图片库不可用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate
#pragma mark - 拍照/选择图片结束
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]} forState:UIControlStateNormal];
    DLog(@"如果允许编辑%@",info);//picker.allowsEditing= YES允许编辑的时候 字典会多一些键值。
    //获取图片
    //    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];//原始图片
    _imagePhone = [info objectForKey:UIImagePickerControllerEditedImage];//编辑后的图片
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(_imagePhone, nil, nil, nil);//把图片存到图片库
        
        if (bottonWorkType == 1) {
            [self.handsetPhoto setImage:_imagePhone forState:UIControlStateNormal];
            [_image removeFromSuperview];//移除button上的内容
            [_label removeFromSuperview];
            _imageData = UIImageJPEGRepresentation(_imagePhone, 0.5);
        }else if (bottonWorkType == 2){
            [self.frontPhoto setImage:_imagePhone forState:UIControlStateNormal];
            [_image2 removeFromSuperview];//移除button上的内容
            [_label2 removeFromSuperview];
            _imageData2 = UIImageJPEGRepresentation(_imagePhone, 0.5);
        }else if (bottonWorkType == 3){
            [self.backPhoto setImage:_imagePhone forState:UIControlStateNormal];
            [_image3 removeFromSuperview];//移除button上的内容
            [_label3 removeFromSuperview];
            _imageData3 = UIImageJPEGRepresentation(_imagePhone, 0.5);
        }
    }else{
        if (bottonWorkType == 1) {
            [self.handsetPhoto setImage:_imagePhone forState:UIControlStateNormal];
            [_image removeFromSuperview];//移除button上的内容
            [_label removeFromSuperview];
            _imageData = UIImageJPEGRepresentation(_imagePhone, 0.5);
        }else if (bottonWorkType == 2){
            [self.frontPhoto setImage:_imagePhone forState:UIControlStateNormal];
            [_image2 removeFromSuperview];//移除button上的内容
            [_label2 removeFromSuperview];
            _imageData2 = UIImageJPEGRepresentation(_imagePhone, 0.5);
        }else if (bottonWorkType == 3){
            [self.backPhoto setImage:_imagePhone forState:UIControlStateNormal];
            [_image3 removeFromSuperview];//移除button上的内容
            [_label3 removeFromSuperview];
            _imageData3 = UIImageJPEGRepresentation(_imagePhone, 0.5);
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)upDateHeadIcon:(UIImage *)photo
{
    manager = [AFHTTPSessionManager manager];
    /*使用NSData数据流 传图片*/
    NSString *imageURl = [NSString stringWithFormat:@"%@extras/upload/customers/info",SILVERFOX_BASE_URL];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//申明返回的结果是JSON类型
    
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];//响应接口返回的不同解析格式
    
    IndividualInfoManage *user=[IndividualInfoManage currentAccount];
    // 包装请求参数
    
    if (!_imageData || !_imageData2 || !_imageData3) {
        return;
    }
    
    NSDictionary *parameters = @{@"customerId":user.customerId,@"newCellphone":self.phoneNumberTF.text,@"oldCellphone":user.cellphone,@"idcardPhoto": _imageData,@"idcardFacade":_imageData2,@"idcardBack":_imageData3};
    
    [manager POST:imageURl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:_imageData name:@"idcardPhoto" fileName:@"test.png" mimeType:@"image/png"];
        [formData appendPartWithFileData:_imageData2 name:@"idcardFacade" fileName:@"test.png" mimeType:@"image/png"];
        [formData appendPartWithFileData:_imageData3 name:@"idcardBack" fileName:@"test.png" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"成功!!!!=====%@",responseObject);
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"提交信息结果======%@",dic);
        _dict = dic;
        if ([_dict[@"code"] intValue] == 2000) {
            [SVProgressHUD dismiss];
            [self afreshSetTradePassword];
        } else {
            [SVProgressHUD showErrorWithStatus:_dict[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        _submitBT.userInteractionEnabled = YES;
        [SVProgressHUD showErrorWithStatus:@"提交失败,请稍后重试"];
        NSLog(@"失败原因======%@",error);
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
}

#pragma mark - 取消拍照/选择图片
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]} forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        AddBankCardCell *cell = [[AddBankCardCell alloc] initWithTitle:@"新手机号" inputTF:_phoneNumberTF leftViewWidth:90];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row == 1) {
        AddBankCardCell *cell = [[AddBankCardCell alloc] initWithTitle:@"短信验证码" inputTF:_smsAuthNumTF leftViewWidth:90];
        
        _afreshSendBT = [AnewSendBT buttonWithType:UIButtonTypeCustom];
        _afreshSendBT.frame = CGRectMake(-10, 0, 80, 30);
        _afreshSendBT.layer.cornerRadius = 5;
        [_afreshSendBT setTitle:@"获取短信" forState:UIControlStateNormal];
        _afreshSendBT.layer.masksToBounds = YES;
        [_afreshSendBT setTitleColor:[UIColor iconBlueColor] forState:UIControlStateNormal];
        [_afreshSendBT addTarget:self action:@selector(checkSendAuthCodeOfSilverfoxBT:) forControlEvents:UIControlEventTouchUpInside];
        _afreshSendBT.titleLabel.font=[UIFont systemFontOfSize:14];
        _afreshSendBT.titleLabel.textAlignment=NSTextAlignmentCenter;
        [_smsAuthNumTF setRightView:_afreshSendBT];
        _smsAuthNumTF.rightViewMode=UITextFieldViewModeAlways;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    if (indexPath.row == 2) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.backgroundColor = [UIColor backgroundGrayColor];
        
        [cell addSubview:_handsetPhoto];
        _handsetPhoto.frame = CGRectMake(15, 20, (kWidth - 60) / 3, ((kWidth - 60) / 3) * 7 / 9);
        [cell addSubview:_frontPhoto];
        _frontPhoto.frame = CGRectMake((kWidth - 60) / 3  + 30, 20, (kWidth - 60) / 3, ((kWidth - 60) / 3) * 7 / 9);
        [cell addSubview:_backPhoto];
        _backPhoto.frame = CGRectMake(kWidth - ((kWidth - 60) / 3) - 15, 20, (kWidth - 60) / 3, ((kWidth - 60) / 3) * 7 / 9);
        
        _labelOne.frame = CGRectMake(15, ((kWidth - 60) / 3) * 7 / 9 + 35, (kWidth - 60) / 3, 15);
        [cell addSubview:_labelOne];
        _labelTwo.frame = CGRectMake((kWidth - 60) / 3  + 30, ((kWidth - 60) / 3) * 7 / 9 + 35, (kWidth - 60) / 3, 15);
        [cell addSubview:_labelTwo];
        _labelThree.frame = CGRectMake(kWidth - ((kWidth - 60) / 3) - 15, ((kWidth - 60) / 3) * 7 / 9 + 35, (kWidth - 60) / 3, 15);
        [cell addSubview:_labelThree];
        
        _imageOne.frame = CGRectMake(15, ((kWidth - 60) / 3) * 7 / 9 + 55, (kWidth - 60) / 3, ((kWidth - 60) / 3) * 7 / 9);
        [cell addSubview:_imageOne];
        _imageTwo.frame = CGRectMake((kWidth - 60) / 3 + 30, ((kWidth - 60) / 3) * 7 / 9 + 55, (kWidth - 60) / 3, ((kWidth - 60) / 3) * 7 / 9);
        [cell addSubview:_imageTwo];
        _imageThree.frame = CGRectMake(kWidth - ((kWidth - 60) / 3) - 15, ((kWidth - 60) / 3) * 7 / 9 + 55, (kWidth - 60) / 3, ((kWidth - 60) / 3) * 7 / 9);
        [cell addSubview:_imageThree];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    if (indexPath.row==3) {
        UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.backgroundColor=[UIColor backgroundGrayColor];
        [cell addSubview:_promptLB];
        [_promptLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.mas_top).offset(10);
            make.height.equalTo(@45);
            make.left.equalTo(cell.mas_left).offset(15);
            make.right.equalTo(cell.mas_right).offset(-15);
        }];
        [cell addSubview:_submitBT];
        [_submitBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_promptLB.mas_bottom).offset(20);
            make.height.equalTo(@45);
            make.left.equalTo(cell.mas_left).offset(43);
            make.right.equalTo(cell.mas_right).offset(-43);
        }];
        [cell addSubview:_textLabel];
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.submitBT.mas_bottom).offset(20);
            make.height.equalTo(@200);
            make.left.equalTo(cell.mas_left).offset(15);
            make.right.equalTo(cell.mas_right).offset(-15);
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (void)checkSendAuthCodeOfSilverfoxBT:(UIButton *)sender {
    if (_phoneNumberTF.text.length < 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入完整手机号"];
        return;
    }
    if (![Validation mobileNum:self.phoneNumberTF.text]) {
        [SVProgressHUD showErrorWithStatus:CellphoneNumError];
        return;
    }
    [DispatchHelper afreshSendShortMessageWith:_afreshSendBT];
    [[DataRequest sharedClient]requestSendSMSMD5KEYWithCallback:^(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"code"] intValue] == 2000) {
                NSDictionary *dict = obj[@"data"];
                NSString *resultStr = dict[@"key"];
                [self loginNextStep:resultStr];
            }
        }
    }];
}

- (void)loginNextStep:(NSString *)sig {
    if (![Validation mobileNum:self.phoneNumberTF.text]) {
        [SVProgressHUD showErrorWithStatus:CellphoneNumError];
        return;
    }
    NSString *type = @"changecellphonenew";
    NSString *sign_type = @"MD5";
    NSString *cellphone = self.phoneNumberTF.text;
    NSDictionary *signDic = NSDictionaryOfVariableBindings(cellphone,type,sign_type);
    NSString *sign=[SignHelper  partnerSignOrder:signDic sig:sig];
    [[DataRequest sharedClient] afreshAchieveVerificationCodeWithCellphone:cellphone smsType:type sign:sign callback:^(id obj) {
        DLog(@"更换手机号发送验证码=====%@",obj);
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic=obj;
            if ([dic[@"code"] intValue] == 2000) {
                
            }else{
                [SVProgressHUD showErrorWithStatus:obj[@"msg"]];
            }
        }
    }];
}


//限制输入框输入位数
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField==self.phoneNumberTF) {
        if (range.location>10) {
            return NO;
        }
    }
    if (textField==self.smsAuthNumTF) {
        if (range.location>5) {
            return NO;
        }
    }
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 1) {
        return 50;
    }else if (indexPath.row == 2){
        return ((kWidth - 60) / 3) * 7 / 9 + 55 + ((kWidth - 60) / 3) * 7 / 9 + 20;
    }
    return 350;
}

- (void)detectionIdCardTFText:(NSNotification *)note {
    [self detectionUserInpute];
}

- (void)detectionAuthCodeTFText:(NSNotification *)note
{
    [self detectionUserInpute];
}

- (void)detectionUserInpute {
    if (self.phoneNumberTF.text.length == 11 && self.smsAuthNumTF.text.length == 6) {
        self.submitBT.userInteractionEnabled=YES;
        self.submitBT.backgroundColor=[UIColor zheJiangBusinessRedColor];
    }else {
        self.submitBT.userInteractionEnabled=NO;
        self.submitBT.backgroundColor=[UIColor typefaceGrayColor];
    }
}

- (void)authCodeTFDisrespond{
    [self.smsAuthNumTF becomeFirstResponder];
}
- (void)smsAuthTFDisrespond
{
    [self.smsAuthNumTF resignFirstResponder];
}

- (void)UIDecorate
{
    if (IS_iPhoneX) {
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, iPhoneX_Navigition_Bar_Height)];
    }else{
        _customNav = [[CustomerNavgationController alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    _customNav.titleLabel.text = @"更换手机号";
    self.title = @"更换手机号";
    [self.view addSubview:_customNav];
    __weak typeof (self) weakSelf = self;
    _customNav.leftViewController = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    self.tableView = [[UITableView alloc] init];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor backgroundGrayColor];
    self.tableView.bounces = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.customNav.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.showsVerticalScrollIndicator = NO;//去掉竖直方向的滑动条
    
    //手机号输入框
    _phoneNumberTF=[[UITextField alloc] init];
    _phoneNumberTF.delegate=self;
    _phoneNumberTF.placeholder=@"请输入新手机号";
    _phoneNumberTF.keyboardType=UIKeyboardTypeNumberPad;//数字键盘
    _phoneNumberTF.font=[UIFont systemFontOfSize:14];
    _phoneNumberTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    UIView *phoneTFDis=[AddCancelButton addCompleteBTOnVC:self withSelector:@selector(authCodeTFDisrespond) title:@"下一项"];
    [self.phoneNumberTF setInputAccessoryView:phoneTFDis];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectionIdCardTFText:) name:UITextFieldTextDidChangeNotification object:self.phoneNumberTF];
    
    //验证码输入框
    _smsAuthNumTF = [[UITextField alloc] init];
    _smsAuthNumTF.delegate = self;
    _smsAuthNumTF.placeholder = @"请输入短信验证码";
    _smsAuthNumTF.font = [UIFont systemFontOfSize:14];
    _smsAuthNumTF.keyboardType = UIKeyboardTypeNumberPad;
    _smsAuthNumTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIView *authCodeTFDis=[AddCancelButton addCompleteBTOnVC:self withSelector:@selector(smsAuthTFDisrespond) title:@"完成"];
    [_smsAuthNumTF setInputAccessoryView:authCodeTFDis];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectionAuthCodeTFText:) name:UITextFieldTextDidChangeNotification object:_smsAuthNumTF];
    
    _handsetPhoto = [UIButton buttonWithType:UIButtonTypeCustom];;
    _handsetPhoto.backgroundColor = [UIColor typefaceGrayColor];
    _handsetPhoto.tag = 1;
    [_handsetPhoto addTarget:self action:@selector(checkPhone:) forControlEvents:UIControlEventTouchUpInside];
    
    _image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"添加.png"]];
    [_handsetPhoto addSubview:_image];
    [_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_handsetPhoto.mas_centerX);
        make.height.equalTo(@16);
        make.width.equalTo(@16);
        make.centerY.equalTo(_handsetPhoto.mas_centerY);
    }];
    _label = [[UILabel alloc] init];
    _label.text = @"手持身份证照片";
    _label.font = [UIFont systemFontOfSize:12];
    _label.textColor = [UIColor depictBorderGrayColor];
    [_handsetPhoto addSubview:_label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_handsetPhoto.mas_centerX);
        make.height.equalTo(@15);
        make.bottom.equalTo(_handsetPhoto.mas_bottom).offset(-5);
    }];
    
    
    _frontPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    _frontPhoto.backgroundColor = [UIColor typefaceGrayColor];
    _frontPhoto.tag = 2;
    [_frontPhoto addTarget:self action:@selector(checkPhone:) forControlEvents:UIControlEventTouchUpInside];
    
    _image2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"添加.png"]];
    [_frontPhoto addSubview:_image2];
    [_image2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_frontPhoto.mas_centerX);
        make.height.equalTo(@16);
        make.width.equalTo(@16);
        make.centerY.equalTo(_frontPhoto.mas_centerY);
    }];
    _label2 = [[UILabel alloc] init];
    _label2.text = @"身份证正面照片";
    _label2.font = [UIFont systemFontOfSize:12];
    _label2.textColor = [UIColor depictBorderGrayColor];
    [_frontPhoto addSubview:_label2];
    [_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_frontPhoto.mas_centerX);
        make.height.equalTo(@15);
        make.bottom.equalTo(_frontPhoto.mas_bottom).offset(-5);
    }];
    
    
    _backPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    _backPhoto.backgroundColor = [UIColor typefaceGrayColor];
    [_backPhoto addTarget:self action:@selector(checkPhone:) forControlEvents:UIControlEventTouchUpInside];
    _backPhoto.tag = 3;
    
    _image3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"添加.png"]];
    [_backPhoto addSubview:_image3];
    [_image3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_backPhoto.mas_centerX);
        make.height.equalTo(@16);
        make.width.equalTo(@16);
        make.centerY.equalTo(_backPhoto.mas_centerY);
    }];
    _label3 = [[UILabel alloc] init];
    _label3.text = @"身份证背面照片";
    _label3.font = [UIFont systemFontOfSize:12];
    _label3.textColor = [UIColor depictBorderGrayColor];
    [_backPhoto addSubview:_label3];
    [_label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_backPhoto.mas_centerX);
        make.height.equalTo(@15);
        make.bottom.equalTo(_backPhoto.mas_bottom).offset(-5);
    }];
    
    _promptLB = [[UILabel alloc] init];
    _promptLB.text = @"提示: 更换成功后, 登录手机号和江西银行电子账户手机号同步修改";
    _promptLB.font = [UIFont systemFontOfSize:13];
    _promptLB.textColor = [UIColor zheJiangBusinessRedColor];
    _promptLB.numberOfLines = 0;
    
    _submitBT=[RoundCornerClickBT buttonWithType:UIButtonTypeCustom];
    [_submitBT setTitle:@"提交审核" forState:UIControlStateNormal];
    _submitBT.titleLabel.font=[UIFont systemFontOfSize:16];
    _submitBT.backgroundColor=[UIColor typefaceGrayColor];
    _submitBT.userInteractionEnabled=NO;
    [FastAnimationAdd codeBindAnimation:_submitBT];
    [_submitBT addTarget:self action:@selector(checkSendAuthCodeBT:) forControlEvents:UIControlEventTouchUpInside];
    
    _textLabel = [[UILabel alloc] init];
    _textLabel.numberOfLines = 0;
    _textLabel.text = @"照片要求：\n1、手持身份证照片及身份证照片需为该注册用户本人；\n2、手持身份证照片面部及身份证信息需清晰可见；\n3、手持身份证照片放大后，身份证信息需清晰可见、字迹无模糊、无遮挡的情况；\n特别提示：\n1、资料提交后，客服人员会在3个工作日内审核完成；\n2、手机号更换完成后，原手机号将无法登录，请知悉";
    _textLabel.textColor = [UIColor characterBlackColor];
    _textLabel.font = [UIFont systemFontOfSize:12];
    
    //放三张示例图片
    _labelOne = [[UILabel alloc] init];
    _labelOne.text = @"示例1";
    _labelOne.font = [UIFont systemFontOfSize:12];
    _labelOne.textColor = [UIColor characterBlackColor];
    _imageOne = [[UIImageView alloc] init];
    _imageOne.image = [UIImage imageNamed:@"示例1.png"];
    
    _labelTwo = [[UILabel alloc] init];
    _labelTwo.text = @"示例2";
    _labelTwo.font = [UIFont systemFontOfSize:12];
    _labelTwo.textColor = [UIColor characterBlackColor];
    _imageTwo = [[UIImageView alloc] init];
    _imageTwo.image = [UIImage imageNamed:@"示例2.png"];
    
    _labelThree = [[UILabel alloc] init];
    _labelThree.text = @"示例3";
    _labelThree.font = [UIFont systemFontOfSize:12];
    _labelThree.textColor = [UIColor characterBlackColor];
    _imageThree = [[UIImageView alloc] init];
    _imageThree.image = [UIImage imageNamed:@"示例3.png"];
    
    [self.tableView reloadData];
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

