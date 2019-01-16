//
//  WebUrlViewController.m
//  NengShou
//
//  Created by MCEJ on 2018/12/20.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import "WebUrlViewController.h"
#import "WebView.h"

@interface WebUrlViewController () <WebViewDelegate>

@property (nonatomic, strong)  WebView *webView;

@end

@implementation WebUrlViewController

- (void)popToView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.title = @"隐私协议";
    self.view.backgroundColor = [UIColor whiteColor];
    //    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popToView)name:@"popToView" object:nil];
    
//    [self setUI];
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mz_width, iPhoneNavH)];
    navView.backgroundColor = mz_mainColor;
    navView.alpha = 1;
    [self.view addSubview:navView];
    
    [self requestData];
    
}

- (void)requestData
{
    AVQuery *query = [AVQuery queryWithClassName:@"protocol"];
    [query includeKey:@"file"];
    query.limit = 10;
    [MHProgressHUD showProgress:@"加载中..." inView:self.view];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MHProgressHUD hide];
        if (error == nil) {
            if (objects.count) {
                AVFile *file = objects[0][@"file"];
                if (file) {
                    self.url = [NSString stringWithFormat:@"%@",file.url];
                    [self setUI];
                }
            }
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)ssss
{
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mz_width, iPhoneNavH)];
    navView.backgroundColor = mz_mainColor;
    navView.alpha = 1;
    [self.view addSubview:navView];
    
    
    AVQuery *query = [AVQuery queryWithClassName:@"config"];
    [query orderByDescending:@"webspike"];
    [query orderByDescending:@"url"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error == nil) {
            if (objects.count) {
                self.url = [NSString stringWithFormat:@"%@",objects[0][@"url"]];
                [self setUI];
            }
        }else{
            [MHProgressHUD showMsgWithoutView:@"加载超时,请退出应用后重新启动"];
        }
    }];
    
}

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

#pragma mark - 创建视图

- (void)setUI
{
    if (_isShow) {
        [self navigationItemButtonUI];
    }
    
    [self webViewUIPresent];
    
//    if ([self.navigationController.viewControllers indexOfObject:self] == 0) {
//        [self webViewUIPresent];
//    }else{
//        [self webViewUIPush];
//    }
}

#pragma mark 网页视图

- (void)webViewUIPush
{
    NSLog(@"url==%@",self.url);
    
//    WeakWebView;
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
    [self.webView reloadUI:NO];
    [self.webView loadRequest:^(WebView *webView, NSString *title, NSURL *url) {
        NSLog(@"准备加载。title = %@, url = %@", title, url);
//        weakWebView.title = title;
    } didStart:^(WebView *webView) {
        NSLog(@"开始加载。");
    } didFinish:^(WebView *webView, NSString *title, NSURL *url) {
        NSLog(@"成功加载。title = %@, url = %@", title, url);
//        weakWebView.title = title;
    } didFail:^(WebView *webView, NSString *title, NSURL *url, NSError *error) {
        NSLog(@"失败加载。title = %@, url = %@, error = %@", title, url, error);
//        weakWebView.title = title;
    }];
}

- (void)webViewUIPresent
{
    // 方法1 实例化
    //    self.webView = [[ZLCWebView alloc] initWithFrame:self.view.bounds];
    // 方法2 实例化
    self.webView = [[WebView alloc] init];
    [self.view addSubview:self.webView];
//    self.webView.frame = self.view.bounds;
    self.webView.frame = mz_frame(0, iPhoneNavH, mz_width, mz_height-iPhoneNavH+40);
    self.webView.url = self.url;
    self.webView.isBackRoot = NO;
    self.webView.showActivityView = YES;
    self.webView.showActionButton = YES;
    self.webView.backButton.backgroundColor = [UIColor yellowColor];
    self.webView.forwardButton.backgroundColor = [UIColor greenColor];
    self.webView.reloadButton.backgroundColor = [UIColor brownColor];
    [self.webView reloadUI:NO];
    self.webView.delegate = self;
}

#pragma mark 取消按钮

- (void)navigationItemButtonUI
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(mz_width-60.0, 0.0, 40.0, 40.0);
//    backButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, -20.0, 0.0, 0.0);
//    [backButton setImage:[UIImage imageNamed:@"backPreviousImage"] forState:UIControlStateNormal];
    [backButton setTitle:@"取消" forState:UIControlStateNormal];
    backButton.titleLabel.font = mz_font(15);
    [backButton addTarget:self action:@selector(backPreviousController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc ] initWithCustomView:backButton];
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
    NSLog(@"开始加载。");
}

- (void)progressWebView:(WebView *)webview title:(NSString *)title shouldStartLoadWithURL:(NSURL *)url
{
    NSLog(@"准备加载。title = %@, url = %@", title, url);
//    self.title = title;
}

- (void)progressWebView:(WebView *)webview title:(NSString *)title didFinishLoadingURL:(NSURL *)url
{
    NSLog(@"成功加载。title = %@, url = %@", title, url);
//    self.title = title;
}

- (void)progressWebView:(WebView *)webview title:(NSString *)title didFailToLoadURL:(NSURL *)url error:(NSError *)error
{
    NSLog(@"失败加载。title = %@, url = %@, error = %@", title, url, error);
//    self.title = title;
}

-(void)dealloc
{
    self.webView = nil;
    NSLog(@"%@ 被释放了!!!", self);
    
    //移除了名称为tongzhi的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"popToView" object:nil];
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

