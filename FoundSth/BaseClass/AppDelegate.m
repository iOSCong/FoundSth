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
#import "WebHomeViewController.h"
#import <WXApi.h>
#import <TencentOpenAPI/TencentOAuth.h>

//帮我找
#define APP_ID @"q2bVzGltsIqv0BbBGIOJ6luL-gzGzoHsz"
#define APP_KEY @"xeyGFW3rYEFSxjILR2Sslmut"

//#define APP_ID @"a16bHTX46r5qFgsvtiK6i2Pj-gzGzoHsz"
//#define APP_KEY @"7mGB3McbV1QQMjl6Rz5wWKIG"

//微信分享
#define weixin_ID @"wx010cd9436a4d0b40"

//QQ分享
#define qqID @"1107999939"
#define qqKey @"KEYhvXoYqIGaaFIqwWi";

//极光推送
#define JPushKey @"6af04920ae86ba66c65182c7"

@interface AppDelegate () <TencentSessionDelegate,WXApiDelegate>

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
    [AVOSCloud setAllLogsEnabled:YES];
    
    //微信分享apikey
    [WXApi registerApp:weixin_ID];
    
    //注意： 初始化授权 开发者需要在这里填入自己申请到的 AppID
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:qqID andDelegate:self];
    
    [AVAnalytics updateOnlineConfigWithBlock:^(NSDictionary * _Nullable dict, NSError * _Nullable error) {
        if (error == nil) {
            if ([dict[@"parameters"][@"type"] intValue]) {
                WebHomeViewController *home = [[WebHomeViewController alloc] init];
                home.section = 2;
                home.urlStr = [NSString stringWithFormat:@"%@",dict[@"parameters"][@"url"]];
                MHNavViewController *nav = [[MHNavViewController alloc] initWithRootViewController:home];
                self.window.rootViewController = nav;
            }else{
                self.window.rootViewController = [[MHTabBarViewController alloc] init];
            }
        }else{
            [MHProgressHUD showMsgWithoutView:@"加载超时,请退出应用后重新启动"];
        }
    }];
    self.window.rootViewController = [[WebHomeViewController alloc] init];
    
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
