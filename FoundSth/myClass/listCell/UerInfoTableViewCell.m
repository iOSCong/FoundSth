//
//  UerInfoTableViewCell.m
//  FoundSth
//
//  Created by qbsqbq on 2018/12/23.
//  Copyright © 2018年 MCEJ. All rights reserved.
//

#import "UerInfoTableViewCell.h"

@implementation UerInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _iamgeBGveiw.backgroundColor = mz_yiDongBlueColor;
    _icon_imageView.layer.cornerRadius = 45;
    _icon_imageView.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
