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

@interface FoundListViewController () <UITableViewDelegate,UITableViewDataSource,YBImageBrowserDelegate,YBImageBrowserDataSource>

@property (nonatomic,strong)NSArray *dataArr;
@property (nonatomic,assign)NSInteger indexp;
@property (nonatomic,strong)UIImage *tempImg;
@property (nonatomic,strong)NSMutableArray *imgArr;

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
    
    self.imgArr = [NSMutableArray array];
    
    self.tableView.hidden = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionHeaderHeight = 1.0f;
    self.tableView.estimatedRowHeight = 100; //随便设个不那么离谱的值
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FoundListTableViewCell" bundle:nil] forCellReuseIdentifier:@"FoundListTableViewCell"];
    
//    [self requestData];
    
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
//        NSLog(@"userAvatar==%@",userAvatar.url);
        [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:userAvatar.url] placeholderImage:[UIImage imageNamed:@"placehoald"]];
    }
    cell.nameLabel.text = self.dataArr[indexPath.row][@"title"];
    
    NSDate *createdAt = self.dataArr[indexPath.row][@"updatedAt"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    cell.timeLabel.text = [dateFormatter stringFromDate:createdAt];
    
    AVFile *imageFile = self.dataArr[indexPath.row][@"image"];
    if (imageFile) {
//    NSLog(@"imageFile==%@",imageFile.url);
        [cell.contentImgView sd_setImageWithURL:[NSURL URLWithString:imageFile.url] placeholderImage:[UIImage imageNamed:@"placehoald"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            self.tempImg = image;
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:[NSNumber numberWithInteger:indexPath.row] forKey:@"index"];
            [dic setValue:image forKey:@"image"];
            [self.imgArr addObject:dic];
            NSLog(@"%ld===%@",indexPath.row, self.imgArr[indexPath.row]);
        }];
        cell.contentImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeadImgViewHandle)];
        [cell.contentImgView addGestureRecognizer:tap];
        self.tempImg = cell.contentImgView.image;
        self.indexp = indexPath.row;
    }
    
    cell.detailLabel.text = self.dataArr[indexPath.row][@"detail"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark 配置数据源
- (void)tapHeadImgViewHandle
{
    YBImageBrowserModel *model = [YBImageBrowserModel new];
    AVFile *imageFile = self.dataArr[self.indexp][@"image"];
    if (imageFile) {
        NSLog(@"url==%@",imageFile.url);
        [MHProgressHUD showProgress:@"加载中..." inView:self.view];
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageFile.url]];
        [model setImageWithImageName:[UIImage imageWithData:data]];
        [MHProgressHUD hide];
        YBImageBrowser *browser = [YBImageBrowser new];
        browser.dataArray = @[model];
        browser.currentIndex = 0;
        [browser show];
    }
}


#pragma mark 使用数组配置数据源
//- (void)tapHeadImgViewHandle
//{
//    //创建图片浏览器
//    YBImageBrowser *browser = [YBImageBrowser new];
//    browser.dataSource = self;
//    browser.currentIndex = 0;
//    [browser show];
//}
////YBImageBrowserDataSource 代理实现赋值数据
//- (NSInteger)numberInYBImageBrowser:(YBImageBrowser *)imageBrowser {
//    return 1;
//}
//- (YBImageBrowserModel *)yBImageBrowser:(YBImageBrowser *)imageBrowser modelForCellAtIndex:(NSInteger)index {
//    YBImageBrowserModel *model = [YBImageBrowserModel new];
//    AVFile *imageFile = self.dataArr[self.indexp][@"image"];
//    model.url = [NSURL URLWithString:[imageFile.url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    return model;
//}
//- (UIImageView * _Nullable)imageViewOfTouchForImageBrowser:(nonnull YBImageBrowser *)imageBrowser {
//    return nil;
//}



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
