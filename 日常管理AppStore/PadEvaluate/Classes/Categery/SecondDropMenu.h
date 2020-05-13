//
//  SecondDropMenu.h
//  PadEvaluate
//
//  Created by hzth-mac3 on 15/12/21.
//  Copyright © 2015年 hzth-mac3. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SecondDropMenu;
@protocol SecondDropMenuDelegate <NSObject>
// 设置可选的代理方法
@optional

- (void)dropdownPersonMenuDidDismiss:(SecondDropMenu *)menu;

- (void)dropdownPersonMenuDidShow:(SecondDropMenu *)menu;
@end

@interface SecondDropMenu : UIView

@property (nonatomic, weak) id<SecondDropMenuDelegate> delegate;
// 显示
- (void)showfroms:(UIView *)from;
// 销毁
- (void)disunclear;

// 内容
@property (nonatomic, strong) UIView * content;
// 内容控制器
@property (nonatomic, strong) UIViewController * contentController;
@end
