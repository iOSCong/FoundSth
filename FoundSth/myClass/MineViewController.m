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
@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MineViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionFooterHeight = 0.1;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
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
    return 3;
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
        cell.userName.text = @"七号";
        return cell;

    }
    
    UstSettTableViewCell *cell =  [[[NSBundle mainBundle]loadNibNamed:@"UstSettTableViewCell" owner:self options:nil] lastObject];
    cell.title_lable.text = @[@"我的发布",@"我的地址",@"设置"][indexPath.row];
    NSString *icon = @[@"user_wodefabu",@"user_dizhi",@"user_gear"][indexPath.row];
    [cell.iocn_imageView setImage:[UIImage imageNamed:icon]];
     return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        UsetInfoViewController *userinfo = [[UsetInfoViewController alloc]init];
        [self.navigationController pushViewController:userinfo animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 2){
        SettingViewController *sett = [[SettingViewController alloc]init];
        [self.navigationController pushViewController:sett animated:YES];
    }
    
}



@end
