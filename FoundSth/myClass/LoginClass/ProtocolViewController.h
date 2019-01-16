//
//  ProtocolViewController.h
//  FoundSth
//
//  Created by MCEJ on 2019/1/12.
//  Copyright © 2019年 MCEJ. All rights reserved.
//

#import "BaseTableViewController.h"

@interface ProtocolViewController : BaseTableViewController
@property (strong, nonatomic) IBOutlet UITableViewCell *detailCell;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (nonatomic,assign)BOOL isShow;

@end
