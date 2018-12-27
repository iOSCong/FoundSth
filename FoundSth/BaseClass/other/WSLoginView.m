//
//  WSLoginView.m
//  WSLoginView
//
//  Created by iMac on 16/12/23.
//  Copyright © 2016年 zws. All rights reserved.
//

#import "WSLoginView.h"

typedef NS_ENUM(NSInteger, WSLoginShowType) {
    WSLoginShowType_NONE,
    WSLoginShowType_USER,
    WSLoginShowType_PASS
};
@interface WSLoginView ()<UITextFieldDelegate>

@property (nonatomic,strong)UIScrollView *scrollView;

@end


@implementation WSLoginView {
    WSLoginShowType showType;

    UIVisualEffectView *smallView;

    UIImageView* imgLeftHand;
    UIImageView* imgRightHand;
    
    UIImageView* imgLeftHandGone;
    UIImageView* imgRightHandGone;

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self creatVisulBg];
        
        [self creatSubViews];
        
    }
    
    return self;
}

- (void)creatVisulBg {
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.bounds];
    
    imageview.image = [UIImage imageNamed:@"bg.jpeg"];
    imageview.contentMode = UIViewContentModeScaleToFill;
    imageview.userInteractionEnabled = YES;
    [self addSubview:imageview];
    
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    effectview.frame = CGRectMake(0, 0, imageview.frame.size.width, imageview.frame.size.height);
    [imageview addSubview:effectview];
    
}

//- (void)loginViewNotice:(NSNotification *)notice
//{
//    if ([notice.userInfo[@"tag"] isEqualToString:@"5"]) { //注册成功
//        [UIView animateWithDuration:0.3f animations:^{
//            self.scrollView.contentOffset = CGPointMake(0, 0);
//        }];
//    }
//}

- (void)creatSubViews {
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginViewNotice:)name:@"loginView" object:nil];
    
    _hideEyesType = AllEyesHide;
    
    //猫头
    UIImageView* imgLogin = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 211 / 2, 150-99, 211, 108)];
    imgLogin.image = [UIImage imageNamed:@"owl-login"];
    imgLogin.layer.masksToBounds = YES;
    [self addSubview:imgLogin];
    
    //取消登录
    self.cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-60, 20, 60, 40)];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelBtn];
    
    //捂眼的左右爪
    imgLeftHand = [[UIImageView alloc] initWithFrame:CGRectMake(1, 90, 40, 65)];
    imgLeftHand.image = [UIImage imageNamed:@"owl-login-arm-left"];
    [imgLogin addSubview:imgLeftHand];
    
    imgRightHand = [[UIImageView alloc] initWithFrame:CGRectMake(imgLogin.frame.size.width / 2 + 60, 90, 40, 65)];
    imgRightHand.image = [UIImage imageNamed:@"owl-login-arm-right"];
    [imgLogin addSubview:imgRightHand];
    
    //展开的左右爪
    imgLeftHandGone = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - 100, 150-22, 40, 40)];
    imgLeftHandGone.image = [UIImage imageNamed:@"icon_hand"];
    [self addSubview:imgLeftHandGone];
    
    
    imgRightHandGone = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 + 62,  150-22, 40, 40)];
    imgRightHandGone.image = [UIImage imageNamed:@"icon_hand"];
    [self addSubview:imgRightHandGone];
    
    
    smallView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    smallView.frame = CGRectMake(20, 150, self.frame.size.width-40, self.frame.size.width-40);
    smallView.layer.cornerRadius = 5;
    smallView.layer.masksToBounds = YES;
    [self addSubview:smallView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 150, smallView.frame.size.width, smallView.frame.size.height-80)];
    scrollView.contentSize = CGSizeMake((smallView.frame.size.width)*2, smallView.frame.size.height-80);
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView = scrollView;
    [self addSubview:scrollView];
    
    UIView *loginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, smallView.frame.size.width, smallView.frame.size.height)];
    [scrollView addSubview:loginView];
    
    UIButton *goRegisteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goRegisteBtn.frame = CGRectMake(loginView.frame.size.width-95, 15, 100, 20);
    [goRegisteBtn setTitle:@"注册 >" forState:UIControlStateNormal];
    goRegisteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [goRegisteBtn addTarget:^(UIButton *button) {
        [UIView animateWithDuration:0.3f animations:^{
            scrollView.contentOffset = CGPointMake(smallView.frame.size.width, 0);
        }];
    }];
    [loginView addSubview:goRegisteBtn];
    
    UIView *registeView = [[UIView alloc] initWithFrame:CGRectMake(smallView.frame.size.width, 0, smallView.frame.size.width, smallView.frame.size.height)];
    [scrollView addSubview:registeView];
    
    UIButton *goLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goLoginBtn.frame = CGRectMake(-10, 15, 100, 20);
    [goLoginBtn setTitle:@"< 登录" forState:UIControlStateNormal];
    goLoginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [goLoginBtn addTarget:^(UIButton *button) {
        [UIView animateWithDuration:0.3f animations:^{
            scrollView.contentOffset = CGPointMake(0, 0);
        }];
    }];
    [registeView addSubview:goLoginBtn];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, smallView.frame.size.width-20, 20)];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [loginView addSubview:self.titleLabel];
    
    self.logNameTextF = [[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.titleLabel.frame)+15, smallView.frame.size.width-40, 40)];
    self.logNameTextF.delegate = self;
    self.logNameTextF.layer.cornerRadius = 5;
    self.logNameTextF.layer.borderWidth = .5;
    self.logNameTextF.keyboardType = UIKeyboardTypePhonePad; //UIKeyboardTypeASCIICapable
    self.logNameTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.logNameTextF.layer.borderColor = [UIColor grayColor].CGColor;
    self.logNameTextF.placeholder = @"请输入登录手机号码";
    self.logNameTextF.text = [NSStrObject getAccount].length ? [NSStrObject getAccount] : @"";
    self.logNameTextF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetHeight(self.logNameTextF.frame), CGRectGetHeight(self.logNameTextF.frame))];
    self.logNameTextF.leftViewMode = UITextFieldViewModeAlways;
    UIImageView* imgUser = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9, 22, 22)];
    imgUser.image = [UIImage imageNamed:@"iconfont-user"];
    [self.logNameTextF.leftView addSubview:imgUser];
    [loginView addSubview:self.logNameTextF];
    
    self.logPassTextF = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.logNameTextF.frame), CGRectGetMaxY(self.logNameTextF.frame)+10, self.logNameTextF.frame.size.width-60, CGRectGetHeight(self.logNameTextF.frame))];
    self.logPassTextF.delegate = self;
    self.logPassTextF.layer.cornerRadius = 5;
    self.logPassTextF.layer.borderWidth = .5;
    self.logPassTextF.keyboardType = UIKeyboardTypeNumberPad;
    self.logPassTextF.returnKeyType = UIReturnKeyDone;
    self.logPassTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.logPassTextF.layer.borderColor = [UIColor grayColor].CGColor;
    self.logPassTextF.placeholder = @"请输入短信验证码";
    self.logPassTextF.secureTextEntry = YES;
//    self.logPassTextF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetHeight(self.logPassTextF.frame), CGRectGetHeight(self.logPassTextF.frame))];
//    self.logPassTextF.leftViewMode = UITextFieldViewModeAlways;
//    UIImageView* imgPwd = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 28, 28)];
//    imgPwd.image = [UIImage imageNamed:@"iconfont-password"];
//    [self.logPassTextF.leftView addSubview:imgPwd];
    [loginView addSubview:self.logPassTextF];
    
    UIButton *logSimBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logSimBtn.frame = CGRectMake(CGRectGetWidth(self.logNameTextF.frame)-30, CGRectGetMaxY(self.logNameTextF.frame)+10, 50, CGRectGetHeight(self.logNameTextF.frame));
    [logSimBtn setTitle:@"获取" forState:UIControlStateNormal];
    [logSimBtn setTitleColor:[UIColor colorWithRed:83/255.0 green:149/255.0 blue:232/255.0 alpha:1] forState:UIControlStateNormal];
    logSimBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    logSimBtn.layer.cornerRadius = 5;
    logSimBtn.layer.borderWidth = .5;
    logSimBtn.layer.borderColor = [UIColor grayColor].CGColor;
    [logSimBtn addTarget:^(UIButton *button) {
        if ([self.logNameTextF.text isEqualToString:@""]) {
            [MHProgressHUD showMsgWithoutView:@"请输入手机号码"];
        }else if (self.logNameTextF.text.length != 11) {
            [MHProgressHUD showMsgWithoutView:@"请输入11位正确的手机号码"];
        }else{
            [MHProgressHUD showProgress:@"正在获取..." inView:self];
            [AVUser requestLoginSmsCode:self.logNameTextF.text withBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [MHProgressHUD hide];
                    [MHProgressHUD showMsgWithoutView:@"短信验证码已发送"];
                }else{
                    NSLog(@"登录error==%@",error);
                    [MHProgressHUD showMsgWithoutView:@"发送短信过快，请稍后重试"];
                }
            }];
        }
    }];
    [loginView addSubview:logSimBtn];
    
    
    
    self.regNameTextF = [[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.titleLabel.frame)+15, smallView.frame.size.width-40, 40)];
    self.regNameTextF.delegate = self;
    self.regNameTextF.layer.cornerRadius = 5;
    self.regNameTextF.layer.borderWidth = .5;
    self.regNameTextF.keyboardType = UIKeyboardTypePhonePad;
    self.regNameTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.regNameTextF.layer.borderColor = [UIColor grayColor].CGColor;
    self.regNameTextF.placeholder = @"请输入注册手机号码";
    self.regNameTextF.text = [NSStrObject getAccount].length ? [NSStrObject getAccount] : @"";
    self.regNameTextF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetHeight(self.logNameTextF.frame), CGRectGetHeight(self.logNameTextF.frame))];
    self.regNameTextF.leftViewMode = UITextFieldViewModeAlways;
    UIImageView* regUser = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9, 22, 22)];
    regUser.image = [UIImage imageNamed:@"iconfont-user"];
    [self.regNameTextF.leftView addSubview:regUser];
    [registeView addSubview:self.regNameTextF];
    
    self.regSimTextF = [[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.regNameTextF.frame)+10, self.regNameTextF.frame.size.width-60, CGRectGetHeight(self.regNameTextF.frame))];
    self.regSimTextF.delegate = self;
    self.regSimTextF.layer.cornerRadius = 5;
    self.regSimTextF.layer.borderWidth = .5;
    self.regSimTextF.keyboardType = UIKeyboardTypeNumberPad;
    self.regSimTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.regSimTextF.layer.borderColor = [UIColor grayColor].CGColor;
    self.regSimTextF.placeholder = @"请输入短信验证码";
    self.regSimTextF.text = @"";
    [registeView addSubview:self.regSimTextF];
    
    UIButton *getSimBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getSimBtn.frame = CGRectMake(CGRectGetWidth(self.regNameTextF.frame)-30, CGRectGetMaxY(self.regNameTextF.frame)+10, 50, CGRectGetHeight(self.regSimTextF.frame));
    [getSimBtn setTitle:@"获取" forState:UIControlStateNormal];
    [getSimBtn setTitleColor:[UIColor colorWithRed:83/255.0 green:149/255.0 blue:232/255.0 alpha:1] forState:UIControlStateNormal];
    getSimBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    getSimBtn.layer.cornerRadius = 5;
    getSimBtn.layer.borderWidth = .5;
    getSimBtn.layer.borderColor = [UIColor grayColor].CGColor;
    [getSimBtn addTarget:^(UIButton *button) {
        if ([self.regNameTextF.text isEqualToString:@""]) {
            [MHProgressHUD showMsgWithoutView:@"请输入手机号码"];
        }else if (self.regNameTextF.text.length != 11) {
            [MHProgressHUD showMsgWithoutView:@"请输入11位正确的手机号码"];
        }else{
            [MHProgressHUD showProgress:@"正在获取..." inView:self];
            [AVSMS requestShortMessageForPhoneNumber:self.regNameTextF.text options:nil callback:^(BOOL succeeded, NSError * _Nullable error) {
                if (!error) {
                    [MHProgressHUD hide];
                    [MHProgressHUD showMsgWithoutView:@"短信验证码已发送"];
                }else{
                    NSLog(@"注册error==%@",error);
                    [MHProgressHUD showMsgWithoutView:@"发送短信过快，请稍后重试"];
                }
            }];
        }
    }];
    [registeView addSubview:getSimBtn];
    
    
//    self.regPassTextF = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.regNameTextF.frame), CGRectGetMaxY(self.regSimTextF.frame)+10, CGRectGetWidth(self.regNameTextF.frame), CGRectGetHeight(self.regNameTextF.frame))];
//    self.regPassTextF.delegate = self;
//    self.regPassTextF.layer.cornerRadius = 5;
//    self.regPassTextF.layer.borderWidth = .5;
//    self.regPassTextF.returnKeyType = UIReturnKeyDone;
//    self.regPassTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
//    self.regPassTextF.layer.borderColor = [UIColor grayColor].CGColor;
//    self.regPassTextF.placeholder = @"请输入注册密码";
//    self.regPassTextF.secureTextEntry = YES;
//    self.regPassTextF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetHeight(self.regPassTextF.frame), CGRectGetHeight(self.regPassTextF.frame))];
//    self.regPassTextF.leftViewMode = UITextFieldViewModeAlways;
//    UIImageView* regPwd = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 28, 28)];
//    regPwd.image = [UIImage imageNamed:@"iconfont-password"];
//    [self.regPassTextF.leftView addSubview:regPwd];
//    [registeView addSubview:self.regPassTextF];
    
    self.loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.logPassTextF.frame)+10, smallView.frame.size.width-40, 40)];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    self.loginBtn.layer.cornerRadius = 5;
    [self.loginBtn setBackgroundColor:[UIColor colorWithRed:83/255.0 green:149/255.0 blue:232/255.0 alpha:1]];
    [self.loginBtn addTarget:self action:@selector(LoginAction) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:self.loginBtn];
    
    self.lostBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.regSimTextF.frame)+10, smallView.frame.size.width-40, 40)];
    [self.lostBtn setTitle:@"注册" forState:UIControlStateNormal];
    self.lostBtn.layer.cornerRadius = 5;
    [self.lostBtn setBackgroundColor:[UIColor colorWithRed:83/255.0 green:149/255.0 blue:232/255.0 alpha:1]];
    [self.lostBtn addTarget:self action:@selector(registeAction) forControlEvents:UIControlEventTouchUpInside];
    [registeView addSubview:self.lostBtn];
    
    smallView.frame = CGRectMake(20, 150, self.frame.size.width-40, CGRectGetMaxY(self.lostBtn.frame)+15);

}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield
{
    if (aTextfield == self.logNameTextF) {
        [self.logPassTextF becomeFirstResponder];
    }else {
        [aTextfield resignFirstResponder];//关闭键盘
        [self LoginAction];
    }
    return YES;
}

//取消登录
- (void)cancelAction
{
    if (_cancelBlock) {
        _cancelBlock();
    }
}
- (void)setClickCancelBlock:(ClicksCancelBlock)clickBlock{
    _cancelBlock = [clickBlock copy];
}

//登录
- (void)LoginAction
{
    [self.logNameTextF resignFirstResponder];
    [self.logPassTextF resignFirstResponder];
    
    if (_clickBlock) {
        _clickBlock(self.logNameTextF.text, self.logPassTextF.text);
    }
}
- (void)setClickLoginBlock:(ClicksAlertBlock)clickBlock{
    _clickBlock = [clickBlock copy];
}

//注册
- (void)registeAction
{
    [self.regNameTextF resignFirstResponder];
    [self.regSimTextF resignFirstResponder];
    
    if (_lostBlock) {
        _lostBlock(self.regNameTextF.text, self.regSimTextF.text);
    }
}
- (void)setClickLostBlock:(ClicksAlertBlock)clickBlock{
    _lostBlock = [clickBlock copy];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.logNameTextF resignFirstResponder];
    [self.logPassTextF resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.window resignFirstResponder];
    [self endEditing:YES];
}

-(void)setHideEyesType:(HideEyesType)hideEyesType {
    _hideEyesType = hideEyesType;
}

//猫咪动画
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.logNameTextF]) {
        if (showType != WSLoginShowType_PASS)
        {
            showType = WSLoginShowType_USER;
            return;
        }
        showType = WSLoginShowType_USER;
        [UIView animateWithDuration:0.5 animations:^{
            
            imgLeftHand.frame = CGRectMake(imgLeftHand.frame.origin.x - 60, imgLeftHand.frame.origin.y + 30, imgLeftHand.frame.size.width, imgLeftHand.frame.size.height);
            imgRightHand.frame = CGRectMake(imgRightHand.frame.origin.x + 48, imgRightHand.frame.origin.y + 30, imgRightHand.frame.size.width, imgRightHand.frame.size.height);
            
            
            imgLeftHandGone.frame = CGRectMake(imgLeftHandGone.frame.origin.x - 70, imgLeftHandGone.frame.origin.y, 40, 40);
            
            imgRightHandGone.frame = CGRectMake(imgRightHandGone.frame.origin.x + 30, imgRightHandGone.frame.origin.y, 40, 40);
            
            
        } completion:^(BOOL b) {
        }];
        
    }
    else if ([textField isEqual:self.logPassTextF]) {
        if (showType == WSLoginShowType_PASS)
        {
            showType = WSLoginShowType_PASS;
            return;
        }
        showType = WSLoginShowType_PASS;
        
        if (_hideEyesType == AllEyesHide) { //全部遮住
            [UIView animateWithDuration:0.5 animations:^{
                imgLeftHand.frame = CGRectMake(imgLeftHand.frame.origin.x + 60, imgLeftHand.frame.origin.y - 30, imgLeftHand.frame.size.width, imgLeftHand.frame.size.height);
                imgRightHand.frame = CGRectMake(imgRightHand.frame.origin.x - 48, imgRightHand.frame.origin.y - 30, imgRightHand.frame.size.width, imgRightHand.frame.size.height);
                
                
                imgLeftHandGone.frame = CGRectMake(imgLeftHandGone.frame.origin.x + 70, imgLeftHandGone.frame.origin.y, 0, 0);
                
                imgRightHandGone.frame = CGRectMake(imgRightHandGone.frame.origin.x - 30, imgRightHandGone.frame.origin.y, 0, 0);
                
            } completion:^(BOOL b) {
            }];

        }
        else if (_hideEyesType == LeftEyeHide) { //遮住左眼
            [UIView animateWithDuration:0.5 animations:^{
                imgLeftHand.frame = CGRectMake(imgLeftHand.frame.origin.x + 60, imgLeftHand.frame.origin.y - 30, imgLeftHand.frame.size.width, imgLeftHand.frame.size.height);
                imgRightHand.frame = CGRectMake(imgRightHand.frame.origin.x - 48, imgRightHand.frame.origin.y - 30, imgRightHand.frame.size.width, imgRightHand.frame.size.height);
                
                
                imgLeftHandGone.frame = CGRectMake(imgLeftHandGone.frame.origin.x + 70, imgLeftHandGone.frame.origin.y, 0, 0);
                
                imgRightHandGone.frame = CGRectMake(imgRightHandGone.frame.origin.x - 30, imgRightHandGone.frame.origin.y, 0, 0);
                
            } completion:^(BOOL b) {
                
                [UIView animateWithDuration:1.5 animations:^{
                    imgRightHand.transform = CGAffineTransformMakeTranslation(10, 0);
                }];
                
            }];
            
        }
        else if (_hideEyesType == RightEyeHide) { //遮住右眼
            [UIView animateWithDuration:0.5 animations:^{
                imgLeftHand.frame = CGRectMake(imgLeftHand.frame.origin.x + 60, imgLeftHand.frame.origin.y - 30, imgLeftHand.frame.size.width, imgLeftHand.frame.size.height);
                imgRightHand.frame = CGRectMake(imgRightHand.frame.origin.x - 48, imgRightHand.frame.origin.y - 30, imgRightHand.frame.size.width, imgRightHand.frame.size.height);
                
                
                imgLeftHandGone.frame = CGRectMake(imgLeftHandGone.frame.origin.x + 70, imgLeftHandGone.frame.origin.y, 0, 0);
                
                imgRightHandGone.frame = CGRectMake(imgRightHandGone.frame.origin.x - 30, imgRightHandGone.frame.origin.y, 0, 0);
                
            } completion:^(BOOL b) {
                [UIView animateWithDuration:1.5 animations:^{
                    imgLeftHand.transform = CGAffineTransformMakeTranslation(-13, 0);
                }];
            }];
            
        }
        else if (_hideEyesType == NOEyesHide) { //两个都漏一半眼睛
            [UIView animateWithDuration:0.5 animations:^{
                imgLeftHand.frame = CGRectMake(imgLeftHand.frame.origin.x + 60, imgLeftHand.frame.origin.y - 30, imgLeftHand.frame.size.width, imgLeftHand.frame.size.height);
                imgRightHand.frame = CGRectMake(imgRightHand.frame.origin.x - 48, imgRightHand.frame.origin.y - 30, imgRightHand.frame.size.width, imgRightHand.frame.size.height);
                
                
                imgLeftHandGone.frame = CGRectMake(imgLeftHandGone.frame.origin.x + 70, imgLeftHandGone.frame.origin.y, 0, 0);
                
                imgRightHandGone.frame = CGRectMake(imgRightHandGone.frame.origin.x - 30, imgRightHandGone.frame.origin.y, 0, 0);
                
            } completion:^(BOOL b) {
                [UIView animateWithDuration:1.5 animations:^{
                    imgLeftHand.transform = CGAffineTransformMakeTranslation(-13, 0);
                    imgRightHand.transform = CGAffineTransformMakeTranslation(10, 0);
                }];
            }];
            
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if ([textField isEqual:self.logPassTextF]) {
        if (showType == WSLoginShowType_PASS)
        {
            showType = WSLoginShowType_USER;
            [UIView animateWithDuration:0.5 animations:^{
                imgLeftHand.transform = CGAffineTransformIdentity;
                imgLeftHand.frame = CGRectMake(imgLeftHand.frame.origin.x - 60, imgLeftHand.frame.origin.y + 30, imgLeftHand.frame.size.width, imgLeftHand.frame.size.height);
                imgRightHand.transform = CGAffineTransformIdentity;
                imgRightHand.frame = CGRectMake(imgRightHand.frame.origin.x + 48, imgRightHand.frame.origin.y + 30, imgRightHand.frame.size.width, imgRightHand.frame.size.height);
                
                
                imgLeftHandGone.frame = CGRectMake(imgLeftHandGone.frame.origin.x - 70, imgLeftHandGone.frame.origin.y, 40, 40);
                
                imgRightHandGone.frame = CGRectMake(imgRightHandGone.frame.origin.x + 30, imgRightHandGone.frame.origin.y, 40, 40);
                
                
            } completion:^(BOOL b) {
            }];
            
        }
    }
    
}



@end
