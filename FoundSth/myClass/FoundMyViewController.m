//
//  FoundMyViewController.m
//  FoundSth
//
//  Created by MCEJ on 2018/12/24.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import "FoundMyViewController.h"
#import "FoundReleaseViewController.h"
#import "FoundMyTableViewCell.h"
#import "YMRefresh.h"

@interface FoundMyViewController () <UITableViewDelegate,UITableViewDataSource,ReleaseDelegate>

@property (nonatomic, strong) YMRefresh *refresh;
@property (nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation FoundMyViewController

- (void)addViewShow
{
    [self.navigationController pushViewController:[[FoundReleaseViewController alloc] init] animated:YES];
}

- (void)loginViewNotice:(NSNotification *)notice
{
    if ([notice.userInfo[@"tag"] isEqualToString:@"1"]) { //登录成功
        [self queryData];
    }
}

- (void)refreshTableView
{
    [self queryData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginViewNotice:)name:@"loginView" object:nil];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addViewShow)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
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
    AVQuery *query = [AVQuery queryWithClassName:@"homeList"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"image"];
    query.limit = 10;
    [MHProgressHUD showProgress:@"加载中..." inView:self.view];
    [query whereKey:@"ownerId" equalTo:[NSStrObject getUserInfoWith:@"objectId"]];
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
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FoundMyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FoundMyTableViewCell"];
    AVFile *imageFile = self.dataArr[indexPath.row][@"image"];
    if (imageFile) {
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:imageFile.url] placeholderImage:[UIImage imageNamed:@"placehoald"]];
    }
    cell.titleLabel.text = self.dataArr[indexPath.row][@"title"];
    NSDate *createdAt = self.dataArr[indexPath.row][@"updatedAt"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    cell.dateLabel.text = [dateFormatter stringFromDate:createdAt];
    cell.typeLabel.text = self.dataArr[indexPath.row][@"detail"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FoundReleaseViewController *vc = [[FoundReleaseViewController alloc] init];
    vc.tag = 1;
    vc.objectId = mzstring(self.dataArr[indexPath.row][@"objectId"]);
    vc.titleStr = mzstring(self.dataArr[indexPath.row][@"title"]);
    FoundMyTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    vc.contentImg = cell.imgView.image;
    vc.detailStr = mzstring(self.dataArr[indexPath.row][@"detail"]);
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
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
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 执行 CQL 语句实现删除一个 homeList 对象
        NSString *sql = [NSString stringWithFormat:@"delete from homeList where objectId='%@'",self.dataArr[indexPath.row][@"objectId"]];
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
