//
//  MapNavView.h
//  HZMHIOS
//
//  Created by MCEJ on 2018/9/12.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger , MapType) {
    MapTypeBD    = 1,   //百度地图
    MapTypeGD    = 2,   //高德地图
    MapTypeTX    = 3,   //腾讯地图
    MapTypeXT    = 4,   //系统地图
    MapTypeGG    = 5,   //谷歌地图
};

@interface MapNavView : UIView

-(void)showMapViewWithLongitude:(float)longitude latitude:(float)latitude address:(NSString *)address;

@end
