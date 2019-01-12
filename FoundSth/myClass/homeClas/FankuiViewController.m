//
//  FankuiViewController.m
//  FoundSth
//
//  Created by qbsqbq on 2018/12/26.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import "FankuiViewController.h"
#import "ZLPhotoActionSheet.h"

@interface FankuiViewController ()<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *tijiaoBtn;
@property (weak, nonatomic) IBOutlet UILabel *lablePlahoad;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *phoneLabel;

@property (nonatomic, strong) NSArray<ZLSelectPhotoModel *> *lastSelectMoldels;
@property (nonatomic,strong) UIImagePickerController *imagePicker;
@property (nonatomic,strong) NSData * imageData;
@property (nonatomic,strong)UIImage *contentImg;

@end

@implementation FankuiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.phoneLabel.text = @"";
    self.textView.text = @"";
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.autoresizesSubviews = YES;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle)];
    [self.imageView addGestureRecognizer:tap];
    
}

- (void)tapHandle
{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    //设置照片最大选择数
    actionSheet.maxSelectCount = 1;
    //设置照片最大预览数
    actionSheet.maxPreviewCount = 50;
    [actionSheet showPreviewPhotoWithSender:self animate:YES lastSelectPhotoModels:self.lastSelectMoldels completion:^(NSArray<UIImage *> * _Nonnull selectPhotos, NSArray<ZLSelectPhotoModel *> * _Nonnull selectPhotoModels) {
        self.contentImg = selectPhotos[0];
        self.imageView.image = self.contentImg;
    }];
}

- (void)requestData
{
    AVObject *product = [AVObject objectWithClassName:@"tipoffList"];
    [product setObject:self.phoneLabel.text forKey:@"phone"];
    [product setObject:self.textView.text forKey:@"tipContent"];
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
    [MHProgressHUD showProgress:@"正在提交..." inView:self.view];
    [product saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MHProgressHUD hide];
        if (succeeded) {
            [MHProgressHUD showMsgWithoutView:@"举报成功,平台工作人员将会在24小时之内给出回复!"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"保存新物品出错 %@", error.localizedFailureReason);
            [MHProgressHUD showMsgWithoutView:@"举报失败,请稍后再试..."];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)textViewDidChange:(UITextView *)textView{
    if ([textView.text length] == 0) {
        _lablePlahoad.text = @"请输入您的举报内容";
    }else{
        _lablePlahoad.text = @"";
    }
}

- (IBAction)tijaoAaction:(id)sender
{
    if ([self.textView.text isEqualToString:@""]) {
        [MHProgressHUD showMsgWithoutView:@"请输入举报内容"];
    }else if ([self.phoneLabel.text isEqualToString:@""]) {
        [MHProgressHUD showMsgWithoutView:@"请输入手机号码"];
    }else{
        [self requestData];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
   [self.view endEditing:YES];
}

@end
