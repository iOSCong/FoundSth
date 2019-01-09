//
//  FoundDetailViewController.m
//  FoundSth
//
//  Created by MCEJ on 2019/1/9.
//  Copyright © 2019年 MCEJ. All rights reserved.
//

#import "FoundDetailViewController.h"
#import "YBImageBrowser.h"

@interface FoundDetailViewController () <UITableViewDelegate,UITableViewDataSource>

@end


@implementation FoundDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100; //随便设个不那么离谱的值
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    if (self.imgUrl) {
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:self.imgUrl] placeholderImage:[UIImage imageNamed:@"placehoald"]];
        //图片自适应宽高
        self.headImgView.contentMode = UIViewContentModeScaleAspectFill;
        self.headImgView.autoresizesSubviews = YES;
        self.headImgView.layer.masksToBounds = YES;  //图片裁剪
        self.headImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeadImgViewHandle)];
        [self.headImgView addGestureRecognizer:tap];
        self.tableView.tableHeaderView = self.headView;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.detailLabel.text = self.detailStr;
    return self.detailCell;
}

#pragma mark 配置数据源
- (void)tapHeadImgViewHandle
{
    YBImageBrowserModel *model = [YBImageBrowserModel new];
    [model setImageWithImageName:self.headImgView.image];
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
