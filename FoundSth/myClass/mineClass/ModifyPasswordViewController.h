//
//  ModifyPasswordViewController.h
//  HZMHIOS
//
//  Created by MCEJ on 2018/7/24.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import "BaseTableViewController.h"

@interface ModifyPasswordViewController : BaseTableViewController
@property (strong, nonatomic) IBOutlet UITableViewCell *onePassCell;
@property (weak, nonatomic) IBOutlet UITextField *onePassTextF;

@property (strong, nonatomic) IBOutlet UITableViewCell *surePassCell;
@property (weak, nonatomic) IBOutlet UITextField *surePassTextF;

@end
