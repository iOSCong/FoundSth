//
//  SMSTableViewCell.h
//  HZMHIOS
//
//  Created by MCEJ on 2018/7/18.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *smsTextF;
@property (weak, nonatomic) IBOutlet UIButton *smsBtn;

@property (nonatomic,strong)NSTimer *smsTimer;
@property (nonatomic,assign)int second;

//点击获取验证码
- (void)clickSmsButton;

@end
