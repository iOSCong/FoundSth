//
//  FoundListViewController.m
//  FoundSth
//
//  Created by MCEJ on 2018/12/22.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import "FoundListViewController.h"
#import "FoundListTableViewCell.h"
#import "YBImageBrowser.h"
#import "YMRefresh.h"

@interface FoundListViewController () <UITableViewDelegate,UITableViewDataSource,YBImageBrowserDelegate>

@property (nonatomic, strong) YMRefresh *refresh;
@property (nonatomic,strong)NSArray *dataArr;

@end

@implementation FoundListViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    [self requestData];
    [AVAnalytics beginLogPageView:@"ProductList"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [AVAnalytics endLogPageView:@"ProductList"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.hidden = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionHeaderHeight = 1.0f;
    self.tableView.estimatedRowHeight = 100; //随便设个不那么离谱的值
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.frame = mz_tableTabbarFrame;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FoundListTableViewCell" bundle:nil] forCellReuseIdentifier:@"FoundListTableViewCell"];
    
    [self requestData];
    
    mzWeakSelf(self);
    _refresh = [[YMRefresh alloc] init];
    [_refresh gifModelRefresh:self.tableView refreshType:RefreshTypeDropDown firstRefresh:NO timeLabHidden:YES stateLabHidden:YES dropDownBlock:^{
        [self requestData];
        if ([weakself.tableView.mj_header isRefreshing]) {
            [weakself.tableView.mj_header endRefreshing];
        }
    } upDropBlock:^{}];
    
}

- (void)requestData
{
    AVQuery *query = [AVQuery queryWithClassName:@"homeList"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"owner"];
    [query includeKey:@"image"];
    query.limit = 10;
    [MHProgressHUD showProgress:@"加载中..." inView:self.view];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.tableView.hidden = NO;
        [MHProgressHUD hide];
        if (!error) {
            self.dataArr = objects;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FoundListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FoundListTableViewCell"];
    
    AVUser *owner = self.dataArr[indexPath.row][@"owner"];
    AVFile *userAvatar =[owner objectForKey:@"avatar"];
    if (userAvatar) {
        [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:userAvatar.url] placeholderImage:[UIImage imageNamed:@"placehoald"]];
    }
    cell.nameLabel.text = self.dataArr[indexPath.row][@"title"];
    
    NSDate *createdAt = self.dataArr[indexPath.row][@"updatedAt"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    cell.timeLabel.text = [dateFormatter stringFromDate:createdAt];
    
    AVFile *imageFile = self.dataArr[indexPath.row][@"image"];
    if (imageFile) {
        [cell.contentImgView sd_setImageWithURL:[NSURL URLWithString:imageFile.url] placeholderImage:[UIImage imageNamed:@"placehoald"]];
        mzWeakSelf(self);
        [cell.imageBtn addTarget:^(UIButton *button) {
            [weakself tapHeadImgViewHandle:cell.contentImgView.image];
        }];
    }
    cell.detailLabel.text = self.dataArr[indexPath.row][@"detail"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark 配置数据源
- (void)tapHeadImgViewHandle:(UIImage *)image
{
    YBImageBrowserModel *model = [YBImageBrowserModel new];
    [model setImageWithImageName:image];
    [MHProgressHUD hide];
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataArray = @[model];
    browser.currentIndex = 0;
    [browser show];
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
