//
//  MZAlertSheet.h
//  HZMHIOS
//
//  Created by MCEJ on 2018/8/1.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MZAlertSheet : NSObject

/**
 *  单个按键的 alertView  无点击事件
 *
 *  @param message      内容信息
 */
+ (void)alertViewMessage:(NSString *)message;

/** 单个按键的 alertView */  //简化版 有点击事件
+ (void)presentAlertViewWithMessage:(NSString *)message confirmTitle:(NSString *)confirmTitle handler:(void(^)(void))handler;


/**
 *  单个按键的 alertView
 *
 *  @param title         标题
 *  @param message      内容信息
 *  @param confirmTitle 按键标题
 */
+ (void)presentAlertViewWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle handler:(void(^)(void))handler;

/** 双按键的 alertView */  //简易版
+ (void)presentAlertViewWithMessage:(NSString *)message cancelTitle:(NSString *)cancelTitle defaultTitle:(NSString *)defaultTitle confirm:(void(^)(void))confirm;

/**
 *  双按键的 alertView
 *
 *  @param title         标题
 *  @param message      内容信息
 *  @param cancelTitle  左标题
 *  @param defaultTitle 右标题
 *  @param distinct     按键颜色是否区分(若 YES, 左按键为 UIAlertActionStyleCancel 模式 字体颜色偏深)
 *  @param cancel       左按键回调
 *  @param confirm      右按键回调
 */
+ (void)presentAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle defaultTitle:(NSString *)defaultTitle distinct:(BOOL)distinct cancel:(void(^)(void))cancel confirm:(void(^)(void))confirm;


/**
 *  任意多按键的 alert (alertView or ActionSheet)
 *
 *  @param title          标题
 *  @param message        内容
 *  @param actionTitles   按键标题数组
 *  @param preferredStyle  弹窗类型 alertView or ActionSheet
 *  @param handler        按键回调
 内置"取消"按键, buttonIndex 为0
 */
+ (void)presentAlertWithTitle:(NSString *)title message:(NSString *)message actionTitles:(NSArray *)actionTitles  preferredStyle:(UIAlertControllerStyle)preferredStyle handler:(void(^)(NSUInteger buttonIndex, NSString *buttonTitle))handler;


@end
