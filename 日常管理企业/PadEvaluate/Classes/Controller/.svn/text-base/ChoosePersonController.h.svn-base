//
//  ChoosePersonController.h
//  PadEvaluate
//
//  Created by hzth-mac3 on 15/12/18.
//  Copyright © 2015年 hzth-mac3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+frame.h"
@class SecondDropMenu;
@class PersonModel;
@protocol PersonMenuDelegate <NSObject>

@required
- (void)selectPersonAtIndexPath:(NSIndexPath *)indexPath title:(NSString*)title;
- (void)getDataArrayPersonCount:(NSMutableArray *)array;
@end

@interface ChoosePersonController : UITableViewController

@property (nonatomic, weak) id<PersonMenuDelegate> delegate;

@property (nonatomic, weak) SecondDropMenu * drops;

@property (nonatomic, strong) NSMutableArray * personData;
@property (nonatomic, copy) NSString * ID;
@property (nonatomic, strong) NSString * loginName;
@property (nonatomic, strong) NSString * passWord;
@end
