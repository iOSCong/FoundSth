//
//  FoundReleaseViewController.m
//  FoundSth
//
//  Created by MCEJ on 2018/12/22.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import "FoundReleaseViewController.h"
#import "ZLPhotoActionSheet.h"
#import "ZLDefine.h"

@interface FoundReleaseViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) NSArray<ZLSelectPhotoModel *> *lastSelectMoldels;
@property (nonatomic,strong) UIImagePickerController *imagePicker;
@property (nonatomic,strong) NSData * imageData;

@end

@implementation FoundReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = self.tag ? @"详情":@"发布";
    
    self.tableView.hidden = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionHeaderHeight = 1.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, mz_width, 60)];
    UIButton *button = [UIButton footerButton:@"发布"];
    mzWeakSelf(self);
    [button addTarget:^(UIButton *button) {
        [weakself requestData];
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
        return 220;
    }
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        self.imgView.image = self.contentImg ? self.contentImg : [UIImage imageNamed:@"newsPicture"];
        self.imgViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.imgViewCell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
            
            UITextField *textField = [[UITextField alloc] initWithFrame:mz_frame(20, 0, mz_width-40, 44)];
            textField.placeholder = @"请输入标题";
            textField.returnKeyType = UIReturnKeyDone;
            textField.delegate = self;
            textField.hidden = YES;
            textField.tag = 2000;
            [cell addSubview:textField];
            
            UITextView *textView = [[UITextView alloc] initWithFrame:mz_frame(20, 10, mz_width-40, 160-20)];
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

- (void)textViewDidChange:(UITextView *)textView
{
    self.detailStr = textView.text;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
        //设置照片最大选择数
        actionSheet.maxSelectCount = 1;
        //设置照片最大预览数
        actionSheet.maxPreviewCount = 50;
        [actionSheet showPreviewPhotoWithSender:self animate:YES lastSelectPhotoModels:self.lastSelectMoldels completion:^(NSArray<UIImage *> * _Nonnull selectPhotos, NSArray<ZLSelectPhotoModel *> * _Nonnull selectPhotoModels) {
            self.imgView.image = selectPhotos[0];
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
    
    AVUser *currentUser = [AVUser currentUser];
    [product setObject:currentUser forKey:@"owner"];
    
    NSData * imageData;
    if (UIImagePNGRepresentation(self.imgView.image)) {
        imageData = UIImagePNGRepresentation(self.imgView.image);
    }else{
        imageData = UIImageJPEGRepresentation(self.imgView.image, 1.0);
    }
    AVFile *file = [AVFile fileWithData:imageData];
    [product setObject:file forKey:@"image"];
    [MHProgressHUD showProgress:tips inView:self.view];
    [product saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MHProgressHUD hide];
        if (succeeded) {
            NSLog(@"保存新物品成功");
            if (self.tag) {
                [MHProgressHUD showMsgWithoutView:@"更新成功"];
            }else{
                [MHProgressHUD showMsgWithoutView:@"发布成功"];
            }
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"保存新物品出错 %@", error.localizedFailureReason);
            [MHProgressHUD showMsgWithoutView:error.localizedFailureReason];
        }
    }];
}

- (void)updateObject
{
    // 第一个参数是 className，第二个参数是 objectId
    AVObject *todo =[AVObject objectWithClassName:@"homeList" objectId:self.objectId];
    // 修改属性
    [todo setObject:@"每周工程师会议，本周改为周三下午3点半。" forKey:@"content"];
    // 保存到云端
    [todo saveInBackground];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}



/*
 // 执行 CQL 语句实现删除一个 Todo 对象
 [AVQuery doCloudQueryInBackgroundWithCQL:@"delete from Todo where objectId='558e20cbe4b060308e3eb36c'" callback:^(AVCloudQueryResult *result, NSError *error) {
 // 如果 error 为空，说明保存成功
 }];
 */






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
