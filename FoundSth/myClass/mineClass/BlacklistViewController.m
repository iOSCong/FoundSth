//
//  BlacklistViewController.m
//  FoundSth
//
//  Created by MCEJ on 2019/1/12.
//  Copyright © 2019年 MCEJ. All rights reserved.
//

#import "BlacklistViewController.h"
#import "YMRefresh.h"
#import "FoundMyTableViewCell.h"
#import "InforDetailViewController.h"

@interface BlacklistViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) YMRefresh *refresh;
@property (nonatomic,strong)NSArray *dataArr;

@end


@implementation BlacklistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.hidden = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"FoundMyTableViewCell" bundle:nil] forCellReuseIdentifier:@"FoundMyTableViewCell"];
    
    [self queryData];
    
    mzWeakSelf(self);
    _refresh = [[YMRefresh alloc] init];
    [_refresh gifModelRefresh:self.tableView refreshType:RefreshTypeDropDown firstRefresh:NO timeLabHidden:YES stateLabHidden:YES dropDownBlock:^{
        [self queryData];
        if ([weakself.tableView.mj_header isRefreshing]) {
            [weakself.tableView.mj_header endRefreshing];
        }
    } upDropBlock:^{}];
    
}

- (void)queryData
{
    AVQuery *query = [AVQuery queryWithClassName:@"blackList"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"owner"];
    query.limit = 20;
    [MHProgressHUD showProgress:@"加载中..." inView:self.view];
    //    [query whereKey:@"ownerId" equalTo:[NSStrObject getUserInfoWith:@"objectId"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.tableView.hidden = NO;
        [MHProgressHUD hide];
        if (!error) {
            self.dataArr = [NSMutableArray arrayWithArray:objects];
            [self.tableView reloadData];
        }else{
            [MHProgressHUD showMsgWithoutView:@"请求失败"];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FoundMyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FoundMyTableViewCell"];
    AVUser *owner = self.dataArr[indexPath.row][@"owner"];
    AVFile *userAvatar = [owner objectForKey:@"avatar"];
    if (userAvatar) {
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:userAvatar.url] placeholderImage:[UIImage imageNamed:@"headlogo"]];
    }else{
        cell.imgView.image = [UIImage imageNamed:@"headlogo"];
    }
    cell.titleLabel.text = [owner objectForKey:@"alias"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//删除操作
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"移除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 执行 CQL 语句实现删除一个 homeList 对象
        NSString *sql = [NSString stringWithFormat:@"delete from blackList where objectId='%@'",self.dataArr[indexPath.row][@"objectId"]];
        [AVQuery doCloudQueryInBackgroundWithCQL:sql callback:^(AVCloudQueryResult *result, NSError *error) {
            [self queryData];
            [self.tableView reloadData];
        }];
    }
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
