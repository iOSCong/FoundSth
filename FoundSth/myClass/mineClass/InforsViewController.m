//
//  InforsViewController.m
//  FoundSth
//
//  Created by MCEJ on 2018/12/26.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import "InforsViewController.h"
#import "YMRefresh.h"
#import "FoundMyTableViewCell.h"
#import "InforDetailViewController.h"

@interface InforsViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) YMRefresh *refresh;
@property (nonatomic,strong)NSArray *dataArr;

@end


@implementation InforsViewController

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
    AVQuery *query = [AVQuery queryWithClassName:@"message"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"image"];
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
    cell.imgView.image = [UIImage imageNamed:@"listchecknoteb"];
    cell.titleLabel.text = self.dataArr[indexPath.row][@"title"];
    cell.titleLabel.numberOfLines = 1;
    NSDate *createdAt = self.dataArr[indexPath.row][@"updatedAt"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    cell.dateLabel.text = [dateFormatter stringFromDate:createdAt];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    InforDetailViewController *vc = [[InforDetailViewController alloc] init];
    vc.title = mzstring(self.dataArr[indexPath.row][@"title"]);
    AVFile *imageFile = self.dataArr[indexPath.row][@"image"];
    if (imageFile) vc.imgUrl = imageFile.url;
    vc.detailStr = mzstring(self.dataArr[indexPath.row][@"detail"]);
    [self.navigationController pushViewController:vc animated:YES];
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
