//
//  LeftCell.m
//  PadEvaluate
//
//  Created by hzth-mac3 on 15/12/15.
//  Copyright © 2015年 hzth-mac3. All rights reserved.
//

#import "LeftCell.h"

@implementation LeftCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    float indentPoints = self.indentationLevel * self.indentationWidth;
    
    self.contentView.frame = CGRectMake(
                                        indentPoints,
                                        self.contentView.frame.origin.y,
                                        self.contentView.frame.size.width - indentPoints,
                                        self.contentView.frame.size.height
                                        );
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
