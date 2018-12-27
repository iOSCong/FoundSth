//
//  InforDetailViewController.h
//  FoundSth
//
//  Created by MCEJ on 2018/12/26.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import "BaseTableViewController.h"

@interface InforDetailViewController : BaseTableViewController

@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (strong, nonatomic) IBOutlet UITableViewCell *detailCell;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (nonatomic,copy)NSString *imgUrl;
@property (nonatomic,copy)NSString *detailStr;

@end
