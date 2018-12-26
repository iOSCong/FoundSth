//
//  AboutViewController.m
//  FoundSth
//
//  Created by qbsqbq on 2018/12/24.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import "AboutViewController.h"
#import "AboutTableViewCell.h"
@interface AboutViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation AboutViewController

- (void)viewDidLoad {
    //开始可推送了
    
    [super viewDidLoad];
    self.title = @"关于";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 300;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AboutTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"AboutTableViewCell" owner:self options:nil] lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}



@end
