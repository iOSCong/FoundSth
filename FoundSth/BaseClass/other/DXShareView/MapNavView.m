//
//  MapNavView.m
//  HZMHIOS
//
//  Created by MCEJ on 2018/9/12.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import "MapNavView.h"
#import "DXShareButton.h"
#import "DXSharePlatform.h"

static CGFloat const DXShreButtonHeight = 90.f;
static CGFloat const DXShreButtonWith = 76.f;
static CGFloat const DXShreHeightSpace = 15.f;//竖间距
static CGFloat const DXShreCancelHeight = 46.f;

//屏幕宽度与高度
#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width

#define SCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface MapNavView()<UIGestureRecognizerDelegate>

//底部view
@property (nonatomic,strong) UIView *bottomPopView;

@property (nonatomic,strong) NSMutableArray *platformArray;
@property (nonatomic,strong) NSMutableArray *buttonArray;
@property (nonatomic,strong) DXShareModel *shareModel;
@property (nonatomic,assign) DXShareContentType shareConentType;
@property (nonatomic,assign) CGFloat shreViewHeight;//分享视图的高度
@property (nonatomic,assign) float longitude;
@property (nonatomic,assign) float latitude;
@property (nonatomic,strong)NSString *address;

@end

@implementation MapNavView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.platformArray = [NSMutableArray array];
        self.buttonArray = [NSMutableArray array];
        
        //初始化分享平台
        [self setUpPlatformsItems];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
        tapGestureRecognizer.delegate = self;
        [tapGestureRecognizer addTarget:self action:@selector(closeShareView)];
        
        [self addGestureRecognizer:tapGestureRecognizer];
        
        //计算分享视图的总高度
        self.shreViewHeight = DXShreHeightSpace *(self.platformArray.count /4 + 2) + DXShreButtonHeight * (self.platformArray.count /4 + 1) + DXShreCancelHeight;
        
        int columnCount=4;
        //计算间隙
        CGFloat appMargin=(SCREEN_WIDTH-columnCount*DXShreButtonWith)/(columnCount+1);
        
        for (int i=0; i<self.platformArray.count; i++) {
            DXSharePlatform *platform = self.platformArray[i];
            //计算列号和行号
            int colX=i%columnCount;
            int rowY=i/columnCount;
            //计算坐标
            CGFloat buttonX = appMargin+colX*(DXShreButtonWith+appMargin);
            CGFloat buttonY = DXShreHeightSpace+rowY*(DXShreButtonHeight+DXShreHeightSpace);
            DXShareButton *shareBut = [[DXShareButton alloc] init];
            [shareBut setTitle:platform.name forState:UIControlStateNormal];
            [shareBut setImage:[UIImage imageNamed:platform.iconStateNormal] forState:UIControlStateNormal];
            [shareBut setImage:[UIImage imageNamed:platform.iconStateHighlighted] forState:UIControlStateHighlighted];
            shareBut.frame = CGRectMake(10, 10, 76, 90);
            [shareBut addTarget:self action:@selector(clickShare:) forControlEvents:UIControlEventTouchUpInside];
            shareBut.tag = platform.mapPlatform;//这句话必须写！！！
            [self.bottomPopView addSubview:shareBut];
            shareBut.frame = CGRectMake(buttonX, buttonY, DXShreButtonWith, DXShreButtonHeight);
            [self.bottomPopView addSubview:shareBut];
            [self.buttonArray addObject:shareBut];
            
        }
        
        //按钮动画
        for (DXShareButton *button in self.buttonArray) {
            NSInteger idx = [self.buttonArray indexOfObject:button];
            
            CGAffineTransform fromTransform = CGAffineTransformMakeTranslation(0, 50);
            button.transform = fromTransform;
            button.alpha = 0.3;
            
            [UIView animateWithDuration:0.9+idx*0.1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                button.transform = CGAffineTransformIdentity;
                button.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
            
        }
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setFrame:CGRectMake(0, self.shreViewHeight - DXShreCancelHeight, SCREEN_WIDTH, DXShreCancelHeight)];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelButton.backgroundColor = [UIColor whiteColor];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [cancelButton addTarget:self action:@selector(closeShareView) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomPopView addSubview:cancelButton];
        
        [self addSubview:self.bottomPopView];
        
    }
    return self;
}

#pragma mark - 点击了分享按钮
-(void)clickShare:(UIButton *)sender
{
#warning 本人用的友盟社会化分享组件
    switch (sender.tag) {
        case MapTypeBD://百度地图
        {
            [self baidu_map];
        }
            break;
        case MapTypeGD://高德地图
        {
            [self gaode_map];
        }
            break;
        case MapTypeTX://腾讯地图
        {
            [self tencent_map];
        }
            break;
        case MapTypeXT://苹果地图
        {
//            [self apple_map];
        }
            break;
        case MapTypeGG://谷歌地图
        {
            [self google_map];
        }
            break;
        default:
            break;
    }
    [self closeShareView];
}

- (void)baidu_map
{
    NSLog(@"百度地图");
    if (self.longitude == 0.00 || self.latitude == 0.00) {
        [MHProgressHUD showMsgWithoutView:@"该大楼经纬度信息有误,百度地图无法为您导航"];
    }else{
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
            // 起点为“我的位置”，终点为后台返回的坐标  mode: 导航方式
            NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=%f,%f&mode=driving&src=", self.latitude, self.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:urlString];
            [[UIApplication sharedApplication] openURL:url];
        }else{
            [MZAlertSheet presentAlertViewWithMessage:@"您未安装百度地图,是否去下载安装?" cancelTitle:@"取消" defaultTitle:@"确定" confirm:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id452186370"]];
            }];
        }
    }
}

- (void)gaode_map
{
    NSLog(@"高德地图");
    if (self.longitude == 0.00 || self.latitude == 0.00) {
        [MHProgressHUD showMsgWithoutView:@"该大楼经纬度信息有误,高德地图无法为您导航"];
    }else{
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
            // 起点为“我的位置”，终点为后台返回的经纬度
            //style 导航方式：(0：速度最快，1：费用最少，2：距离最短，3：不走高速，4：躲避拥堵，5：不走高速且避免收费，6：不走高速且躲避拥堵，7：躲避收费和拥堵，8：不走高速躲避收费和拥堵)
            NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=杭分门户&poiname=fangheng&poiid=BGVIS&lat=%f&lon=%f&dev=1&style=2",self.latitude,self.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //iOS10以后,使用新API
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) {
                    NSLog(@"scheme调用结束");
                }];
            } else {
                // Fallback on earlier versions
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }
        }else{
            [MZAlertSheet presentAlertViewWithMessage:@"您未安装高德地图,是否去下载安装?" cancelTitle:@"取消" defaultTitle:@"确定" confirm:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id461703208"]];
            }];
        }
    }
}

- (void)tencent_map
{
    NSLog(@"腾讯地图");
    if (self.longitude == 0.00 || self.latitude == 0.00) {
        [MHProgressHUD showMsgWithoutView:@"该大楼经纬度信息有误,腾讯地图无法为您导航"];
    }else{
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
            NSString *urlString =[[NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&from=我的位置&to=%@&tocoord=%lf,%lf&policy=1&referer=tengxun",self.address,self.latitude,self.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }else{
            [MZAlertSheet presentAlertViewWithMessage:@"您未安装腾讯地图,是否去下载安装?" cancelTitle:@"取消" defaultTitle:@"确定" confirm:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id481623196"]];
            }];
        }
    }
}

//- (void)apple_map
//{
//    NSLog(@"苹果地图");
//    if (self.longitude == 0.00 || self.latitude == 0.00) {
//        [MHProgressHUD showMsgWithoutView:@"该大楼经纬度信息有误,苹果地图无法为您导航"];
//    }else{
//        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.apple.com"]]) {
//            //终点经纬度
//            CLLocationCoordinate2D endCoor = CLLocationCoordinate2DMake(self.latitude, self.longitude);
//            //当前位置
//            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
//            //终点位置
//            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:endCoor addressDictionary:nil]];
//            //终点地址
//            toLocation.name = [NSString stringWithFormat:@"%@",self.address];
//            //打开地图,开始导航
//            [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
//                           launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
//        }else{
//            [MZAlertSheet alertViewMessage:@"苹果地图调启失败"];
//        }
//    }
//}

- (void)google_map
{
    NSLog(@"谷歌地图");
    if (self.longitude == 0.00 || self.latitude == 0.00) {
        [MHProgressHUD showMsgWithoutView:@"该大楼经纬度信息有误,谷歌地图无法为您导航"];
    }else{
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemapsurl://"]]) {
            NSString *urlString = [[NSString stringWithFormat:@"comgooglemapsurl://www.google.com/maps/preview/@%lf,%lf,6z",self.latitude, self.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
        }else{
            [MZAlertSheet presentAlertViewWithMessage:@"您未安装谷歌地图,是否去下载安装?" cancelTitle:@"取消" defaultTitle:@"确定" confirm:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id585027354"]];
            }];
        }
    }
}


-(UIView *)bottomPopView
{
    if (_bottomPopView == nil) {
        _bottomPopView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENH_HEIGHT, SCREEN_WIDTH, self.shreViewHeight)];
        _bottomPopView.backgroundColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.00];
    }
    return _bottomPopView;
}

-(void)showMapViewWithLongitude:(float)longitude latitude:(float)latitude address:(NSString *)address
{
    self.longitude = longitude;
    self.latitude = latitude;
    self.address = address;
    
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:.3f animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4f];
        self.bottomPopView.frame = CGRectMake(0, SCREENH_HEIGHT - self.shreViewHeight, SCREEN_WIDTH, self.shreViewHeight);
    }];
}

#pragma mark - 点击背景关闭视图
-(void)closeShareView
{
    [UIView animateWithDuration:.3f animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.bottomPopView.frame = CGRectMake(0, SCREENH_HEIGHT, SCREEN_WIDTH, self.shreViewHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
#pragma  mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.bottomPopView]) {
        return NO;
    }
    return YES;
}

#pragma mark 设置平台
-(void)setUpPlatformsItems
{
#warning 防止审核失败 最好要先判断是否已安装微信、QQ 或其他平台的App
    //    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
    DXSharePlatform *baidumap = [[DXSharePlatform alloc] init];
    baidumap.iconStateNormal = @"baidumap";
    baidumap.iconStateHighlighted = @"baidumap";
    baidumap.mapPlatform = MapTypeBD;
    baidumap.name = @"百度地图";
    [self.platformArray addObject:baidumap];
    
    //    }
    
    //    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatTimeLine]) {
    DXSharePlatform *gaodemap = [[DXSharePlatform alloc] init];
    gaodemap.iconStateNormal = @"gaodemap";
    gaodemap.iconStateHighlighted = @"gaodemap";
    gaodemap.mapPlatform = MapTypeGD;
    gaodemap.name = @"高德地图";
    [self.platformArray addObject:gaodemap];
    //    }
    
    //    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ]) {
    DXSharePlatform *tenxunmap = [[DXSharePlatform alloc] init];
    tenxunmap.iconStateNormal = @"tenxunmap";
    tenxunmap.iconStateHighlighted = @"tenxunmap";
    tenxunmap.mapPlatform = MapTypeTX;
    tenxunmap.name = @"腾讯地图";
    [self.platformArray addObject:tenxunmap];
    //    }
    
    //    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_Qzone]) {
    DXSharePlatform *appleMap = [[DXSharePlatform alloc] init];
    appleMap.iconStateNormal = @"applemap";
    appleMap.iconStateHighlighted = @"applemap";
    appleMap.mapPlatform = MapTypeXT;
    appleMap.name = @"苹果地图";
    [self.platformArray addObject:appleMap];
    //    }
    
    //    if ([[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_Qzone]) {
    DXSharePlatform *gugemap = [[DXSharePlatform alloc] init];
    gugemap.iconStateNormal = @"gugemap";
    gugemap.iconStateHighlighted = @"gugemap";
    gugemap.mapPlatform = MapTypeGG;
    gugemap.name = @"谷歌地图";
    [self.platformArray addObject:gugemap];
    //    }
    
}

@end

