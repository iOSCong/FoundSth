//
//  MHTabBarViewController.m
//  HZMHIOS
//
//  Created by MCEJ on 2017/12/27.
//  Copyright © 2017年 MCEJ. All rights reserved.
//

#import "MHTabBarViewController.h"
#import "MHNavViewController.h"

#import "FoundListViewController.h"
#import "FoundMyViewController.h"
#import "MineViewController.h"

@interface MHTabBarViewController () <UITabBarControllerDelegate>
{
    NSInteger _currentIndex;
}

@end

@implementation MHTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIColor *textColor = [UIColor blackColor];
    UITabBarItem *item1 = [[UITabBarItem alloc] init];
    item1.tag = 1;
    [item1 setTitle:@"首页"];
    [item1 setImage:[UIImage imageNamed:@"yemian"]];
    [item1 setSelectedImage:[[UIImage imageNamed:@"yemian"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item1 setTitleTextAttributes:@{NSForegroundColorAttributeName: textColor}
                         forState:UIControlStateSelected];
    
    UITabBarItem *item2 = [[UITabBarItem alloc] init];
    item2.tag = 2;
    [item2 setTitle:@"发布"];//设置了的啊
    [item2 setImage:[UIImage imageNamed:@"fabu"]];
    [item2 setSelectedImage:[[UIImage imageNamed:@"tab-Project-Click"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item2 setTitleTextAttributes:@{NSForegroundColorAttributeName: textColor}
                         forState:UIControlStateSelected];
    
    UITabBarItem *item4 = [[UITabBarItem alloc] init];
    item4.tag = 4;
    [item4 setTitle:@"我的"];
    [item4 setImage:[UIImage imageNamed:@"gerenzhongxin"]];
    [item4 setSelectedImage:[[UIImage imageNamed:@"tab-my-Click"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
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
    myController.title = item4.title;
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
    self.viewControllers = [NSArray arrayWithObjects:homeNavController,projectNavController,myNavController, nil];
    self.delegate = self;
    self.selectedIndex = 0;
    
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    //点击tabBarItem动画
    if (self.selectedIndex != _currentIndex)[self tabBarButtonClick:[self getTabBarButton]];
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
    _currentIndex = self.selectedIndex;
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
