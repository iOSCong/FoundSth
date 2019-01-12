//
//  ProtocolViewController.m
//  FoundSth
//
//  Created by MCEJ on 2019/1/12.
//  Copyright © 2019年 MCEJ. All rights reserved.
//

#import "ProtocolViewController.h"

@interface ProtocolViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation ProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.hidden = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionHeaderHeight = 1.0f;
    self.tableView.estimatedRowHeight = 100; //随便设个不那么离谱的值
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(mz_width/2-100/2, 20, 100, 40)];
    titleL.text = @"隐私协议";
    titleL.textColor = [UIColor whiteColor];
    titleL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleL];
    
    if (!_isShow) {
        //取消
        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(mz_width-60, 20, 60, 40)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = mz_font(15);
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:cancelBtn];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.detailLabel.text = @"<Help me find it>App用户使用及隐私协议\n\n加入和使用此App(Help me find it, 下同)表明您已经阅读并同意本使用条款，您的会员活动会遵从本使用条款。鉴于对此App的使用并非是关乎国计民生或者垄断的行业及企业，因此您对本使用协议不认同的，完全可以选择不加入和使用。\n\n协议内容及签署\n\n1、本协议内容包括协议正文及所有已经发布的或将来可能发布的各类规则。所有规则为本协议不可分割的组成部分，与协议正文具有同等法律效力。除另行明确声明外，任何提供的服务均受本协议约束。\n\n2、您在注册此App账户时点击提交“我已阅读并同意隐私协议!”即视为您接受本协议及各类规则，并同意受其约束。您应当在使用此App服务之前认真阅读全部协议内容并确保完全理解协议内容，如您对协议有任何疑问的，应向本公司咨询。但无论您事实上是否在使用此App服务之前认真阅读了本协议内容，只要您注册、正在或者继续使用此App的服务，则视为您接受本协议。\n\n3、您承诺接受并遵守本协议的约定。如果您不同意本协议的约定，您应立即停止注册程序或停止使用此App的服务。\n\n4、我们有权根据需要不时地制订、修改本协议及/或各类规则，并以网站公示的方式进行公告。变更后的协议和规则一经在网站公布后，立即自动生效。我们的最新的协议和规则以及网站公告可供您随时登陆查阅，您也应当经常性的登陆查阅最新的协议和规则以及网站公告以了解我们的最新动态。如您不同意相关变更，应当立即停止使用返利网服务。您继续使用服务的，即表示您接受经修订的协议和规则。本协议和规则（及其各自的不时修订）条款具有可分割性，任一条款被视为违法、无效、被撤销、变更或因任何理由不可执行，并不影响其他条款的合法性、有效性和可执行性。\n\n特此声明: 最终解释权归我公司所有。\n";
    return self.detailCell;
}



- (void)cancelAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
