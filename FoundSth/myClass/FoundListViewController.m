//
//  FoundListViewController.m
//  FoundSth
//
//  Created by MCEJ on 2018/12/22.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import "FoundListViewController.h"
#import "FoundListTableViewCell.h"

@interface FoundListViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSArray *dataArr;

@end

@implementation FoundListViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self requestData];
    [AVAnalytics beginLogPageView:@"ProductList"];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [AVAnalytics endLogPageView:@"ProductList"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.hidden = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionHeaderHeight = 1.0f;
    self.tableView.estimatedRowHeight = 100; //随便设个不那么离谱的值
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FoundListTableViewCell" bundle:nil] forCellReuseIdentifier:@"FoundListTableViewCell"];
    
}

- (void)requestData
{
    AVQuery *query = [AVQuery queryWithClassName:@"homeList"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"owner"];
    [query includeKey:@"image"];
    query.limit = 10;
    [MHProgressHUD showMessage:@"加载中..." inView:self.view];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
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
        NSLog(@"userAvatar==%@",userAvatar.url);
        [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:userAvatar.url] placeholderImage:[UIImage imageNamed:@"placehoald"]];
    }
    cell.nameLabel.text = self.dataArr[indexPath.row][@"title"];
    
    NSDate *createdAt = self.dataArr[indexPath.row][@"updatedAt"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    cell.timeLabel.text = [dateFormatter stringFromDate:createdAt];
    
    AVFile *imageFile = self.dataArr[indexPath.row][@"image"];
    NSLog(@"imageFile==%@",imageFile.url);
    [cell.contentImgView sd_setImageWithURL:[NSURL URLWithString:imageFile.url] placeholderImage:[UIImage imageNamed:@"placehoald"]];
    cell.detailLabel.text = self.dataArr[indexPath.row][@"detail"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
