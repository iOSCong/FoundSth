//
//  NSStrObject.m
//  HZMHIOS
//
//  Created by MCEJ on 2018/7/18.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import "NSStrObject.h"

@implementation NSStrObject

//存储账户
+ (void)saveAccount:(NSString*)account
{
    [[NSUserDefaults standardUserDefaults] setObject:account forKey:@"userid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//获取账户
+ (NSString *)getAccount
{
    NSString *acc = [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
    if (acc != nil && ![acc isEqualToString:@""] && ![acc isEqualToString:@"(null)"]) {
        return acc;
    }
    return nil;
}

//存储密码
+ (void)savePassword:(NSString*)password
{
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//获取密码
+ (NSString *)getPassword
{
    NSString *pswd = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    if (pswd != nil && ![pswd isEqualToString:@""] && ![pswd isEqualToString:@"(null)"]) {
        return pswd;
    }
    return nil;
}

//存储开关状态值
+ (void)saveSwitchIsOn:(BOOL)status
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:status] forKey:@"switch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//获取开关状态值
+ (BOOL)getSwitchIsOn
{
    NSNumber *acc = [[NSUserDefaults standardUserDefaults] objectForKey:@"switch"];
    if ([acc intValue] == 0) {
        return NO;
    }
    return YES;
}

//存储用户信息
+ (void)saveUserInfos:(NSDictionary*)dictionary
{
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
    [currentDefaults setObject:data forKey:@"userInfos"];
    [currentDefaults synchronize];
}
//获取用户信息
+ (NSDictionary *)getUserInfos
{
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [currentDefaults objectForKey:@"userInfos"];
    NSDictionary * dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (dictionary != nil) {
        return dictionary;
    }
    return nil;
}

//base64转图片
+ (UIImage *)stringToImage:(NSString *)string
{
    if ([mz_NSNString(string) isEqualToString:@"<null>"]) {
        return [UIImage imageNamed:@"placeholder_logo"];
    }else{
        string = [mz_NSNString(string) stringByReplacingOccurrencesOfString:@"data:image/jpg;base64," withString:@""];
        NSData *imageData =[[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *image = [UIImage imageWithData:imageData];
        return image;
    }
}

+ (NSDate *)dateFromString:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datestr = [dateFormatter dateFromString:dateStr];
    return datestr;
}

+ (int)totalPage:(NSString *)total
{
    return [mz_NSNString(total) intValue]/mz_countNum+1;
}

//验证字符串是否为 <null>
+ (NSString *)unemptyString:(NSString *)string
{
//    if ([mz_NSNString(string) isEqualToString:@"<null>"]) {
//        return @"--";
//    }
    if ([string isEqual:[NSNull null]]) {
        return @"--";
    }
    return mz_NSNString(string);
}

//可变字符串
+ (NSMutableAttributedString *)mutableAttrbuteStr:(NSString *)firstStr secondstr:(NSString *)secondStr firstColor:(UIColor *)firstColor
{
    NSString *str = [NSString stringWithFormat:@"%@%@",firstStr,secondStr];
    NSMutableAttributedString *mutableStr =[[NSMutableAttributedString alloc]initWithString:str];
    [mutableStr addAttribute:NSForegroundColorAttributeName value:firstColor range:[str rangeOfString:firstStr]];
    [mutableStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:[str rangeOfString:secondStr]];
    return mutableStr;
}

//所属党支部名称
+ (NSArray *)partyName
{
    return @[@"",@"第一党支部",@"第二党支部",@"第三党支部",@"第四党支部",@"第五党支部",@"第六党支部"];
}

//案例类型
+ (NSArray *)caseType
{
    return @[@"关于落实党建工作责任制方面的实践材料",
             @"关于加强基层党组织建设方面的实践材料",
             @"关于规范党的组织生活方面的实践材料",
             @"关于强化党员教育管理方面的实践材料",
             @"关于推进党建工作与业务工作有机融合方面的实践材料",
             @"关于创新思想政治工作方面的实践材料",
             @"关于推动“互联网+党建”方面的实践材料",
             @"关于推进党建工作继承与创新方面的实践材料",
             @"关于党建工作其他方面的实践材料"];
}

//文件类型
+ (NSArray *)fileType
{
    return @[@"党支部工作计划",
             @"党支部半年度总结",
             @"党支部年度总结"];
}

//会议类型
+ (NSArray *)meetingType
{
    return @[@"党员大会",@"支委会",@"党小组会",@"党课",@"组织生活会"];
}

//颜色生成图片
+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)rect
{
    CGRect newrect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(newrect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, newrect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(CGSizeMake(rect.width, rect.height));
    [theImage drawInRect:CGRectMake(0, 0, rect.width, rect.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

//压缩图片
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}


/**
 * @brief 将字符串转化为控制器.
 *
 * @param str 需要转化的字符串.
 *
 * @return 控制器(需判断是否为空).
 */
+ (UIViewController*)stringChangeToClass:(NSString *)str
{
    id vc = [[NSClassFromString(str) alloc]init];
    if ([vc isKindOfClass:[UIViewController class]]) {
        return vc;
    }
    return nil;
}


@end
