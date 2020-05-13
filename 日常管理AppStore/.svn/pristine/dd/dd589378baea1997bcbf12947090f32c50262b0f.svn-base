//
//  UIBarButtonItem+Extention.m
//  PadEvaluate
//
//  Created by hzth-mac3 on 15/12/16.
//  Copyright © 2015年 hzth-mac3. All rights reserved.
//

#import "UIBarButtonItem+Extention.h"
#import "UIView+frame.h"

@implementation UIBarButtonItem (Extention)

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    // 设置尺寸
    btn.size = btn.currentBackgroundImage.size;
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
@end
