//
//  HomeViewController.h
//  HZMHIOS
//
//  Created by MCEJ on 2018/7/17.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "HeaderCollectionViewCell.h"

@interface WebHomeViewController : BaseViewController

@property (nonatomic,assign)int section;
@property (nonatomic,copy)NSString *urlStr;

@end
