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

//typedef void (^ClicksLostBlock)(NSString *textField1Text, NSString *textField2Text);
@property (nonatomic, copy, readonly) ClicksAlertBlock lostBlock;

@property(nonatomic,strong)UITextField *textField1;

@property(nonatomic,strong)UITextField *textField2;

@property(nonatomic,strong)UIButton *loginBtn;
@property(nonatomic,strong)UIButton *lostBtn; //忘记密码

@property(nonatomic,strong)UILabel *titleLabel;

/**
 *  遮眼睛效果 （默认遮住眼睛）
 */
@property(nonatomic,assign)HideEyesType hideEyesType;


- (void)setClickLoginBlock:(ClicksAlertBlock)clickBlock;
- (void)setClickLostBlock:(ClicksAlertBlock)clickBlock;

@end
