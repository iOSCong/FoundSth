//
//  SettingViewController.m
//  FoundSth
//
//  Created by qbsqbq on 2018/12/24.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutViewController.h"
#import "ModifyPasswordViewController.h"
#import "WebUrlViewController.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *titles;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"设置";
    _titles = @[@"清除缓存",@"联系我们",@"应用版本"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionFooterHeight = 0.1;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, mz_width, 60)];
    UIButton *button = [UIButton footerButton:@"退出登录"];
    [button addTarget:^(UIButton *button) {
        [AVUser logOut];
        [MHProgressHUD showMsgWithoutView:@"你已退出登录状态!"];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"loginView" object:nil userInfo:@{@"tag":@"0"}]];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [footerView addSubview:button];
    self.tableView.tableFooterView = footerView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 1;
    }
    return _titles.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sett"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"sett"];
    }

    if (indexPath.section == 0) {
        cell.textLabel.text = @"重置密码";
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"隐私协议";
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    } else{
        if (indexPath.row != _titles.count- 1) {
            cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.text = _titles[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = [self sizeTmpPics];
        }else if (indexPath.row == 2) {
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"v%@  ",app_Version];
        }
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        ModifyPasswordViewController *vc = [[ModifyPasswordViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//        ProtocolViewController *vc = [[ProtocolViewController alloc] init];
        WebUrlViewController *vc = [[WebUrlViewController alloc] init];
        vc.isShow = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        if (indexPath.row == 0) {
            //清除图片缓存
            [MHProgressHUD showProgress:@"正在清除..." inView:self.view];
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                [MHProgressHUD hide];
                [MHProgressHUD showMsgWithoutView:@"清除完成"];
                [self.tableView reloadData];
            }];
            [[SDImageCache sharedImageCache] clearMemory];//可不写
        }else if (indexPath.row == 1 ){
            AboutViewController *about = [[AboutViewController alloc]init];
            [self.navigationController pushViewController:about animated:YES];
        }else if (indexPath.row == 2 ){
            [MHProgressHUD showMsgWithoutView:@"已是最新版本!"];
        }
    }
}

- (NSString *)sizeTmpPics
{
    NSUInteger tmpSize = [[SDImageCache sharedImageCache] getSize];
    NSString *clearCacheName;
    if (tmpSize >= 1024*1024*1024) {
        clearCacheName = mz_NSTstring(@"%.2fG", tmpSize/(1024.f*1024.f*1024.f));
    }else if (tmpSize >= 1024*1024) {
        clearCacheName = mz_NSTstring(@"%.2fM", tmpSize/(1024.f*1024.f*1024.f));
    }else{
        clearCacheName = mz_NSTstring(@"%.2fK", tmpSize/(1024.f*1024.f*1024.f));
    }
    return clearCacheName;
}


-(void)dealloc{
    NSLog(@"移除了所有的通知");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
