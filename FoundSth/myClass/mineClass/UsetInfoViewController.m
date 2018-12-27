//
//  UsetInfoViewController.m
//  FoundSth
//
//  Created by qbsqbq on 2018/12/23.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import "UsetInfoViewController.h"
#import "IconTableViewCell.h"
#import "ZLPhotoActionSheet.h"

@interface UsetInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong)IconTableViewCell *headCell;

@end

@implementation UsetInfoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"个人信息";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.sectionFooterHeight = 0.1;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, mz_width, 60)];
    UIButton *button = [UIButton footerButton:@"提交"];
    mzWeakSelf(self);
    [button addTarget:^(UIButton *button) {
        [weakself settingSelfInformation];
    }];
    [footerView addSubview:button];
    self.tableView.tableFooterView = footerView;
    
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
        self.headCell = [[[NSBundle mainBundle]loadNibNamed:@"IconTableViewCell" owner:self options:nil] lastObject];
        [self.headCell.headImgView sd_setImageWithURL:[NSURL URLWithString:self.headUrl] placeholderImage:[UIImage imageNamed:@"headlogo"]];
        self.headCell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.headCell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        return self.headCell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"icon"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"icon"];
            
            UITextField *textField1 = [[UITextField alloc] initWithFrame:mz_frame(100, 0, mz_width-100-15, 50)];
            textField1.placeholder = @"请输入标题";
            textField1.font = mz_font(15);
            textField1.placeholder = @"为自己设置一个响亮的昵称吧~";
            textField1.textAlignment = NSTextAlignmentRight;
            textField1.returnKeyType = UIReturnKeyDone;
            textField1.delegate = self;
            textField1.hidden = YES;
            textField1.tag = 2001;
            [cell addSubview:textField1];
            
            UITextField *textField2 = [[UITextField alloc] initWithFrame:mz_frame(100, 0, mz_width-100-15, 50)];
            textField2.placeholder = @"请输入标题";
            textField2.font = mz_font(15);
            textField2.placeholder = @"为自己设置一个有个性的签名吧~";
            textField2.textAlignment = NSTextAlignmentRight;
            textField2.returnKeyType = UIReturnKeyDone;
            textField2.delegate = self;
            textField2.hidden = YES;
            textField2.tag = 2002;
            [cell addSubview:textField2];
            
        }
        UITextField *textField1 = (UITextField *)[cell viewWithTag:2001];
        UITextField *textField2 = (UITextField *)[cell viewWithTag:2002];
        if (indexPath.row == 1) {
            cell.textLabel.text = @"昵称";
            textField1.hidden = NO;
            textField1.text = self.aliasName;
        }else{
            cell.textLabel.text = @"个性签名";
            textField2.hidden = NO;
            textField2.text = self.signStr;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        mzWeakSelf(self);
        [textField1 addAction:^(UITextField *textField) {
            weakself.aliasName = textField.text;
        }];
        [textField2 addAction:^(UITextField *textField) {
            weakself.signStr = textField.text;
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self.view endEditing:YES];
        ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
        //设置照片最大选择数
        actionSheet.maxSelectCount = 1;
        //设置照片最大预览数
        actionSheet.maxPreviewCount = 50;
        [actionSheet showPreviewPhotoWithSender:self animate:YES lastSelectPhotoModels:nil completion:^(NSArray<UIImage *> * _Nonnull selectPhotos, NSArray<ZLSelectPhotoModel *> * _Nonnull selectPhotoModels) {
            self.headCell.headImgView.image = selectPhotos[0];
        }];
        return;
    }
}

- (void)settingSelfInformation
{
    NSData * imageData = UIImagePNGRepresentation(self.headCell.headImgView.image);
    AVUser *currentuser = [AVUser currentUser];
    AVFile *avatarFile = [AVFile fileWithData:imageData];
    [currentuser setObject:avatarFile forKey:@"avatar"];
    [currentuser setObject:self.aliasName forKey:@"alias"];
    [currentuser setObject:self.signStr forKey:@"sign"];
    [MHProgressHUD showProgress:@"正在提交..." inView:self.view];
    [currentuser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [MHProgressHUD hide];
        if (succeeded) {
            [MHProgressHUD showMsgWithoutView:@"提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"上传出错 %@", error.localizedFailureReason);
            [MHProgressHUD showMsgWithoutView:error.localizedFailureReason];
        }
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}


@end