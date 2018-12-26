//
//  MineViewController.m
//  FoundSth
//
//  Created by MCEJ on 2018/12/22.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import "MineViewController.h"
#import "UerInfoTableViewCell.h"
#import "UstSettTableViewCell.h"
#import "UsetInfoViewController.h"
#import "SettingViewController.h"
#import "FoundMyViewController.h"
#import "InforsViewController.h"
#import "FankuiViewController.h"
@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSString *headUrl;
@property (nonatomic,copy)NSString *aliasName;
@property (nonatomic,copy)NSString *signStr;
@property(nonatomic,strong)NSArray *menus;
@end

@implementation MineViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query getObjectInBackgroundWithId:[NSStrObject getUserInfoWith:@"objectId"] block:^(AVObject *object, NSError *error) {
        if (!error) {
            AVFile *userAvatar = [object objectForKey:@"avatar"];
            self.headUrl = userAvatar.url;
            self.aliasName = [object objectForKey:@"alias"];
            self.signStr = [object objectForKey:@"sign"];
            [self.tableView reloadData];
        }
    }];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionFooterHeight = 0.1;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _menus = @[@"我的发布",@"我的消息",@"意见反馈",@"设置"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return _menus.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UerInfoTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"UerInfoTableViewCell" owner:self options:nil] lastObject];
        [cell.icon_imageView sd_setImageWithURL:[NSURL URLWithString:self.headUrl] placeholderImage:[UIImage imageNamed:@"headlogo"]];
        cell.userName.text = self.aliasName ? self.aliasName : @"--";
        cell.user_detaile.text = self.signStr ? self.signStr : @"还没有设置个性的签名呢~";
        return cell;
    }
    
    UstSettTableViewCell *cell =  [[[NSBundle mainBundle]loadNibNamed:@"UstSettTableViewCell" owner:self options:nil] lastObject];
    cell.title_lable.text = _menus[indexPath.row];
    NSString *icon = @[@"user_wodefabu",@"xiaoxi",@"yijianfankui",@"user_gear"][indexPath.row];
    [cell.iocn_imageView setImage:[UIImage imageNamed:icon]];
     return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        UsetInfoViewController *userinfo = [[UsetInfoViewController alloc]init];
        userinfo.headUrl = self.headUrl;
        userinfo.aliasName = self.aliasName;
        userinfo.signStr = self.signStr;
        [self.navigationController pushViewController:userinfo animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 0){
        FoundMyViewController *sett = [[FoundMyViewController alloc]init];
        sett.title = @"我的发布";
        [self.navigationController pushViewController:sett animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 1){
        InforsViewController *sett = [[InforsViewController alloc]init];
        sett.title = @"我的消息";
        [self.navigationController pushViewController:sett animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 2){
        FankuiViewController *fankui = [[FankuiViewController alloc]init];
        [self.navigationController pushViewController:fankui animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 3){
        SettingViewController *sett = [[SettingViewController alloc]init];
        [self.navigationController pushViewController:sett animated:YES];
    }
}



@end
