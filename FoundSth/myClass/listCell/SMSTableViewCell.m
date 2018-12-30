//
//  SMSTableViewCell.m
//  HZMHIOS
//
//  Created by MCEJ on 2018/7/18.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import "SMSTableViewCell.h"

@implementation SMSTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.smsTextF.keyboardType = UIKeyboardTypeNumberPad;
    self.smsTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIView *dismissView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mz_width, keyboardInputViewH)];
    dismissView.backgroundColor = mz_upkeyboardViewColor;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(mz_width-50, 0, 40, keyboardInputViewH)];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    button.titleLabel.font = mz_font(15);
    [button setTitleColor:mz_upkeyboardDoneColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [dismissView addSubview:button];
    self.smsTextF.inputAccessoryView = dismissView;
    
}

- (void)dismissButtonAction
{
    [self.smsTextF resignFirstResponder];
}

- (void)clickSmsButton
{
    self.smsBtn.enabled = NO;
    self.second = 60;  //倒计时
    self.smsTimer=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countTimeAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.smsTimer forMode:NSDefaultRunLoopMode];
}

- (void)countTimeAction
{
    self.second--;
    [self.smsBtn setTitle:mz_NSTstring(@"%ds", self.second) forState:UIControlStateNormal];
    if (self.second < 1) {
        [self.smsBtn setTitle:@"获取" forState:UIControlStateNormal];
        [self.smsTimer invalidate];
        self.smsBtn.enabled = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
