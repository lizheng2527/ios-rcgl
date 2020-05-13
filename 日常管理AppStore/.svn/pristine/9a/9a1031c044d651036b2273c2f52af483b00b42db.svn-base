//
//  SecondDropMenu.m
//  PadEvaluate
//
//  Created by hzth-mac3 on 15/12/21.
//  Copyright © 2015年 hzth-mac3. All rights reserved.
//

#import "SecondDropMenu.h"
#import "UIView+frame.h"

@interface SecondDropMenu()
@property (nonatomic, weak) UIImageView * containerView;
@end

@implementation SecondDropMenu

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //
        self.backgroundColor = [UIColor clearColor];
        // 添加一个控件
        UIImageView *containerView = [[UIImageView alloc] init];
        containerView.userInteractionEnabled = YES; // 开启交互
        [self addSubview:containerView];
        self.containerView = containerView;
        
    }
    return self;
}

- (void)setContent:(UIView *)content
{
    _content = content;
    
    // 调整内容的位置
    content.x = 10;
    content.y = 0;
    
    // 设置背景的高度
    self.containerView.height = CGRectGetMaxY(content.frame)  ;
    // 设置背景的宽度
    self.containerView.width = CGRectGetMaxX(content.frame) + 15;
    
    // 添加内容到背景颜色中
    [self.containerView addSubview:content];
}

- (void)setContentController:(UIViewController *)contentController
{
    _contentController = contentController;
    
    self.content = contentController.view;
}
/**
 *  显示
 */
- (void)showfroms:(UIView *)from
{
    // 1.获得最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    
    // 2.添加自己到窗口上
    [window addSubview:self];
    
    // 3.设置尺寸
    self.frame = window.bounds;
    
    // 4.调整背景的位置
    // 默认情况下，frame是以父控件左上角为坐标原点
    // 转换坐标系
    CGRect newFrame = [from convertRect:from.bounds toView:window];
    //    CGRect newFrame = [from.superview convertRect:from.frame toView:window];
    self.containerView.centerX = CGRectGetMidX(newFrame);
    self.containerView.y = CGRectGetMaxY(newFrame);
    
    // 通知外界，自己显示了
    if ([self.delegate respondsToSelector:@selector(dropdownPersonMenuDidShow:)]) {
        [self.delegate dropdownPersonMenuDidShow:self];
    }
}

/**
 *  销毁
 */
- (void)disunclear
{
    [self removeFromSuperview];
    // 通知外界，自己被销毁了
    if ([self.delegate respondsToSelector:@selector(dropdownPersonMenuDidDismiss:)]) {
        [self.delegate dropdownPersonMenuDidDismiss:self];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self disunclear];
}
@end
