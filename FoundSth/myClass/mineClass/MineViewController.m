//
//  MineViewController.m
//  FoundSth
//
//  Created by MCEJ on 2018/12/22.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import "MineViewController.h"
#import "UerInfoTableViewCell.h"
#import "UstSettTableViewCell.h"
#import "UsetInfoViewController.h"
#import "SettingViewController.h"
#import "FoundMyViewController.h"
#import "InforsViewController.h"
#import "FankuiViewController.h"
#import "UpdateViewController.h"
#import "DXShareView.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSString *headUrl;
@property (nonatomic,copy)NSString *aliasName;
@property (nonatomic,copy)NSString *signStr;
@property(nonatomic,strong)NSArray *menus;
@property (nonatomic,strong)UIView *heView;

@end

@implementation MineViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query getObjectInBackgroundWithId:[NSStrObject getUserInfoWith:@"objectId"] block:^(AVObject *object, NSError *error) {
        if (!error) {
            AVFile *userAvatar = [object objectForKey:@"avatar"];
            self.headUrl = userAvatar.url;
            self.aliasName = [object objectForKey:@"alias"];
            self.signStr = [object objectForKey:@"sign"];
            [self.tableView reloadData];
        }
    }];
    
    //视图将要显示时隐藏
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionFooterHeight = 0.1;
//    self.tableView.frame = mz_tableTopAndTabbarFrame;
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _menus = @[@"我的发布",@"我的消息",@"意见反馈",@"检查更新",@"分享应用",@"设置"];
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
    return _menus.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 180;
    }
    return 50;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mz_width, 20)];
    view.backgroundColor = mz_yiDongBlueColor;
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UerInfoTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"UerInfoTableViewCell" owner:self options:nil] lastObject];
        [cell.icon_imageView sd_setImageWithURL:[NSURL URLWithString:self.headUrl] placeholderImage:[UIImage imageNamed:@"headlogo"]];
        cell.userName.text = self.aliasName ? self.aliasName : @"--";
        cell.user_detaile.text = self.signStr ? self.signStr : @"还没有设置个性的签名呢~";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    UstSettTableViewCell *cell =  [[[NSBundle mainBundle]loadNibNamed:@"UstSettTableViewCell" owner:self options:nil] lastObject];
    cell.title_lable.text = _menus[indexPath.row];
    NSString *icon = @[@"user_wodefabu",@"xiaoxi",@"yijianfankui",@"jianchagengxin",@"fenxiang",@"user_gear"][indexPath.row];
    [cell.iocn_imageView setImage:[UIImage imageNamed:icon]];
     return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        UsetInfoViewController *userinfo = [[UsetInfoViewController alloc]init];
        userinfo.headUrl = self.headUrl;
        userinfo.aliasName = self.aliasName;
        userinfo.signStr = self.signStr;
        [self.navigationController pushViewController:userinfo animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 0){
        FoundMyViewController *sett = [[FoundMyViewController alloc]init];
        sett.title = @"我的发布";
        [self.navigationController pushViewController:sett animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 1){
        InforsViewController *sett = [[InforsViewController alloc]init];
        sett.title = @"我的消息";
        [self.navigationController pushViewController:sett animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 2){
        FankuiViewController *fankui = [[FankuiViewController alloc]init];
        [self.navigationController pushViewController:fankui animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 3){
        [MHProgressHUD showMsgWithoutView:@"已经是最新版本啦"];

    }else if (indexPath.section == 1 && indexPath.row == 4){
        //分享APP的连接
        [self shareAppStoryAurl];
        
    }else if (indexPath.section == 1 && indexPath.row == 5){
        SettingViewController *sett = [[SettingViewController alloc]init];
        [self.navigationController pushViewController:sett animated:YES];
    }
}

//分享APP的连接
-(void)shareAppStoryAurl
{
    NSDictionary *dic = @{
                          @"title": @"求帮助APP",
                          @"imgUrl":@"https://www.pgyer.com/xPig",
                          @"detail" : @"求帮助是一款轻量级的专业便民寻物服务类的APP，不管你在何时何地，只要拿出手机打开求帮助APP，发布自己帮助，瞬间我们会明白世界真的很小，幸福来的很突然",
                          @"image":[UIImage imageNamed:@"appIcon"]
                          };
        DXShareView *shareView = [[DXShareView alloc] init];
        DXShareModel *shareModel = [[DXShareModel alloc] init];
        shareModel.title = mzstring(dic[@"title"]);
        shareModel.descr = mzstring(dic[@"detail"]);
        shareModel.url = mzempstr(dic[@"imgUrl"]);
        shareModel.thumbImage = [NSStrObject imageWithImage:dic[@"image"] scaledToSize:CGSizeMake(200, 200)];
        [shareView showShareViewWithDXShareModel:shareModel shareContentType:DXShareContentTypeImage];

}
//终端git提交

@end
