//
//  LifeCell.m
//  PadEvaluate
//
//  Created by hzth-mac3 on 15/12/15.
//  Copyright © 2015年 hzth-mac3. All rights reserved.
//

#import "LifeCell.h"

@implementation LifeCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _one.layer.masksToBounds = YES;
    _one.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _one.layer.borderWidth = 0.5f;
    
    _two.layer.masksToBounds = YES;
    _two.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _two.layer.borderWidth = 0.5f;
    
    _three.layer.masksToBounds = YES;
    _three.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _three.layer.borderWidth = 0.5f;
    
    _fourBGView.layer.masksToBounds = YES;
    _fourBGView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _fourBGView.layer.borderWidth = 0.5f;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
