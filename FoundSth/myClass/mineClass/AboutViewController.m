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
   
    [super viewDidLoad];
    self.title = @"联系我们";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
        return 300;
    }
    return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"如您有什么疑问,可通过以下两种方式联系我们,我们将随时为您解答.";
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        AboutTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"AboutTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aa"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"aa"];
        }
            cell.textLabel.text = @[@"QQ群",@"QQ邮箱",@"联系电话"][indexPath.row];
            cell.detailTextLabel.text = @[@"801065836",@"qbs_qbq@163.com",@"13139586707"][indexPath.row];

        cell.textLabel.font = mz_font(15);
        cell.detailTextLabel.font = mz_font(15);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return [[UITableViewCell alloc] init];
}



@end
