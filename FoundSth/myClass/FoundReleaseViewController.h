//
//  FoundReleaseViewController.h
//  FoundSth
//
//  Created by MCEJ on 2018/12/22.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import "BaseTableViewController.h"

@interface FoundReleaseViewController : BaseTableViewController
@property (strong, nonatomic) IBOutlet UITableViewCell *imgViewCell;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (nonatomic,copy)NSString *objectId;
@property (nonatomic,copy)NSString *titleStr;
@property (nonatomic,strong)UIImage *contentImg;
@property (nonatomic,copy)NSString *detailStr;
@property (nonatomic,assign)int tag;

@end
