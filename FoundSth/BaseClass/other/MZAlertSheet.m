//
//  MZAlertSheet.m
//  HZMHIOS
//
//  Created by MCEJ on 2018/8/1.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import "MZAlertSheet.h"

#define kRootViewController [UIApplication sharedApplication].keyWindow.rootViewController

@implementation MZAlertSheet

/** 单个按键的 alertView //简化版 无点击事件 */
+ (void)alertViewMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    // creat action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //无操作
    }];
    // add acton
    [alert addAction:cancelAction];
    // present alertView on rootViewController
    [kRootViewController presentViewController:alert animated:YES completion:nil];
}

/** 单个按键的 alertView */  //简化版 有点击事件
+ (void)presentAlertViewWithMessage:(NSString *)message confirmTitle:(NSString *)confirmTitle handler:(void(^)(void))handler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    // creat action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler();
        }
    }];
    // add acton
    [alert addAction:cancelAction];
    // present alertView on rootViewController
    [kRootViewController presentViewController:alert animated:YES completion:nil];
}

/** 单个按键的 alertView */
+ (void)presentAlertViewWithTitle:(NSString *)title message:(NSString *)message confirmTitle:(NSString *)confirmTitle handler:(void(^)(void))handler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // creat action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        if (handler) {
            handler();
        }
    }];
    
    // add acton
    [alert addAction:cancelAction];
    
    // present alertView on rootViewController
    [kRootViewController presentViewController:alert animated:YES completion:nil];
}

/** 双按键的 alertView */  //简易版
+ (void)presentAlertViewWithMessage:(NSString *)message cancelTitle:(NSString *)cancelTitle defaultTitle:(NSString *)defaultTitle confirm:(void(^)(void))confirm
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:cancelAction];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:defaultTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (confirm) {
            confirm();
        };
    }];
    [alert addAction:defaultAction];
    [kRootViewController presentViewController:alert animated:YES completion:nil];
}

/** 双按键的 alertView */
+ (void)presentAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle defaultTitle:(NSString *)defaultTitle distinct:(BOOL)distinct cancel:(void(^)(void))cancel confirm:(void(^)(void))confirm {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (distinct) {
        // 左浅右深
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancel) {
                cancel();
            }
        }];
        [alert addAction:cancelAction];
    } else {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (cancel) {
                cancel();
            }
        }];
        [alert addAction:cancelAction];
    }
    
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:defaultTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (confirm) {
            confirm();
        };
    }];
    
    [alert addAction:defaultAction];
    
    
    [kRootViewController presentViewController:alert animated:YES completion:nil];
}

/** Alert  任意多个按键 返回选中的 buttonIndex 和 buttonTitle */
+ (void)presentAlertWithTitle:(NSString *)title message:(NSString *)message actionTitles:(NSArray *)actionTitles  preferredStyle:(UIAlertControllerStyle)preferredStyle handler:(void(^)(NSUInteger buttonIndex, NSString *buttonTitle))handler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        handler(-1, @"取消");
    }];
    [alert addAction:cancelAction];
    
    for (int i = 0; i < actionTitles.count; i ++) {
        
        UIAlertAction *confimAction = [UIAlertAction actionWithTitle:actionTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            handler(i, actionTitles[i]);
        }];
        [alert addAction:confimAction];
    }
    
    [kRootViewController presentViewController:alert animated:YES completion:nil];
}


@end
