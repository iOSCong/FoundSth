//
//  UsetInfoViewController.m
//  FoundSth
//
//  Created by qbsqbq on 2018/12/23.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import "UsetInfoViewController.h"
#import "IconTableViewCell.h"
#import "EidetViewController.h"
#import "ZLPhotoActionSheet.h"

@interface UsetInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)IconTableViewCell *headCell;
@property(nonatomic,strong)NSArray *infos;
@property(nonatomic,strong)NSArray *na_titles;


@end

@implementation UsetInfoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"个人信息";
    _infos = @[@"美丽的草原我的家",@"我住在美丽的草原上哈"];
    _na_titles = @[@"设置昵称",@"设置个性签名"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionFooterHeight = 0.1;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
//    [self requestData];
    
}

- (void)requestData
{
    AVQuery *query = [AVQuery queryWithClassName:@"homeList"];
//    [query orderByDescending:@"createdAt"];
    [query includeKey:@"owner"];
//    [query includeKey:@"image"];
//    query.limit = 10;
    [MHProgressHUD showProgress:@"加载中..." inView:self.view];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MHProgressHUD hide];
        if (!error) {
            [self.tableView reloadData];
        }else{
            [MHProgressHUD showMsgWithoutView:@"请求失败"];
        }
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (self.headCell == nil) {
            self.headCell = [[[NSBundle mainBundle]loadNibNamed:@"IconTableViewCell" owner:self options:nil] lastObject];
            [self.headCell.headImgView sd_setImageWithURL:[NSURL URLWithString:self.headUrl] placeholderImage:[UIImage imageNamed:@"NoData"]];
            self.headCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return self.headCell;
        }
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"icon"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"icon"];
    }
    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = @[@"昵称",@"个性签名"][indexPath.row -1];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.text = _infos[indexPath.row - 1];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
        //设置照片最大选择数
        actionSheet.maxSelectCount = 1;
        //设置照片最大预览数
        actionSheet.maxPreviewCount = 50;
        [actionSheet showPreviewPhotoWithSender:self animate:YES lastSelectPhotoModels:nil completion:^(NSArray<UIImage *> * _Nonnull selectPhotos, NSArray<ZLSelectPhotoModel *> * _Nonnull selectPhotoModels) {
            [self settingHeadImage:selectPhotos[0]];
        }];
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EidetViewController *eide = [[EidetViewController alloc]init];
    eide.userName =  _infos[indexPath.row - 1];
    eide.title_na = _na_titles[indexPath.row - 1];
    [self.navigationController pushViewController:eide animated:YES];
}

- (void)settingHeadImage:(UIImage *)image
{
    NSData * imageData = UIImagePNGRepresentation(image);
    AVUser *currentuser = [AVUser currentUser];
    AVFile *avatarFile = [AVFile fileWithData:imageData];
    [currentuser setObject:avatarFile forKey:@"avatar"];
    [MHProgressHUD showProgress:@"正在上传..." inView:self.view];
    [currentuser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [MHProgressHUD hide];
        if (succeeded) {
            [MHProgressHUD showMsgWithoutView:@"上传成功"];
            self.headCell.headImgView.image = image;
        } else {
            NSLog(@"保存新物品出错 %@", error.localizedFailureReason);
            [MHProgressHUD showMsgWithoutView:error.localizedFailureReason];
        }
    }];
}



@end
