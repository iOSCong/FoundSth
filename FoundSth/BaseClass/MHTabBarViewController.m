//
//  MHTabBarViewController.m
//  HZMHIOS
//
//  Created by MCEJ on 2017/12/27.
//  Copyright © 2017年 MCEJ. All rights reserved.
//

#import "MHTabBarViewController.h"
#import "MHNavViewController.h"
#import "WebViewController.h"

#import "LoginViewController.h"
#import "FoundListViewController.h"
#import "FoundMyViewController.h"
#import "MineViewController.h"

@interface MHTabBarViewController () <UITabBarControllerDelegate>
{
    NSInteger _currentIndex;
    NSInteger _lastIndex;
}

@end

@implementation MHTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    /*解决item上下变化位置的问题*/
    [[UITabBar appearance] setTranslucent:NO];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginViewNotice:)name:@"loginView" object:nil];
    
    UIColor *textColor = mz_mainColor; //[UIColor blackColor];
    UITabBarItem *item1 = [[UITabBarItem alloc] init];
    item1.tag = 1;
    [item1 setTitle:@"首页"];
    [item1 setImage:[UIImage imageNamed:@"yemian"]];
    [item1 setSelectedImage:[[UIImage imageNamed:@"yemian_sele"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item1 setTitleTextAttributes:@{NSForegroundColorAttributeName: textColor}
                         forState:UIControlStateSelected];
    
    UITabBarItem *item2 = [[UITabBarItem alloc] init];
    item2.tag = 2;
    [item2 setTitle:@"发布"];
    [item2 setImage:[UIImage imageNamed:@"fabu"]];
    [item2 setSelectedImage:[[UIImage imageNamed:@"fabu_sele"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item2 setTitleTextAttributes:@{NSForegroundColorAttributeName: textColor}
                         forState:UIControlStateSelected];
    //发布
    UITabBarItem *item4 = [[UITabBarItem alloc] init];
    item4.tag = 4;
    [item4 setTitle:@"我的"];
    [item4 setImage:[UIImage imageNamed:@"gerenzhongxin"]];
    [item4 setSelectedImage:[[UIImage imageNamed:@"gerenzhongxin_sele"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item4 setTitleTextAttributes:@{NSForegroundColorAttributeName: textColor}
                         forState:UIControlStateSelected];
    
    FoundListViewController *homeController = [[FoundListViewController alloc] init];
    homeController.title = item1.title;
    MHNavViewController *homeNavController = [[MHNavViewController alloc] initWithRootViewController:homeController];
    homeNavController.tabBarItem = item1;
    
    FoundMyViewController *investController = [[FoundMyViewController alloc] init];
    investController.title = item2.title;
    MHNavViewController *projectNavController = [[MHNavViewController alloc] initWithRootViewController:investController];
    projectNavController.tabBarItem = item2;
    
    MineViewController *myController = [[MineViewController alloc] init];
    //    myController.title = item4.title;
    MHNavViewController *myNavController = [[MHNavViewController alloc] initWithRootViewController:myController];
    myNavController.tabBarItem = item4;
    
    //去掉tabBar顶部线条
//    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
//    CGContextFillRect(context, rect);
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    [self.tabBar setBackgroundImage:img];
//    [self.tabBar setShadowImage:img];
    
    self.tabBar.backgroundColor = mz_tabbarColor; //默认
    self.delegate = self;
    self.selectedIndex = 0;
    
    self.viewControllers = [NSArray arrayWithObjects:homeNavController,projectNavController,myNavController, nil];
    
    
}

//点击tabbar
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (self.selectedIndex != 0) {
        AVUser *currentUser = [AVUser currentUser];
        if (currentUser == nil) {
            //缓存用户对象为空时，可打开用户注册界面…
            LoginViewController *login = [[LoginViewController alloc] init];
            [self presentViewController:login animated:NO completion:nil];
            _currentIndex = self.selectedIndex;
            self.selectedIndex = _lastIndex;
            return;
        }
    }
}

- (void)loginViewNotice:(NSNotification *)notice
{
    if ([notice.userInfo[@"tag"] isEqualToString:@"0"]) { //退出登录
        self.selectedIndex = 0;
        _lastIndex = 0;
    }else if ([notice.userInfo[@"tag"] isEqualToString:@"1"]) { //登录成功
        if (_currentIndex != _lastIndex) {
            [self tabBarButtonClick:[self getTabBarButton]];
            self.selectedIndex = _currentIndex;
            _lastIndex = _currentIndex;
        }
    }else if ([notice.userInfo[@"tag"] isEqualToString:@"2"]) { //取消登录
        self.selectedIndex = _lastIndex;
    }
}

- (UIControl *)getTabBarButton
{
    NSMutableArray *tabBarButtons = [[NSMutableArray alloc]initWithCapacity:0];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]){
            [tabBarButtons addObject:tabBarButton];
        }
    }
    UIControl *tabBarButton = [tabBarButtons objectAtIndex:self.selectedIndex];
    return tabBarButton;
}
- (void)tabBarButtonClick:(UIControl *)tabBarButton
{
    for (UIView *imageView in tabBarButton.subviews) {
        if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            //需要实现的帧动画,这里根据需求自定义
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
            animation.keyPath = @"transform.scale";
            animation.values = @[@1.0,@1.1,@0.9,@1.0];
            animation.duration = 0.3;
            animation.calculationMode = kCAAnimationCubic;
            //把动画添加上去就OK了
            [imageView.layer addAnimation:animation forKey:nil];
        }
    }
    _lastIndex = self.selectedIndex;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
