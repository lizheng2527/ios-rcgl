//
//  LoginViewController.m
//  PadEvaluate
//
//  Created by hzth-mac3 on 15/12/15.
//  Copyright © 2015年 hzth-mac3. All rights reserved.
//

#import "LoginViewController.h"
#import "EValuateiewController.h"
#import "IndicatorView.h"
#import "TYHHttpTool.h"
#import "NetworkHelper.h"
#import "Public.h"
#import "UIView+Toast.h"
#import "EvaluateModel.h"
#import "MJExtension.h"
#import "PadNavigationController.h"
#import "MBProgressHUD.h"


#define saveServerURLAlert 11001


@interface LoginViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate,MBProgressHUDDelegate>

@property(nonatomic,retain)UITextField *inputAddressField;
@property (weak, nonatomic) IBOutlet UIImageView *defaultImage;
@property(nonatomic,retain)NSUserDefaults *loginNameDefaults;
@property(nonatomic,retain)NSUserDefaults *loginPassWordDefaults;
@property (strong, nonatomic) IndicatorView *indicatorView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.indicatorView = [[IndicatorView alloc] initWithFrame:self.view.frame];
    
    
    _loginNameDefaults = [NSUserDefaults standardUserDefaults];
    _loginPassWordDefaults = [NSUserDefaults standardUserDefaults];
    
    self.loginName.delegate = self;
    self.loginName.tag = 100;
    self.password.delegate = self;
    self.password.tag = 102;

    [self.scrollView contentSizeToFit];
    
    
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressBtn:)];
    gesture.delegate = self;
    self.defaultImage.userInteractionEnabled = YES;
    gesture.minimumPressDuration = 1;
    [self.defaultImage addGestureRecognizer:gesture];

    
}

-(void)longPressBtn:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        //长按事件开始"
        //do something
        [self popDeclaredAlertView];
    }
    else if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        //长按事件结束
        //do something
    }
}
-(void)popDeclaredAlertView
{
    UIAlertView *alertView = alertView = [[UIAlertView alloc] initWithTitle:@"配置服务器地址" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.delegate = self;
    alertView.tag = saveServerURLAlert;
    
    _inputAddressField = [alertView textFieldAtIndex:0];
    _inputAddressField.tag = 100001;
    _inputAddressField.text = BaseUrl;
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.view endEditing:YES];
    if (alertView.tag == saveServerURLAlert) {
        if (buttonIndex == 1) {
            //            MBProgressHUD* HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //            HUD.delegate = self;
            //            HUD.labelFont = [UIFont systemFontOfSize:12];
            //            HUD.detailsLabelText = @"配置服务器中...";
            
            if (1) {
                [self.view makeToast:@"配置服务器地址成功" duration:1 position:nil];
                [[NSUserDefaults standardUserDefaults]setValue:_inputAddressField.text forKey:USER_DEFAULT_BASEURL];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                //
                //
                //                NSString *lenthString = @"/dc-learningplatform";
                //
                //
                //
                
                NSMutableString *tmpString = [NSMutableString stringWithString:_inputAddressField.text];
                NSArray *array = [tmpString componentsSeparatedByString:@"/"];
                NSString *lenthString = [NSString stringWithFormat:@"%@",array.lastObject];
                
                
                [tmpString replaceOccurrencesOfString:lenthString withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(tmpString.length - lenthString.length - 1, lenthString.length + 1)];
                [[NSUserDefaults standardUserDefaults]setValue:tmpString forKey:USER_DEFAULT_IMAGE_BASEURL];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            //            else
            //            {
            //                [self.view makeToast:@"验证服务器地址失败" duration:1 position:nil];
            //                [HUD removeFromSuperview];
            //            }
            
        }
    }
}

- (void)saveData {

    //  保存用户和密码
    self.loginName.text = [_loginNameDefaults objectForKey:USER_DEFAULT_LOGINNAME];
    self.password.text = [_loginPassWordDefaults objectForKey:USER_DEFAULT_PASSWORD];
    [_loginPassWordDefaults synchronize];
    [_loginNameDefaults synchronize];
    
}

//关闭键盘(TextView) 换行时。隐藏键盘
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.password == textField) {
        if ([string isEqualToString:@"\n"]) {
            return YES;
        }
        if (self.password.text) {
            _loginBtn.selected = YES;
        }
    }
    if (_loginName == textField) {
        _password.text = @"";
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 100) {
        
        [_loginNameDefaults setObject:[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:USER_DEFAULT_LOGINNAME];
    }else if (textField.tag == 102){
        [_loginPassWordDefaults setObject:textField.text forKey:USER_DEFAULT_PASSWORD];
    }

}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == _loginName)
    {
        [_password becomeFirstResponder];
    }
    if (textField == _password) {
        [self loginToMainView:_loginBtn];
    }
    return YES;
}


- (IBAction)loginToMainView:(id)sender {
//    EValuateiewController *main = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EValuateiewController"];
//     PadNavigationController * pad = [[PadNavigationController alloc] initWithRootViewController:main];
//    [self presentViewController:pad animated:YES completion:nil];
//    
//    return;
    
    [self.view endEditing:YES];
    
    if (![NetworkHelper connectedToNetwork]) {
        [self loginFailureHandle:LoginStatusNetworkException];
        return;
    }
    if ([self.loginName.text isEqualToString:@""] || [self.password.text isEqualToString:@""]) {
        [self.view makeToast:@"用户名或密码不能为空" duration:0.5 position:nil];
        return;
    }
    
    
    [self.indicatorView showInWindow:self.view.window];
    
    
    
    //处理登录名空格
    NSString *loginName = [_loginName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString * urlStrr  = [NSString stringWithFormat:@"%@/bd/welcome!ajaxValidationUser.action?sys_auto_authenticate=true&sys_username=%@&sys_password=%@&loginName=%@&password=%@",BaseUrl,loginName,_password.text,loginName,_password.text];

    
//    NSString *urlStr = [urlStrr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    
//    NSLog(@"urlStr === %@",urlStr);
    
//    /tp/mobile/teacherPlatform!getEvaluateStandard.action
    [TYHHttpTool gets:urlStrr params:nil success:^(id json) {
        
        NSLog(@"%@",json);
        
        // 保存用户和密码
        [self saveData];
        [self loginMain];
        
        [self.indicatorView hideInWindow:self.view.window];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
        [self loginFailureHandle:LoginStatusServerException];
    }];
    
}

- (void)loginMain {

    NSString *loginName = [_loginName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString * urlStr  = [NSString stringWithFormat:@"%@/bd/user!getUserInfo.action?sys_auto_authenticate=true&sys_username=%@&sys_password=%@",BaseUrl,loginName,_password.text];
    
    NSLog(@"urlStr === %@",urlStr);
    
    [TYHHttpTool get:urlStr params:nil success:^(id json) {
    
        NSLog(@"%@",json);
        
        EValuateiewController *main = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EValuateiewController"];
        PadNavigationController * pad = [[PadNavigationController alloc] initWithRootViewController:main];
        
        
        // 字典转模型
        EvaluateModel * model = [EvaluateModel mj_objectWithKeyValues:json];
        main.model = model;
        
//        [self.navigationController pushViewController:main animated:YES];
        [self presentViewController:pad animated:YES completion:nil];
        
        
    } failure:^(NSError *error) {
        
        [self loginFailureHandle:LoginStatusFailure];
        NSLog(@"%@",error);
    }];
}

-(void)loginFailureHandle:(LoginStatus)status{
    [self.indicatorView hideInWindow:self.view.window];
    NSString *message = nil;
    switch (status) {
        case LoginStatusFailure:
            message = @"用户名或密码错误！";
            ////            [self validationFailureAnimate];
            break;
        case LoginStatusServerException:
            message = @"服务器异常";
            break;
        case LoginStatusNetworkException:
            message = @"请检查网络设置";
            break;
        default:
            break;
    }
    if (message) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0

- (NSUInteger)supportedInterfaceOrientations

#else

- (UIInterfaceOrientationMask)supportedInterfaceOrientations

#endif

{
    
    return UIInterfaceOrientationMaskPortrait;
    
}
- (void)viewWillAppear:(BOOL)animated {

    if ([[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME]) {
        _loginName.text = [_loginNameDefaults valueForKey:USER_DEFAULT_LOGINNAME];
        _password.text = [_loginPassWordDefaults valueForKey:USER_DEFAULT_PASSWORD];
    }
}
@end
