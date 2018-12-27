//
//  WSLoginView.h
//  WSLoginView
//
//  Created by iMac on 16/12/23.
//  Copyright © 2016年 zws. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    AllEyesHide,    //全部遮住
    LeftEyeHide,    //遮住左眼
    RightEyeHide,   //遮住右眼
    NOEyesHide     //两只眼睛都漏一半
}HideEyesType;



@interface WSLoginView : UIView


typedef void (^ClicksAlertBlock)(NSString *textField1Text, NSString *textField2Text);
@property (nonatomic, copy, readonly) ClicksAlertBlock clickBlock;
@property (nonatomic, copy, readonly) ClicksAlertBlock lostBlock;

typedef void (^ClicksCancelBlock)(void);
@property (nonatomic, copy, readonly) ClicksCancelBlock cancelBlock;

@property(nonatomic,strong)UITextField *logNameTextF;
@property(nonatomic,strong)UITextField *regNameTextF;
@property(nonatomic,strong)UITextField *regSimTextF;

@property(nonatomic,strong)UITextField *logPassTextF;
@property(nonatomic,strong)UITextField *regPassTextF;

@property (nonatomic,strong)UIButton *cancelBtn;
@property(nonatomic,strong)UIButton *loginBtn;
@property(nonatomic,strong)UIButton *lostBtn; //忘记密码

@property(nonatomic,strong)UILabel *titleLabel;

/**
 *  遮眼睛效果 （默认遮住眼睛）
 */
@property(nonatomic,assign)HideEyesType hideEyesType;

- (void)setClickCancelBlock:(ClicksCancelBlock)clickBlock;
- (void)setClickLoginBlock:(ClicksAlertBlock)clickBlock;
- (void)setClickLostBlock:(ClicksAlertBlock)clickBlock;

@end
