//
//  DropDownMenu.h
//  PadEvaluate
//
//  Created by hzth-mac3 on 15/12/17.
//  Copyright © 2015年 hzth-mac3. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DropDownMenu;

@protocol DropDownMwnuDelegate <NSObject>
// 设置可选的代理方法
@optional
- (void)dropdownMenuDidDismiss:(DropDownMenu *)menu;

- (void)dropdownMenuDidShow:(DropDownMenu *)menu;

@end

@interface DropDownMenu : UIView

@property (nonatomic, weak) id<DropDownMwnuDelegate> delegate;
// 显示
- (void)showFrom:(UIView *)from;
// 销毁
- (void)disMiss;

// 内容
@property (nonatomic, strong) UIView * content;
// 内容控制器
@property (nonatomic, strong) UIViewController * contentController;

@end
