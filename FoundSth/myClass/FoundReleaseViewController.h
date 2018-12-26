//
//  FoundReleaseViewController.h
//  FoundSth
//
//  Created by MCEJ on 2018/12/22.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import "BaseTableViewController.h"

@protocol ReleaseDelegate <NSObject>

- (void)refreshTableView;

@end

@interface FoundReleaseViewController : BaseTableViewController

@property (strong, nonatomic) IBOutlet UITableViewCell *imgViewCell;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (nonatomic,copy)NSString *objectId;
@property (nonatomic,copy)NSString *titleStr;
@property (nonatomic,strong)UIImage *contentImg;
@property (nonatomic,copy)NSString *detailStr;
@property (nonatomic,assign)int tag;

@property(nonatomic,weak)id<ReleaseDelegate>delegate;

@end
