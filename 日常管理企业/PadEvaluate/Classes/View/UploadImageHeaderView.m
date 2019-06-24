//
//  UploadImageHeaderView.m
//  PadEvaluate
//
//  Created by 中电和讯 on 2018/3/12.
//  Copyright © 2018年 hzth-mac3. All rights reserved.
//

#import "UploadImageHeaderView.h"

@implementation UploadImageHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
//        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 35)];
//        [self addSubview:bgView];
        
        
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, [[UIScreen mainScreen] bounds].size.width, 25)];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.titleLabel];
    }
    return self;
}

@end
