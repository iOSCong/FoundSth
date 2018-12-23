//
//  EidetViewController.m
//  FoundSth
//
//  Created by qbsqbq on 2018/12/24.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import "EidetViewController.h"

@interface EidetViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textFiled;

@end

@implementation EidetViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = _title_na;
    _textFiled.text = _userName;
    [_textFiled becomeFirstResponder];
}



@end
