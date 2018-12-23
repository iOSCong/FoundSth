//
//  SettingViewController.m
//  FoundSth
//
//  Created by qbsqbq on 2018/12/24.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutViewController.h"
@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *titles;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"个人信息";
    _titles = @[@"清除缓存",@"关于",@"版本"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionFooterHeight = 0.1;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
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
    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.text = _titles[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.row == 2) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        cell.detailTextLabel.text = app_Version;
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [MHProgressHUD showMsgWithoutView:@"清除缓存成功"];
        
    }else if (indexPath.row == 1 ){
        AboutViewController *about = [[AboutViewController alloc]init];
        [self.navigationController pushViewController:about animated:YES];
    }else if (indexPath.row == 2){
        [MHProgressHUD showMsgWithoutView:@"已是最新版本"];
        
    }
}

@end
