//
//  ModifyPasswordViewController.m
//  HZMHIOS
//
//  Created by MCEJ on 2018/7/24.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "SMSTableViewCell.h"

@interface ModifyPasswordViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong)UITextField *smsTextF;
@property (nonatomic,strong)NSString *mobile;

@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"重置密码";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SMSTableViewCell" bundle:nil] forCellReuseIdentifier:@"SMSTableViewCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.hidden = NO;
    
    self.tableView.sectionHeaderHeight  = 1.0; //分区间隔
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, mz_height-50, mz_width, 50)];
    footerView.backgroundColor = mz_tableViewBackColor;
    UIButton *button = [UIButton footerButton:@"确认"];
    [button addTarget:^(UIButton *button) {
        if ([self.onePassTextF.text isEqualToString:@""] || [self.surePassTextF.text isEqualToString:@""]) {
            [MHProgressHUD showMsgWithoutView:@"密码不能为空"];
        }else if (![self.onePassTextF.text isEqualToString:self.surePassTextF.text]) {
            [MHProgressHUD showMsgWithoutView:@"两次密码输入不相同"];
        }else if ([self.smsTextF.text isEqualToString:@""]) {
            [MHProgressHUD showMsgWithoutView:@"短信验证码不能为空"];
        }else{
            [self requestModify];
        }
    }];
    [footerView addSubview:button];
    self.tableView.tableFooterView = footerView;
    
    //获取手机号码
    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query getObjectInBackgroundWithId:[NSStrObject getUserInfoWith:@"objectId"] block:^(AVObject *object, NSError *error) {
        if (!error) {
            self.mobile = [object objectForKey:@"mobilePhoneNumber"];
            NSLog(@"mobile==%@",self.mobile);
            [self.tableView reloadData];
        }
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        NSString *str1 = [self.mobile substringToIndex:3];
        NSString *str2 = [self.mobile substringFromIndex:self.mobile.length-4];
        return [NSString stringWithFormat:@"如重置密码我们将向您%@****%@的手机号发送一条验证短信,请注意查收",str1,str2];
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.onePassTextF.delegate = self;
            self.onePassTextF.placeholder = @"请输入新密码";
            self.onePassTextF.secureTextEntry = YES;
            self.onePassTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
            [self.onePassTextF resignFirstResponderWhenEndEditing];
            return self.onePassCell;
        }else{
            self.surePassTextF.delegate = self;
            self.surePassTextF.placeholder = @"请再次输入密码";
            self.surePassTextF.secureTextEntry = YES;
            self.surePassTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
            [self.surePassTextF resignFirstResponderWhenEndEditing];
            return self.surePassCell;
        }
    }else{
        SMSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SMSTableViewCell"];
        cell.smsTextF.delegate = self;
        cell.smsTextF.keyboardType = UIKeyboardTypeNumberPad;
        self.smsTextF = cell.smsTextF;
        [cell.smsBtn addTarget:^(UIButton *button) {
            [self request_sms:cell];
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.smsTextF) {
        self.smsTextF.text = textField.text;
    }
}

- (void)request_sms:(SMSTableViewCell *)cell
{
    [AVUser requestPasswordResetWithPhoneNumber:self.mobile block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [cell clickSmsButton];
            [MHProgressHUD showMsgWithoutView:@"短信验证码已发送"];
        } else {
            [MHProgressHUD showMsgWithoutView:@"短信验证码发送失败"];
        }
    }];
}

- (void)requestModify
{
    [AVUser resetPasswordWithSmsCode:self.smsTextF.text newPassword:self.surePassTextF.text block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self.navigationController popViewControllerAnimated:YES];
            [MHProgressHUD showMsgWithoutView:@"重置密码成功"];
        } else {
            [MHProgressHUD showMsgWithoutView:@"重置密码失败"];
        }
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.tableView endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield
{
    if (aTextfield == self.onePassTextF) {
        [self.surePassTextF becomeFirstResponder];
    }else {
        [aTextfield resignFirstResponder];//关闭键盘
    }
    return YES;
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
