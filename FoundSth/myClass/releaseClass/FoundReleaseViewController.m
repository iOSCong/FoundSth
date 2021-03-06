//
//  FoundReleaseViewController.m
//  FoundSth
//
//  Created by MCEJ on 2018/12/22.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import "FoundReleaseViewController.h"
#import "SensitiveWordTools.h"
#import "ZLPhotoActionSheet.h"
#import "ZLDefine.h"

@interface FoundReleaseViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) NSArray<ZLSelectPhotoModel *> *lastSelectMoldels;
@property (nonatomic,strong) UIImagePickerController *imagePicker;
@property (nonatomic,strong) NSData * imageData;

@end

@implementation FoundReleaseViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = self.tag ? @"详情":@"发布";
    
    self.tableView.hidden = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionHeaderHeight = 0.1f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = mz_tableHeaderView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, mz_width, 60)];
    UIButton *button = [UIButton footerButton:@"发布"];
    mzWeakSelf(self);
    [button addTarget:^(UIButton *button) {
        if (!weakself.titleStr) {
            [MHProgressHUD showMsgWithoutView:@"请输入标题"];
        }else if (!weakself.contentImg) {
            [MHProgressHUD showMsgWithoutView:@"请选择图片"];
        }else{
            //判断输入的内容是否含有敏感词
            BOOL hasSensitive = [[SensitiveWordTools sharedInstance] hasSensitiveWord:self.detailStr];
            if (hasSensitive) {
                self.detailStr = [[SensitiveWordTools sharedInstance] filter:self.detailStr];
                [self.tableView reloadData];
                [MZAlertSheet alertViewMessage:@"您的内容含有敏感词汇,已为您替换为 '*'"];
            }else{
                [weakself requestData];
            }
        }
    }];
    [footerView addSubview:button];
    self.tableView.tableFooterView = footerView;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44;
    }else if (indexPath.section == 1) {
        return 180;
    }
    return 100;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return @"详细说明";
    }else if (section == 1) {
        return @"上传图片";
    }else if (section == 2) {
        return @"根据<中国互联网保护法>,为保证网民的上网环境优良,请勿上传或发布违反互联网所不允许的内容,请悉知!";
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        self.imgView.image = self.contentImg ? self.contentImg : [UIImage imageNamed:@"newsPicture"];
        self.imgView.layer.borderWidth = 0.5f;
        self.imgView.layer.borderColor = [UIColor grayColor].CGColor;
        self.imgViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.imgViewCell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
            
            UITextField *textField = [[UITextField alloc] initWithFrame:mz_frame(20, 0, mz_width-40, 44)];
            textField.font = mz_font(15);
            textField.placeholder = @"请输入标题";
            textField.returnKeyType = UIReturnKeyDone;
            textField.delegate = self;
            textField.hidden = YES;
            textField.tag = 2000;
            [cell addSubview:textField];
            
            UITextView *textView = [[UITextView alloc] initWithFrame:mz_frame(20, 10, mz_width-40, 180-20)];
            textView.font = mz_font(15);
            textView.delegate = self;
            textView.hidden = YES;
            textView.tag = 2002;
            [cell addSubview:textView];
            
        }
        UITextField *textField = (UITextField *)[cell viewWithTag:2000];
        textField.text = self.titleStr;
        UITextView *textView = (UITextView *)[cell viewWithTag:2002];
        textView.text = self.detailStr;
        if (indexPath.section == 0) {
            textField.hidden = NO;
            mzWeakSelf(self);
            [textField addAction:^(UITextField *textField) {
                weakself.titleStr = textField.text;
            }];
        }else{
            textView.hidden = NO;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    //判断输入的内容是否含有敏感词
    BOOL hasSensitive = [[SensitiveWordTools sharedInstance] hasSensitiveWord:textField.text];
    if (hasSensitive) {
        self.titleStr = [[SensitiveWordTools sharedInstance] filter:textField.text];
        [MZAlertSheet presentAlertViewWithMessage:@"您的标题含有敏感词汇,请检查!" confirmTitle:@"好的" handler:^{
            [textField becomeFirstResponder];
        }];
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.detailStr = textView.text;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
        //设置照片最大选择数
        actionSheet.maxSelectCount = 1;
        //设置照片最大预览数
        actionSheet.maxPreviewCount = 50;
        [actionSheet showPreviewPhotoWithSender:self animate:YES lastSelectPhotoModels:self.lastSelectMoldels completion:^(NSArray<UIImage *> * _Nonnull selectPhotos, NSArray<ZLSelectPhotoModel *> * _Nonnull selectPhotoModels) {
            self.contentImg = selectPhotos[0];
            self.imgView.image = self.contentImg;
        }];
    }
}


- (void)requestData
{
    AVObject *product;
    NSString *tips = @"";
    if (self.tag) {
        product =[AVObject objectWithClassName:@"homeList" objectId:self.objectId];
        tips = @"正在更新...";
    }else{
        product = [AVObject objectWithClassName:@"homeList"];
        tips = @"正在发布...";
    }
    [product setObject:self.titleStr forKey:@"title"];
    [product setObject:self.detailStr forKey:@"detail"];
    [product setObject:@0 forKey:@"dianzan"];
    [product setObject:[NSStrObject getUserInfoWith:@"objectId"] forKey:@"ownerId"];
    
    AVUser *currentUser = [AVUser currentUser];
    [product setObject:currentUser forKey:@"owner"];
    
    NSData * imageData;
    if (UIImagePNGRepresentation(self.contentImg)) {
        imageData = UIImagePNGRepresentation(self.contentImg);
    }else{
        imageData = UIImageJPEGRepresentation(self.contentImg, 1.0);
    }
    AVFile *file = [AVFile fileWithData:imageData];
    [product setObject:file forKey:@"image"];
    [MHProgressHUD showProgress:tips inView:self.view];
    [product saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MHProgressHUD hide];
        if (succeeded) {
            NSLog(@"保存新物品成功");
            if (self.tag) {
                [MHProgressHUD showMsgWithoutView:@"更新成功，24小时内审核若有违规行为，将被删除"];
            }else{
                [MHProgressHUD showMsgWithoutView:@"发布成功，24小时内审核若有违规行为，将被删除"];
            }
            
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"loginView" object:nil userInfo:@{@"tag":@"1"}]];
            
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"保存新物品出错 %@", error.localizedFailureReason);
            [MHProgressHUD showMsgWithoutView:@"发布失败"];
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


-(void)dealloc{
    NSLog(@"移除了所有的通知");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
