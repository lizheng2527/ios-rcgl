//
//  ChooseClassCotroller.h
//  PadEvaluate
//
//  Created by hzth-mac3 on 15/12/17.
//  Copyright © 2015年 hzth-mac3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+frame.h"
@class DropDownMenu;
@class ClassModel;

@protocol ClassMenuDelegate <NSObject>

@required
- (void)selectAtIndexPath:(NSIndexPath *)indexPath title:(NSString*)title;
- (void)getDataArrayCount:(NSMutableArray *)array;


@end

@interface ChooseClassCotroller : UITableViewController


@property (nonatomic, weak) id<ClassMenuDelegate> delegate;

@property (nonatomic, weak) DropDownMenu * drop;
@property (nonatomic, strong) NSMutableArray * classData;

@property (nonatomic, strong) NSString * loginName;
@property (nonatomic, strong) NSString * passWord;
@end
