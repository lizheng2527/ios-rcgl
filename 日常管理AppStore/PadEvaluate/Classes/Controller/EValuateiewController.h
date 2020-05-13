//
//  EValuateiewController.h
//  PadEvaluate
//
//  Created by hzth-mac3 on 15/12/15.
//  Copyright © 2015年 hzth-mac3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondCell.h"
#import "EvaluateModel.h"


@interface EValuateiewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *newsTabelView;
@property (weak, nonatomic) IBOutlet UILabel *listCount;

@property (nonatomic,strong) EvaluateModel * model;

- (IBAction)evaluate:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *adminName;

- (IBAction)quitLogin:(id)sender;


@property (nonatomic, strong) NSString * loginName;
@property (nonatomic, strong) NSString * passWord;

@end
