//
//  UsetInfoViewController.m
//  FoundSth
//
//  Created by qbsqbq on 2018/12/23.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import "UsetInfoViewController.h"
#import "IconTableViewCell.h"
#import "EidetViewController.h"
@interface UsetInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *infos;
@property(nonatomic,strong)NSArray *na_titles;


@end

@implementation UsetInfoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"个人信息";
    _infos = @[@"美丽的草原我的家",@"我住在美丽的草原上哈"];
    _na_titles = @[@"设置昵称",@"设置个性签名"];
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

    return 3;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        IconTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"IconTableViewCell" owner:self options:nil] lastObject];
        return cell;
        
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"icon"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"icon"];
    }
    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = @[@"昵称",@"个性签名"][indexPath.row -1];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.text = _infos[indexPath.row - 1];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EidetViewController *eide = [[EidetViewController alloc]init];
    eide.userName =  _infos[indexPath.row - 1];
    eide.title_na = _na_titles[indexPath.row - 1];
    [self.navigationController pushViewController:eide animated:YES];
  
    
}



@end
