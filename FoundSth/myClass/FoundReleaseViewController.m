//
//  FoundReleaseViewController.m
//  FoundSth
//
//  Created by MCEJ on 2018/12/22.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import "FoundReleaseViewController.h"

@interface FoundReleaseViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *detail;
@property (nonatomic,strong)NSString *price;
@property (nonatomic,strong)UIImage *image;

@end

@implementation FoundReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.hidden = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.text = @"sss";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (void)requestData
{
    AVQuery *query = [AVQuery queryWithClassName:@"myData"];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;
    [MHProgressHUD showMessage:@"加载中..." inView:self.view];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MHProgressHUD hide];
        if (!error) {

        }else{
            [MHProgressHUD showMsgWithoutView:@"请求失败"];
        }
    }];
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
