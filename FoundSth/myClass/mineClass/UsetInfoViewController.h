//
//  UsetInfoViewController.h
//  FoundSth
//
//  Created by qbsqbq on 2018/12/23.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import "BaseTableViewController.h"

@interface UsetInfoViewController : BaseTableViewController

@property (nonatomic,assign)int type;
@property (nonatomic,copy)NSString *headUrl;
@property (nonatomic,copy)NSString *sexStr;
@property (nonatomic,copy)NSString *aliasName;
@property (nonatomic,copy)NSString *signStr;

@property (nonatomic,strong)AVUser *owner;

@end
