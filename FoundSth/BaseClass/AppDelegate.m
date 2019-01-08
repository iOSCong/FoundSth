//
//  AppDelegate.m
//  FoundSth
//
//  Created by MCEJ on 2018/12/22.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import "AppDelegate.h"
#import "MHTabBarViewController.h"
#import "MHNavViewController.h"
#import "WebViewController.h"
#import <WXApi.h>
#import <TencentOpenAPI/TencentOAuth.h>

// JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用 idfa 功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

#ifdef DEBUG
#define kisProduction 0      //开发产品
#else
#define kisProduction 1      //发布产品
#endif


@interface AppDelegate () <TencentSessionDelegate,WXApiDelegate,JPUSHRegisterDelegate>
@property(nonatomic,strong)NSString *alterTitle;
@property (nonatomic,strong)TencentOAuth *tencentOAuth;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //初始化 SDK
    [AVOSCloud setApplicationId:APP_ID clientKey:APP_KEY];
    //开启调试日志
//    [AVOSCloud setAllLogsEnabled:YES];
    [AVOSCloud setAllLogsEnabled:NO];
    
    //微信分享apikey
    [WXApi registerApp:weixin_ID];
    
    //注意： 初始化授权 开发者需要在这里填入自己申请到的 AppID
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:qqID andDelegate:self];
    
    //设置激光推送
    [self jpushInitWith:launchOptions Application:application];
    
    AVQuery *query = [AVQuery queryWithClassName:@"config"];
    [query orderByDescending:@"webspike"];
    [query orderByDescending:@"url"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error == nil) {
            if (objects.count) {
                if ([objects[0][@"webspike"] intValue]) {
                    WebViewController *home = [[WebViewController alloc] init];
                    home.url = [NSString stringWithFormat:@"%@",objects[0][@"url"]];
                    MHNavViewController *nav = [[MHNavViewController alloc] initWithRootViewController:home];
                    self.window.rootViewController = nav;
                }else{
                    self.window.rootViewController = [[MHTabBarViewController alloc] init];
                }
            }else{
                self.window.rootViewController = [[MHTabBarViewController alloc] init];
            }
        }else{
            [MHProgressHUD showMsgWithoutView:@"加载超时,请退出应用后重新启动"];
        }
    }];
    self.window.rootViewController = [[WebViewController alloc] init];
    
    [NSThread sleepForTimeInterval:1.0];
    [self.window makeKeyWindow];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [TencentOAuth HandleOpenURL:url] || [WXApi handleOpenURL:url delegate:self];;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [TencentOAuth HandleOpenURL:url] || [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options
{
    [WXApi handleOpenURL:url delegate:self]; //向微信注册app的url
    return YES;
}

#pragma mark - WXDelegate 微信分享
- (void)onResp:(BaseResp *)resp {
    // 1.分享后回调类
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (resp.errCode == 0) {
            [MHProgressHUD showMsgWithoutView:@"分享成功"];
        }else{
            [MHProgressHUD showMsgWithoutView:@"分享失败"];
        }
    }
}


#pragma ****************************极光推送***************************************
-(void)jpushInitWith:(NSDictionary*)launchOptions Application:(UIApplication *)application {
    
    //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    //        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];

    // Optional
    // 获取 IDFA
    // 如需使用 IDFA 功能请添加此代码并在初始化方法的 advertisingIdentifier 参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];

    // Required
    // init Push
    // notice: 2.1.5 版本的 SDK 新增的注册方法，改成可上报 IDFA，如果没有使用 IDFA 直接传 nil
    // 如需继续使用 pushConfig.plist 文件声明 appKey 等配置内容，请依旧使用 [JPUSHService setupWithOption:launchOptions] 方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:JPushKey
                          channel:@"app story"
                 apsForProduction:kisProduction
            advertisingIdentifier:advertisingId];
    
    //唤醒APP的时候收到通知
    NSDictionary* pushNotificationDic = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (application.applicationState == UIApplicationStateActive) {
        
        //这里写APP正在运行时，推送过来消息的处理
        _alterTitle = pushNotificationDic[@"aps"][@"alert"];
        [MZAlertSheet alertViewMessage:_alterTitle];

    } else if (application.applicationState == UIApplicationStateInactive ) {
        
        //APP在后台运行，推送过来消息的处理
        _alterTitle = pushNotificationDic[@"aps"][@"alert"];
        [MZAlertSheet alertViewMessage:_alterTitle];

    } else if (application.applicationState == UIApplicationStateBackground) {
        
        //APP没有运行，推送过来消息的处理
        _alterTitle = pushNotificationDic[@"aps"][@"alert"];
        [MZAlertSheet alertViewMessage:_alterTitle];
    }
    
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
//    NSLog(@"deviceToken====%@",deviceToken);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate
// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        _alterTitle = userInfo[@"aps"][@"alert"];
        [MZAlertSheet alertViewMessage:_alterTitle];
    }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        _alterTitle = userInfo[@"aps"][@"alert"];
        [MZAlertSheet alertViewMessage:_alterTitle];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        _alterTitle = userInfo[@"aps"][@"alert"];
        [MZAlertSheet alertViewMessage:_alterTitle];
    }
    completionHandler();  // 系统要求执行这个方法
}

//程序在后台或者杀死状态下，收到通知，进入前台时，会调用的方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    _alterTitle = userInfo[@"aps"][@"alert"];
    [MZAlertSheet alertViewMessage:_alterTitle];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required, For systems with less than or equal to iOS 6
    _alterTitle = userInfo[@"aps"][@"alert"];
    [MZAlertSheet alertViewMessage:_alterTitle];
    [JPUSHService handleRemoteNotification:userInfo];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
     [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService resetBadge];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)tencentDidLogin {
    
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    
}

- (void)tencentDidNotNetWork {
    
}

@end
