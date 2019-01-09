//
//  FoundDetailViewController.h
//  FoundSth
//
//  Created by MCEJ on 2019/1/9.
//  Copyright © 2019年 MCEJ. All rights reserved.
//

#import "BaseTableViewController.h"

@interface FoundDetailViewController : BaseTableViewController

@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (strong, nonatomic) IBOutlet UITableViewCell *detailCell;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (nonatomic,copy)NSString *imgUrl;
@property (nonatomic,copy)NSString *detailStr;

@end
