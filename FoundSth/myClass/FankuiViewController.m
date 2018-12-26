//
//  FankuiViewController.m
//  FoundSth
//
//  Created by qbsqbq on 2018/12/26.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import "FankuiViewController.h"

@interface FankuiViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *tijiaoBtn;
@property (weak, nonatomic) IBOutlet UILabel *lablePlahoad;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation FankuiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"意见反馈";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)textViewDidChange:(UITextView *)textView{
    if ([textView.text length] == 0) {
        _lablePlahoad.text = @"请输入您的意见或反馈";

    }else{
        _lablePlahoad.text = @"";

    }
}
- (IBAction)tijaoAaction:(id)sender {
    
    if ([_textView.text length] > 0) {
        [MHProgressHUD showMsgWithoutView:@"提交成功，谢谢您的反馈"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }else{
        [MHProgressHUD showMsgWithoutView:@"请填写您的反馈"];

    }
  
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
   [self.view endEditing:YES];
}

@end
