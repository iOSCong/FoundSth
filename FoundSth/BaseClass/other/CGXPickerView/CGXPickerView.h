//
//  CGXPickerView.h
//  CGXPickerView
//
//  Created by 曹贵鑫 on 2017/8/23.
//  Copyright © 2017年 曹贵鑫. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "CGXPickerViewManager.h"
#import <UIKit/UIKit.h>

/**
 *  @param selectAddressArr     选择的行标题文字
 *  @param selectAddressRow       选择的行标题下标
 */
typedef void(^CGXAddressResultBlock)(NSArray *selectAddressArr,NSArray *selectAddressRow);


typedef void(^CGXDateResultBlock)(NSString *selectValue);

/**
 *  @param selectValue     选择的行标题文字
 *  @param selectRow       选择的行标题下标
 */
typedef void(^CGXStringResultBlock)(id selectValue,id selectRow);

typedef NS_ENUM(NSInteger, CGXStringPickerViewStyle) {
    CGXStringPickerViewStyleEducation,   //学历
    CGXStringPickerViewStyleBlood,   //血型
    CGXStringPickerViewStyleAnimal,   //生肖
    CGXStringPickerViewStylConstellation, //星座
    CGXStringPickerViewStyleGender,   //性别
    CGXStringPickerViewStylNation,  //民族
    CGXStringPickerViewStylReligious,   //宗教
    CGXStringPickerViewStyleAge,   //年龄  18岁～80岁
    CGXStringPickerViewStyleAgeScope,   //年龄范围
    CGXStringPickerViewStylHeight,  //身高 150cm~220cm
    CGXStringPickerViewStylHeightScope,  //身高范围
    CGXStringPickerViewStylWeight,   //体重  40kg~100kg
    CGXStringPickerViewStylWeightScope,   //体重范围
    CGXStringPickerViewStylWeek,    //星期
};

@interface CGXPickerView : NSObject


/**
 *  显示地址选择器
 *
 *  @param defaultSelectedArr       默认选中的值(传数组，元素为对应的索引值。如：@[@10, @1, @1])
 *  @param isAutoSelect             是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param resultBlock              选择后的回调
 *
 */
+ (void)showAddressPickerWithTitle:(NSString *)title
                   DefaultSelected:(NSArray *)defaultSelectedArr
                      IsAutoSelect:(BOOL)isAutoSelect
                           Manager:(CGXPickerViewManager *)manager
                       ResultBlock:(CGXAddressResultBlock)resultBlock;

//自定义使用的
+ (void)showAddressPickerWithTitle:(NSString *)title
                   DefaultSelected:(NSArray *)defaultSelectedArr
                          FileName:(NSString *)fileName
                      IsAutoSelect:(BOOL)isAutoSelect
                           Manager:(CGXPickerViewManager *)manager
                       ResultBlock:(CGXAddressResultBlock)resultBlock;


//年月日
+ (void)showDatePickerWithDefaultYearMonthDay:(NSString *)yearMonthDay ResultBlock:(CGXDateResultBlock)resultBlock;
//只用年月
+ (void)showDatePickerWithDefaultYearMonth:(NSString *)yearMonth ResultBlock:(CGXDateResultBlock)resultBlock;

/**
 *  显示时间选择器
 *  @param resultBlock      选择结果的回调
 *
 */
+ (void)showDatePickerWithDefaultSelValue:(NSString *)defaultSelValue ResultBlock:(CGXDateResultBlock)resultBlock;

/**
 *  显示时间选择器
 *
 *  @param title            标题
 *  @param type             类型（时间、日期、日期和时间、倒计时）
 *  @param defaultSelValue  默认选中的时间（为空，默认选中现在的时间）
 *  @param minDateStr       最小时间（如：2015-08-28 00:00:00），可为空
 *  @param maxDateStr       最大时间（如：2018-05-05 00:00:00），可为空
 *  @param isAutoSelect     是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param resultBlock      选择结果的回调
 *
 */
+ (void)showDatePickerWithTitle:(NSString *)title
                       DateType:(UIDatePickerMode)type
                DefaultSelValue:(NSString *)defaultSelValue
                     MinDateStr:(NSString *)minDateStr
                     MaxDateStr:(NSString *)maxDateStr
                   IsAutoSelect:(BOOL)isAutoSelect
                        Manager:(CGXPickerViewManager *)manager
                    ResultBlock:(CGXDateResultBlock)resultBlock;



//自定义简易版    单行@[@"ha",@"haha"]    多行@[@[@"ha",@"haha"],@[@"ha",@"haha"]]
+ (void)showStringPickerWithDataSource:(NSArray *)dataSource ResultBlock:(CGXStringResultBlock)resultBlock;

/**
 *  显示自定义字符串选择器     自定义

 *  @param title            标题
 *  @param dataSource       数组数据源  单行@[@"ha",@"haha"]    多行@[@[@"ha",@"haha"],@[@"ha",@"haha"]]
 *  @param defaultSelValue  默认选中的行(单列传字符串，多列传一维数组)
 *  @param isAutoSelect     是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param resultBlock      选择后的回调
 *
 */
+ (void)showStringPickerWithTitle:(NSString *)title
                       DataSource:(NSArray *)dataSource
                  DefaultSelValue:(id)defaultSelValue
                     IsAutoSelect:(BOOL)isAutoSelect
                          Manager:(CGXPickerViewManager *)manager
                      ResultBlock:(CGXStringResultBlock)resultBlock;

/**
 *  显示自定义字符串选择器

 *  @param title            标题
 *  @param fileName        plist文件名
 *  @param defaultSelValue  默认选中的行(单列传字符串数组，多列传一维数组)
 *  @param isAutoSelect     是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param resultBlock      选择后的回调
 *
 */
+ (void)showStringPickerWithTitle:(NSString *)title
                        FileName:(NSString *)fileName
                  DefaultSelValue:(id)defaultSelValue
                     IsAutoSelect:(BOOL)isAutoSelect
                          Manager:(CGXPickerViewManager *)manager
                      ResultBlock:(CGXStringResultBlock)resultBlock;
/**
// *  显示自定义字符串选择器   默认常规设置常规个人信息选项  单行
// *  @param title            标题
// *  @param defaultSelValue  默认选中的行(单列传字符串，多列传一维数组)
// *  @param isAutoSelect     是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
// *  @param resultBlock      选择后的回调
// *  @param style          样式选择
// */
+ (void)showStringPickerWithTitle:(NSString *)title
                  DefaultSelValue:(id)defaultSelValue
                     IsAutoSelect:(BOOL)isAutoSelect
                          Manager:(CGXPickerViewManager *)manager
                      ResultBlock:(CGXStringResultBlock)resultBlock
                            Style:(CGXStringPickerViewStyle)style;
//***
//返回默认单行个人信息数组
//***

+ (NSArray *)showStringPickerDataSourceStyle:(CGXStringPickerViewStyle)style;

+ (NSString *)showSelectAddressProvince_id:(NSString *)province_id City_id:(NSString *)city_id;











/* 用法实例
- (void)use
{
    NSString *title =self.dataArray[indexPath.row];
    __weak typeof(self) weakSelf = self;
    if ([title isEqualToString:@"出生年月选择器"]) {
        NSDate *now = [NSDate date];
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *nowStr = [fmt stringFromDate:now];
        
        [CGXPickerView showDatePickerWithTitle:@"出生年月" DateType:UIDatePickerModeDate DefaultSelValue:nil MinDateStr:@"1900-01-01 00:00:00" MaxDateStr:nowStr IsAutoSelect:YES Manager:nil ResultBlock:^(NSString *selectValue) {
            NSLog(@"%@",selectValue);
            weakSelf.navigationItem.title = selectValue;;
        }];
        
    }else if ([title isEqualToString:@"时间选择器"]){
        [CGXPickerView showDatePickerWithTitle:@"出生时刻" DateType:UIDatePickerModeTime DefaultSelValue:nil MinDateStr:nil MaxDateStr:nil IsAutoSelect:YES Manager:nil ResultBlock:^(NSString *selectValue) {
            NSLog(@"%@",selectValue);
            weakSelf.navigationItem.title = selectValue;;
        }];
    }else if ([title isEqualToString:@"日期和时间"]){
        [CGXPickerView showDatePickerWithTitle:@"日期和时间" DateType:UIDatePickerModeDateAndTime DefaultSelValue:nil MinDateStr:nil MaxDateStr:nil IsAutoSelect:YES Manager:nil ResultBlock:^(NSString *selectValue) {
            NSLog(@"%@",selectValue);
            weakSelf.navigationItem.title = selectValue;;
        }];
    }else if ([title isEqualToString:@"倒计时"]){
        [CGXPickerView showDatePickerWithTitle:@"倒计时" DateType:UIDatePickerModeCountDownTimer DefaultSelValue:nil MinDateStr:nil MaxDateStr:nil IsAutoSelect:YES Manager:nil ResultBlock:^(NSString *selectValue) {
            NSLog(@"%@",selectValue);
            weakSelf.navigationItem.title = selectValue;;
        }];
    }else if ([title isEqualToString:@"省,市,县"]){
        [CGXPickerView showAddressPickerWithTitle:@"请选择你的城市" DefaultSelected:@[@4, @0,@0] IsAutoSelect:YES Manager:nil ResultBlock:^(NSArray *selectAddressArr, NSArray *selectAddressRow) {
            NSLog(@"%@-%@",selectAddressArr,selectAddressRow);
            weakSelf.navigationItem.title = [NSString stringWithFormat:@"%@%@%@", selectAddressArr[0], selectAddressArr[1],selectAddressArr[2]];
        }];
    }else if ([title isEqualToString:@"省,市"]){
        [CGXPickerView showAddressPickerWithTitle:@"请选择你的城市" DefaultSelected:@[@0,@0] IsAutoSelect:YES Manager:nil ResultBlock:^(NSArray *selectAddressArr, NSArray *selectAddressRow) {
            NSLog(@"%@-%@",selectAddressArr,selectAddressRow);
            weakSelf.navigationItem.title = [NSString stringWithFormat:@"%@%@", selectAddressArr[0], selectAddressArr[1]];
        }];
    }else if ([title isEqualToString:@"省"]){
        [CGXPickerView showAddressPickerWithTitle:@"请选择你的城市" DefaultSelected:@[@0] IsAutoSelect:YES Manager:nil ResultBlock:^(NSArray *selectAddressArr, NSArray *selectAddressRow) {
            NSLog(@"%@-%@",selectAddressArr,selectAddressRow);
            weakSelf.navigationItem.title = [NSString stringWithFormat:@"%@", selectAddressArr[0]];
        }];
    }
    else if ([title isEqualToString:@"自定义一行"]){
        [CGXPickerView showStringPickerWithTitle:@"红豆" DataSource:@[@"很好的", @"干干", @"高度", @"打的", @"都怪怪的", @"博对"] DefaultSelValue:@"高度" IsAutoSelect:NO Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            NSLog(@"%@",selectValue);
            weakSelf.navigationItem.title = selectValue;; ;
        }];
    }
    else if ([title isEqualToString:@"自定义二行"]){
        NSArray *dataSources = @[@[@"第1周", @"第2周", @"第3周", @"第4周", @"第5周", @"第6周", @"第7周"], @[@"第1天", @"第2天", @"第3天", @"第4天", @"第5天", @"第6天", @"第7天"]];
        NSArray *defaultSelValueArr = @[@"第3周"];
        [CGXPickerView showStringPickerWithTitle:@"学历" DataSource:dataSources DefaultSelValue:defaultSelValueArr IsAutoSelect:YES Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            NSLog(@"%@",selectValue); ;
            weakSelf.navigationItem.title = [NSString stringWithFormat:@"%@，%@", selectValue[0], selectValue[1]];
        }];
    }else if ([title isEqualToString:@"教育"]){
        
        NSString *defaultSelValue = [[CGXPickerView showStringPickerDataSourceStyle:CGXStringPickerViewStyleEducation] objectAtIndex:1];
        [CGXPickerView showStringPickerWithTitle:@"教育" DefaultSelValue:defaultSelValue IsAutoSelect:YES Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            NSLog(@"%@--%@",selectValue,selectRow);
            weakSelf.navigationItem.title = [NSString stringWithFormat:@"%@", selectValue];
        } Style:CGXStringPickerViewStyleEducation];
    } else if ([title isEqualToString:@"血型"]){
        NSString *defaultSelValue = [[CGXPickerView showStringPickerDataSourceStyle:CGXStringPickerViewStyleBlood] objectAtIndex:1];
        [CGXPickerView showStringPickerWithTitle:@"血型" DefaultSelValue:defaultSelValue IsAutoSelect:YES Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            NSLog(@"%@",selectValue); ;
            weakSelf.navigationItem.title = [NSString stringWithFormat:@"%@", selectValue];
        } Style:CGXStringPickerViewStyleBlood];
    }   else if ([title isEqualToString:@"星座"]){
        NSString *defaultSelValue = [[CGXPickerView showStringPickerDataSourceStyle:CGXStringPickerViewStylConstellation] objectAtIndex:1];
        [CGXPickerView showStringPickerWithTitle:@"星座" DefaultSelValue:defaultSelValue IsAutoSelect:YES Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            NSLog(@"%@",selectValue); ;
            weakSelf.navigationItem.title = [NSString stringWithFormat:@"%@", selectValue];
        } Style:CGXStringPickerViewStylConstellation];
    }   else if ([title isEqualToString:@"生肖"]){
        NSString *defaultSelValue = [[CGXPickerView showStringPickerDataSourceStyle:CGXStringPickerViewStyleAnimal] objectAtIndex:1];
        [CGXPickerView showStringPickerWithTitle:@"生肖" DefaultSelValue:defaultSelValue IsAutoSelect:YES Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            NSLog(@"%@",selectValue); ;
            weakSelf.navigationItem.title = [NSString stringWithFormat:@"%@", selectValue];
        } Style:CGXStringPickerViewStyleAnimal];
    } else if ([title isEqualToString:@"性别"]){
        NSString *defaultSelValue = [[CGXPickerView showStringPickerDataSourceStyle:CGXStringPickerViewStyleGender] objectAtIndex:1];
        [CGXPickerView showStringPickerWithTitle:@"性别" DefaultSelValue:defaultSelValue IsAutoSelect:YES Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            NSLog(@"%@",selectValue); ;
            weakSelf.navigationItem.title = [NSString stringWithFormat:@"%@", selectValue];
        } Style:CGXStringPickerViewStyleGender];
    }else if ([title isEqualToString:@"民族"]){
        NSString *defaultSelValue = [[CGXPickerView showStringPickerDataSourceStyle:CGXStringPickerViewStylNation] objectAtIndex:3];
        [CGXPickerView showStringPickerWithTitle:@"民族" DefaultSelValue:defaultSelValue IsAutoSelect:YES Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            NSLog(@"%@",selectValue); ;
            weakSelf.navigationItem.title = [NSString stringWithFormat:@"%@", selectValue];
        } Style:CGXStringPickerViewStylNation];
    }else if ([title isEqualToString:@"宗教"]){
        
        NSString *defaultSelValue = [[CGXPickerView showStringPickerDataSourceStyle:CGXStringPickerViewStylReligious] objectAtIndex:3];
        [CGXPickerView showStringPickerWithTitle:@"宗教" DefaultSelValue:defaultSelValue IsAutoSelect:YES Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            NSLog(@"%@",selectValue); ;
            weakSelf.navigationItem.title = [NSString stringWithFormat:@"%@", selectValue];
        } Style:CGXStringPickerViewStylReligious];
    }else if ([title isEqualToString:@"身高"]){
        
        NSString *defaultSelValue = [[CGXPickerView showStringPickerDataSourceStyle:CGXStringPickerViewStylHeight] objectAtIndex:3];
        [CGXPickerView showStringPickerWithTitle:@"身高" DefaultSelValue:defaultSelValue IsAutoSelect:YES Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            NSLog(@"%@",selectValue); ;
            weakSelf.navigationItem.title = [NSString stringWithFormat:@"%@", selectValue];
        } Style:CGXStringPickerViewStylHeight];
    }else if ([title isEqualToString:@"身高范围"]){
        
        NSString *defaultSelValue1 = [[CGXPickerView showStringPickerDataSourceStyle:CGXStringPickerViewStylHeightScope] objectAtIndex:3];
        
        NSString *defaultSelValue2 = [[CGXPickerView showStringPickerDataSourceStyle:CGXStringPickerViewStylHeightScope] objectAtIndex:6];
        
        
        [CGXPickerView showStringPickerWithTitle:@"身高范围" DefaultSelValue:@[defaultSelValue1,defaultSelValue2] IsAutoSelect:YES Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            NSLog(@"%@",selectValue); ;
            weakSelf.navigationItem.title = [NSString stringWithFormat:@"%@", selectValue];
        } Style:CGXStringPickerViewStylHeightScope];
    }else if ([title isEqualToString:@"体重"]){
        
        NSString *defaultSelValue = [[CGXPickerView showStringPickerDataSourceStyle:CGXStringPickerViewStylWeight] objectAtIndex:3];
        [CGXPickerView showStringPickerWithTitle:@"体重" DefaultSelValue:defaultSelValue IsAutoSelect:YES Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            NSLog(@"%@",selectValue); ;
            weakSelf.navigationItem.title = [NSString stringWithFormat:@"%@", selectValue];
        } Style:CGXStringPickerViewStylWeight];
    }else if ([title isEqualToString:@"体重范围"]){
        
        NSString *defaultSelValue1 = [[CGXPickerView showStringPickerDataSourceStyle:CGXStringPickerViewStylWeightScope] objectAtIndex:3];
        
        NSString *defaultSelValue2 = [[CGXPickerView showStringPickerDataSourceStyle:CGXStringPickerViewStylWeightScope] objectAtIndex:6];
        
        [CGXPickerView showStringPickerWithTitle:@"体重范围" DefaultSelValue:@[defaultSelValue1,defaultSelValue2] IsAutoSelect:YES Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            NSLog(@"%@",selectValue); ;
            weakSelf.navigationItem.title = [NSString stringWithFormat:@"%@", selectValue];
        } Style:CGXStringPickerViewStylWeightScope];
    }else if ([title isEqualToString:@"年龄"]){
        
        NSString *defaultSelValue = [[CGXPickerView showStringPickerDataSourceStyle:CGXStringPickerViewStyleAge] objectAtIndex:3];
        [CGXPickerView showStringPickerWithTitle:@"年龄" DefaultSelValue:defaultSelValue IsAutoSelect:YES Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            NSLog(@"%@",selectValue); ;
            weakSelf.navigationItem.title = [NSString stringWithFormat:@"%@", selectValue];
        } Style:CGXStringPickerViewStyleAge];
    }else if ([title isEqualToString:@"年龄范围"]){
        
        NSString *defaultSelValue1 = [[CGXPickerView showStringPickerDataSourceStyle:CGXStringPickerViewStyleAgeScope] objectAtIndex:3];
        
        NSString *defaultSelValue2 = [[CGXPickerView showStringPickerDataSourceStyle:CGXStringPickerViewStyleAgeScope] objectAtIndex:6];
        
        [CGXPickerView showStringPickerWithTitle:@"年龄范围" DefaultSelValue:@[defaultSelValue1,defaultSelValue2] IsAutoSelect:YES Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            NSLog(@"%@",selectValue); ;
            weakSelf.navigationItem.title = [NSString stringWithFormat:@"%@", selectValue];
        } Style:CGXStringPickerViewStyleAgeScope];
    }else if ([title isEqualToString:@"星期"]){
        
        NSString *defaultSelValue1 = [[CGXPickerView showStringPickerDataSourceStyle:CGXStringPickerViewStylWeek] objectAtIndex:3];
        [CGXPickerView showStringPickerWithTitle:@"星期" DefaultSelValue:defaultSelValue1 IsAutoSelect:YES Manager:nil ResultBlock:^(id selectValue, id selectRow) {
            NSLog(@"%@",selectValue); ;
            weakSelf.navigationItem.title = [NSString stringWithFormat:@"%@", selectValue];
        } Style:CGXStringPickerViewStylWeek];
    }
}

*/

@end
