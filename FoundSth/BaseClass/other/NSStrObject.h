//
//  NSStrObject.h
//  HZMHIOS
//
//  Created by MCEJ on 2018/7/18.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSStrObject : NSObject

//存取账户
+ (void)saveAccount:(NSString *)account;
+ (NSString *)getAccount;

//存取密码
+ (void)savePassword:(NSString *)password;
+ (NSString *)getPassword;

//存取开关状态值
+ (void)saveSwitchIsOn:(BOOL)status;
+ (BOOL)getSwitchIsOn;

//存取用户信息
+ (void)saveUserInfos:(NSDictionary*)dictionary;
+ (NSDictionary *)getUserInfos;

//base64转图片
+ (UIImage *)stringToImage:(NSString *)string;

//字符串转时间
+ (NSDate *)dateFromString:(NSString *)dateStr;

//计算多少页
+ (int)totalPage:(NSString *)total;

//验证字符串是否为 <null>
+ (NSString *)unemptyString:(NSString *)string;

//可变字符串
+ (NSMutableAttributedString *)mutableAttrbuteStr:(NSString *)firstStr secondstr:(NSString *)secondStr firstColor:(UIColor *)firstColor;

//所属党支部名称
+ (NSArray *)partyName;

//案例类型
+ (NSArray *)caseType;

//文件类型
+ (NSArray *)fileType;

//会议类型
+ (NSArray *)meetingType;

//颜色生成图片
+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)rect;

//压缩图片
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

+ (UIViewController*)stringChangeToClass:(NSString *)str;


@end
