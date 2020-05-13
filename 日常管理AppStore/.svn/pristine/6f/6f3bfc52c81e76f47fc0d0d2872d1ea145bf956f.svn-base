//
//  IndicatorView.m
//  PadEvaluate
//
//  Created by hzth-mac3 on 15/12/16.
//  Copyright © 2015年 hzth-mac3. All rights reserved.
//

#import "IndicatorView.h"

@implementation IndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicator.frame = CGRectMake(0, 0, 100, 100);
        //设置显示位置
        [_indicator setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)];
        
        //设置背景色
        _indicator.backgroundColor = [UIColor grayColor];
        
        //设置背景透明
        _indicator.alpha = 0.5;
        
        //设置背景为圆角矩形
        _indicator.layer.cornerRadius = 6;
        _indicator.layer.masksToBounds = YES;
        [self addSubview:_indicator];
    }
    return self;
}

- (void)showInWindow:(UIWindow *)window
{
    if ([[window subviews] indexOfObject:self] != NSNotFound)
    {
        [window bringSubviewToFront:self];
    }else
    {
        [window addSubview:self];
        [window bringSubviewToFront:self];
    }
    [_indicator startAnimating];
    //不允许用户输入
    window.userInteractionEnabled = NO;
}

- (void)hideInWindow:(UIWindow *)window
{
    [_indicator stopAnimating];
    if ([[window subviews] indexOfObject:self] != NSNotFound)
    {
        [self removeFromSuperview];
    }
    //允许用户输入
    window.userInteractionEnabled = YES;
}

@end
