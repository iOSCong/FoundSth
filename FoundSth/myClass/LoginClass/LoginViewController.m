//
//  LoginViewController.m
//  HZMHIOS
//
//  Created by MCEJ on 2017/12/27.
//  Copyright © 2017年 MCEJ. All rights reserved.
//

#import "LoginViewController.h"
#import "WSLoginView.h"
#import "FoundListViewController.h"
#import "MHNavViewController.h"
#import "MHTabBarViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

//- (void)loginNotice
//{
//    [MHProgressHUD showMsgWithoutView:@"登录失败,账号或密码已失效!"];
//}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [AVAnalytics beginLogPageView:@"LoginView"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [AVAnalytics endLogPageView:@"LoginView"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    WSLoginView *wsLoginV = [[WSLoginView alloc]initWithFrame:CGRectMake(0, 0, mz_width, mz_height)];
    wsLoginV.titleLabel.text = @"帮我找";
    wsLoginV.titleLabel.textColor = [UIColor grayColor];
    wsLoginV.hideEyesType = LeftEyeHide;
    [self.view addSubview:wsLoginV];
    
    //取消登录
    [wsLoginV setClickCancelBlock:^{
        [self dismissViewControllerAnimated:YES completion:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"loginView" object:nil userInfo:@{@"tag":@"2"}]];
    }];
    
    //登录
    [wsLoginV setClickLoginBlock:^(NSString *textField1Text, NSString *textField2Text) {
        if (![textField1Text isEqualToString:@""] && ![textField2Text isEqualToString:@""]) {
            [MHProgressHUD showProgress:@"正在登录..." inView:self.view];
            [AVUser logInWithUsernameInBackground:textField1Text password:textField2Text block:^(AVUser *user, NSError *error) {
                [MHProgressHUD hide];
                if (user) {
                    //存储账户
                    [NSStrObject saveAccount:textField1Text];
                    
                    //存储用户信息
                    AVFile *userAvatar = [user objectForKey:@"avatar"];
                    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                    [userInfo setValue:user.username forKey:@"username"];
                    [userInfo setValue:user.objectId forKey:@"objectId"];
                    [userInfo setValue:userAvatar.url forKey:@"url"];
                    [NSStrObject saveUserInfos:userInfo];
                    
                    [MHProgressHUD showMsgWithoutView:@"登录成功"];
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                    //通过通知中心发送通知
                    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"loginView" object:nil userInfo:@{@"tag":@"1"}]];
                    
                } else {
                    NSLog(@"登录失败：%@",error);
                    [MHProgressHUD showMsgWithoutView:@"登录失败"];
                }
            }];
        }else{
            [MHProgressHUD showMsgWithoutView:@"请输入正确的账号或密码"];
        }
    }];
    
    [wsLoginV setClickRegisteBlock:^(AVUser *user, NSString *simCode) {
        if (simCode.length != 6) {
            [MHProgressHUD showMsgWithoutView:@"请输入6位正确的验证码"];
        }else{
            [MHProgressHUD showProgress:@"正在注册..." inView:self.view];
            [AVUser verifyMobilePhone:simCode withBlock:^(BOOL succeeded, NSError *error) {
                [MHProgressHUD hide];
                if (!error) {
                    if (user) {
                        //存储账户密码
                        [NSStrObject saveAccount:user.username];
                        
                        //存储用户信息
                        AVFile *userAvatar = [user objectForKey:@"avatar"];
                        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                        [userInfo setValue:user.username forKey:@"username"];
                        [userInfo setValue:user.objectId forKey:@"objectId"];
                        [userInfo setValue:userAvatar.url forKey:@"url"];
                        [NSStrObject saveUserInfos:userInfo];
                        
                        [MHProgressHUD showMsgWithoutView:@"注册成功"];
                        
                        [self dismissViewControllerAnimated:YES completion:nil];
                        //通过通知中心发送通知
                        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"loginView" object:nil userInfo:@{@"tag":@"1"}]];
                        
                    } else {
                        NSLog(@"登录失败：%@",error);
                        [MHProgressHUD showMsgWithoutView:@"登录失败,请稍后再试!"];
                    }
                } else {
                    NSLog(@"登录失败：%@",error);
                    [MHProgressHUD showMsgWithoutView:@"短信验证码验证失败!"];
                }
            }];
        }
    }];
    
    /*
    //注册
    [wsLoginV setClickLostBlock:^(NSString *textField1Text, NSString *textField2Text) {
        if (![textField1Text isEqualToString:@""] && ![textField2Text isEqualToString:@""]) {
            if (textField1Text.length != 11) {
                [MHProgressHUD showMsgWithoutView:@"请输入11位正确的手机号码"];
            }else{
                if ([self validateCellPhoneNumber:textField1Text]) {
                    [MHProgressHUD showProgress:@"正在注册..." inView:self.view];
                    AVUser *user = [AVUser user];
                    user.username = textField1Text;
                    user.password = textField2Text;
                    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            // 注册成功直接登录
                            [AVUser logInWithUsernameInBackground:user.username password:user.password block:^(AVUser *user, NSError *error){
                                [MHProgressHUD hide];
                                if (user) {
                                    //存储账户密码
                                    [NSStrObject saveAccount:textField1Text];
                                    
                                    //存储用户信息
                                    AVFile *userAvatar = [user objectForKey:@"avatar"];
                                    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                                    [userInfo setValue:user.username forKey:@"username"];
                                    [userInfo setValue:user.objectId forKey:@"objectId"];
                                    [userInfo setValue:userAvatar.url forKey:@"url"];
                                    [NSStrObject saveUserInfos:userInfo];
                                    
                                    [self dismissViewControllerAnimated:YES completion:nil];
                                    //通过通知中心发送通知
                                    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"loginView" object:nil userInfo:@{@"tag":@"1"}]];
                                    
                                } else {
                                    NSLog(@"登录失败：%@",error);
                                    [MHProgressHUD showMsgWithoutView:@"登录失败,请稍后再试!"];
                                }
                            }];
                        }else if(error.code == 202){
                            //注册失败的原因可能有多种，常见的是用户名已经存在。
                            NSLog(@"注册失败，用户名已经存在");
                            [MHProgressHUD showMsgWithoutView:@"注册失败，用户名已存在"];
                        }else{
                            NSLog(@"注册失败：%@",error.localizedFailureReason);
                            [MHProgressHUD showMsgWithoutView:@"注册失败!"];
                        }
                    }];

                }else{
                    [MHProgressHUD showMsgWithoutView:@"手机号码有误,请重新输入"];
                }
            }
//            [MHProgressHUD showProgress:@"正在注册..." inView:self.view];
//            [AVUser signUpOrLoginWithMobilePhoneNumberInBackground:textField1Text smsCode:textField2Text block:^(AVUser *user, NSError *error) {
//                [MHProgressHUD hide];
//                if (user) {
//                    //存储账户
//                    [NSStrObject saveAccount:textField1Text];
//
//                    //存储用户信息
//                    AVFile *userAvatar = [user objectForKey:@"avatar"];
//                    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//                    [userInfo setValue:user.username forKey:@"username"];
//                    [userInfo setValue:user.objectId forKey:@"objectId"];
//                    [userInfo setValue:userAvatar.url forKey:@"url"];
//                    [NSStrObject saveUserInfos:userInfo];
//
//                    [self dismissViewControllerAnimated:YES completion:nil];
//                    //通过通知中心发送通知
//                    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"loginView" object:nil userInfo:@{@"tag":@"1"}]];
//
//                } else {
//                    NSLog(@"注册失败：%@",error);
//                    [MHProgressHUD showMsgWithoutView:@"注册失败,请稍后再试!"];
//                }
//            }];
        }else{
            [MHProgressHUD showMsgWithoutView:@"请输入账号和密码"];
        }
        
    }];*/
    
//    //注册
//    [wsLoginV setClickLostBlock:^(NSString *textField1Text, NSString *textField2Text) {
//        if (![textField1Text isEqualToString:@""] && ![textField2Text isEqualToString:@""]) {
//            [MHProgressHUD showProgress:@"正在注册..." inView:self.view];
//            AVUser *user = [AVUser user];
//            user.username = textField1Text;
//            user.password = textField2Text;
//            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                if (succeeded) {
//                    // 注册成功直接登录
//                    [AVUser logInWithUsernameInBackground:user.username password:user.password block:^(AVUser *user, NSError *error){
//                        [MHProgressHUD hide];
//                        if (user) {
//                            //存储账户密码
//                            [NSStrObject saveAccount:textField1Text];
//
//                            //存储用户信息
//                            AVFile *userAvatar = [user objectForKey:@"avatar"];
//                            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//                            [userInfo setValue:user.username forKey:@"username"];
//                            [userInfo setValue:user.objectId forKey:@"objectId"];
//                            [userInfo setValue:userAvatar.url forKey:@"url"];
//                            [NSStrObject saveUserInfos:userInfo];
//
//                            [self dismissViewControllerAnimated:YES completion:nil];
//                            //通过通知中心发送通知
//                            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"loginView" object:nil userInfo:@{@"tag":@"1"}]];
//
//                        } else {
//                            NSLog(@"登录失败：%@",error);
//                            [MHProgressHUD showMsgWithoutView:@"登录失败,请稍后再试!"];
//                        }
//                    }];
//                }else if(error.code == 202){
//                    //注册失败的原因可能有多种，常见的是用户名已经存在。
//                    NSLog(@"注册失败，用户名已经存在");
//                    [MHProgressHUD showMsgWithoutView:@"注册失败，用户名已存在"];
//                }else{
//                    NSLog(@"注册失败：%@",error.localizedFailureReason);
//                    [MHProgressHUD showMsgWithoutView:@"注册失败!"];
//                }
//            }];
//        }else{
//            [MHProgressHUD showMsgWithoutView:@"请输入账号和密码"];
//        }
//
//    }];
    
}


- (BOOL)validateCellPhoneNumber:(NSString *)cellNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,175,176,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|7[56]|8[56])\\d{8}$";
    
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,177,180,189
     22         */
    NSString * CT = @"^1((33|53|77|8[09])[0-9]|349)\\d{7}$";
    
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    // NSPredicate *regextestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if(([regextestmobile evaluateWithObject:cellNum] == YES)
       || ([regextestcm evaluateWithObject:cellNum] == YES)
       || ([regextestct evaluateWithObject:cellNum] == YES)
       || ([regextestcu evaluateWithObject:cellNum] == YES)){
        return YES;
    }else{
        return NO;
    }
}



-(void)dealloc{
    NSLog(@"移除了所有的通知");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
