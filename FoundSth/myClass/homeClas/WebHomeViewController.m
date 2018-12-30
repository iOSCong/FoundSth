//
//  HomeViewController.m
//  HZMHIOS
//
//  Created by MCEJ on 2018/7/17.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import "WebHomeViewController.h"
#import "SDCycleScrollView.h"
#import "WebViewController.h"

#define headScrollHeight (iPhoneNavH+130)
#define scrollHeight 90

@interface WebHomeViewController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property(nonatomic, strong) NSMutableArray * rowArr0;
@property(nonatomic, strong) NSMutableArray * rowArr1;

//@property(nonatomic, strong) NSString *urlStr;
//@property(nonatomic, assign) int intType;
//@property(nonatomic, assign) int section;


@end

@implementation WebHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.title = @"首页";
//    self.view.backgroundColor = mz_tableViewBackColor;
    
    [self initView];
    
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
//            self.dataArr = objects;
//            [self.tableView reloadData];
        }else{
            [MHProgressHUD showMsgWithoutView:@"请求失败"];
        }
    }];
}

- (void)initView
{
    //公交
    NSString *gongjiao = @"https://web.chelaile.net.cn/wwd/index?src=webapp_app_zhihuijinfeng";
    //人事考试
//    NSString *renshi = @"http://zg.cpta.com.cn/examfront/register/login.jsp";
    //美团
    NSString *meituan = @"https://www.meituan.com";
    //电影
    NSString *maoyan = @"https://maoyan.com";
    //头条
//    NSString *eastday = @"http://mini.eastday.com";
    //滴滴
    NSString *diditaxi = @"https://common.diditaxi.com.cn/general/webEntry?wx=true&bizid=257&channel=70365#/";
    //火车票
    NSString *ctripFlight = @"https://m.ctrip.com/html5/Flight/swift/index";
    //旅游
    NSString *fliggy = @"https://www.fliggy.com/?ttid=sem.000000736&hlreferid=baidu.082076&route_source=seo";
    //快递
    NSString *postGood = @"http://www.kuaidi100.com";
    
    self.rowArr0 = [NSMutableArray arrayWithArray:@[
  @{@"id":@"4",@"url":@"",@"imgName":@"qiche",@"title":@"汽车"},
  @{@"id":@"6",@"url":@"",@"imgName":@"toutiao",@"title":@"头条"},
  @{@"id":@"7",@"url":@"",@"imgName":@"youbian",@"title":@"邮编查询"},
  @{@"id":@"9",@"url":@"",@"imgName":@"shoujihao",@"title":@"手机号归属"},
  @{@"id":@"10",@"url":@"",@"imgName":@"shenfenzheng",@"title":@"身份证查询"},
  @{@"id":@"11",@"url":@"",@"imgName":@"ip",@"title":@"IP查询"}]];

    self.rowArr1 = [NSMutableArray arrayWithArray:@[
  @{@"id":@"0",@"url":meituan,@"imgName":@"meishi",@"title":@"美团"},
  @{@"id":@"3",@"url":maoyan,@"imgName":@"dianying",@"title":@"电影"},
  @{@"id":@"1",@"url":diditaxi,@"imgName":@"didi",@"title":@"滴滴"},
  @{@"id":@"13",@"url":gongjiao,@"imgName":@"gongjiao",@"title":@"公交查询"},
  @{@"id":@"2",@"url":postGood,@"imgName":@"kuaidi",@"title":@"快递"},
  @{@"id":@"8",@"url":ctripFlight,@"imgName":@"huochepiao",@"title":@"火车票"},
  @{@"id":@"5",@"url":fliggy,@"imgName":@"lvyou",@"title":@"旅游"}]];
    
    [self layoutCollectionView];
    
}

- (void)layoutCollectionView
{
    //设置 cell
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置 cell item的大小
//    layout.itemSize = CGSizeMake(80, 80); //cell 的大小
    layout.itemSize = CGSizeMake((mz_width-50)/4, (mz_width-50)/4); //cell 的大小
    //设置item 左右最小距离
    layout.minimumInteritemSpacing = 10; //默认为10;
    //设置上下最小距离
    layout.minimumLineSpacing = 10; //默认为10;
    //设置 item 的范围
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10); //cell上下左右之间的距离
    //设置滑动的方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:mz_frame(0, 0, mz_width, mz_height) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    //注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"HeaderCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HeaderCollectionViewCell"];
    //注册头部
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    
    //添加到父视图
    [self.view addSubview:self.collectionView];
    
}

#pragma mark - DataSource  Delegate
//分区
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _section;
}

//设置每一个分区的item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (0 == section) {
        return [self.rowArr0 count];
    }else if (1 == section) {
        return [self.rowArr1 count];
    }
    return 0;
}

//cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //从重用队列中去取
    HeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HeaderCollectionViewCell" forIndexPath:indexPath];
    if (0 == indexPath.section) {
        cell.imgName.image = [UIImage imageNamed:self.rowArr0[indexPath.row][@"imgName"]];
        cell.title.text = self.rowArr0[indexPath.row][@"title"];
    }else if (1 == indexPath.section) {
        cell.imgName.image = [UIImage imageNamed:self.rowArr1[indexPath.row][@"imgName"]];
        cell.title.text = self.rowArr1[indexPath.row][@"title"];
    }
    return cell;
}

#pragma mark - 头部视图大小
//第二步
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size;
    if (section == 0) {
        size = CGSizeMake(mz_width, headScrollHeight+10);
    }else {
        size = CGSizeMake(mz_width, scrollHeight+10);
    }
    return size;
}

#pragma mark - 头部视图内容
//第三步
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = [[UICollectionReusableView alloc] init];
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = (UICollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            UIView *headView = [[UIView alloc]init];
            headView.frame = CGRectMake(0, 0, mz_width, headScrollHeight);
            [self addSdCycleScrollView:headView];
            [headerView addSubview:headView];
        }else if (indexPath.section == 1) {
            UIView *headView = [[UIView alloc]init];
            headView.frame = CGRectMake(0, 0, mz_width, scrollHeight);
            headView.backgroundColor = mz_color(235, 235, 241);
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, headView.frame.size.width, headView.frame.size.height-20)];
            imgView.image = mz_image(@"carImage");
            [headView addSubview:imgView];
//            [self addSdCycleScrollView:headView];
            [headerView addSubview:headView];
            
        }
        reusableView = headerView;
    }
    return reusableView;
}

-(void)addSdCycleScrollView:(UIView *)view
{
    SDCycleScrollView *cycView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, view.frame.size.height) delegate:nil placeholderImage:nil];
    cycView.placeholderImage = [UIImage imageNamed:@"bg_baner"];
    cycView.imageURLStringsGroup = @[@"banar0",@"banar1",@"banar2",@"banar3"];
    cycView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    cycView.hidesForSinglePage = YES;
    cycView.autoScrollTimeInterval = 3.0;
    cycView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
    cycView.pageDotColor = [UIColor lightGrayColor];
    cycView.currentPageDotColor = mz_yiDongBlueColor;
    [view addSubview:cycView];
}

//点击cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WebViewController *vc = [[WebViewController alloc] init];
    vc.url = _urlStr;
    [self.navigationController pushViewController:vc animated:YES];
}



- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 10, mz_width, scrollHeight-20);
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.contentSize = CGSizeMake(mz_width, scrollHeight-20);
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
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
