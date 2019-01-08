//
//  WebViewController.m
//  NengShou
//
//  Created by MCEJ on 2018/12/19.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import "WebViewController.h"
#import "WebView.h"

@interface WebViewController () <WebViewDelegate>

@property (nonatomic, strong)  WebView *webView;

@end

@implementation WebViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.webView)
    {
        [self.webView timerKill];
    }
}

- (void)loadView
{
    [super loadView];
    //    self.view.backgroundColor = [UIColor greenColor];
    //    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    //    {
    //        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    //    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"加载中...";
    self.view.backgroundColor = [UIColor whiteColor];
//    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self webViewUIPush];
}

#pragma mark 网页视图
- (void)webViewUIPush
{
    WeakWebView;
    // 方法1 实例化
    //    self.webView = [[ZLCWebView alloc] initWithFrame:self.view.bounds];
    // 方法2 实例化
    self.webView = [[WebView alloc] init];
    [self.view addSubview:self.webView];
//    self.webView.frame = self.view.bounds;
    self.webView.frame = mz_frame(0, iPhoneNavH, mz_width, mz_height-iPhoneNavH);
    self.webView.url = self.url;
    self.webView.isBackRoot = NO;
    self.webView.showActivityView = YES;
    self.webView.showActionButton = YES;
    [self.webView reloadUI:YES];
    [self.webView loadRequest:^(WebView *webView, NSString *title, NSURL *url) {
//        NSLog(@"准备加载。title = %@, url = %@", title, url);
        weakWebView.title = title;
    } didStart:^(WebView *webView) {
//        NSLog(@"开始加载。");
    } didFinish:^(WebView *webView, NSString *title, NSURL *url) {
//        NSLog(@"成功加载。title = %@, url = %@", title, url);
        weakWebView.title = title;
    } didFail:^(WebView *webView, NSString *title, NSURL *url, NSError *error) {
//        NSLog(@"失败加载。title = %@, url = %@, error = %@", title, url, error);
        weakWebView.title = title;
    }];
}

#pragma mark - 响应事件

- (void)backPreviousController
{
    if (self.webView)
    {
        if (self.webView.isBackRoot)
        {
            [self.webView stopLoading];
            
            if ([self.navigationController.viewControllers indexOfObject:self] == 0)
            {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
        else
        {
            if ([self.webView canGoBack])
            {
                [self.webView goBack];
            }
            else
            {
                if ([self.navigationController.viewControllers indexOfObject:self] == 0)
                {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                else
                {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }
        }
    }
}

#pragma mark - WebViewDelegate

- (void)progressWebViewDidStartLoad:(WebView *)webview
{
//    NSLog(@"开始加载。");
}

- (void)progressWebView:(WebView *)webview title:(NSString *)title shouldStartLoadWithURL:(NSURL *)url
{
//    NSLog(@"准备加载。title = %@, url = %@", title, url);
    self.title = title;
}

- (void)progressWebView:(WebView *)webview title:(NSString *)title didFinishLoadingURL:(NSURL *)url
{
//    NSLog(@"成功加载。title = %@, url = %@", title, url);
    self.title = title;
}

- (void)progressWebView:(WebView *)webview title:(NSString *)title didFailToLoadURL:(NSURL *)url error:(NSError *)error
{
//    NSLog(@"失败加载。title = %@, url = %@, error = %@", title, url, error);
    self.title = title;
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
