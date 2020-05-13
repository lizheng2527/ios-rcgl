//
//  EValueteViewController.h
//  PadEvaluate
//
//  Created by hzth-mac3 on 15/12/15.
//  Copyright © 2015年 hzth-mac3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeadCell.h"
#import "LifeCell.h"
#import "LeftCell.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "ClassModel.h"
@class YYTextView;



@interface EValueteController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scroolView;

@property (weak, nonatomic) IBOutlet UITableView *lifeTableView;
@property (weak, nonatomic) IBOutlet UITableView *deadTableView;
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;


@property (nonatomic, copy)__block NSString * personId;
@property (weak, nonatomic) IBOutlet UITextField *mainItem;
//@property (weak, nonatomic) IBOutlet YYTextView *recordd;
@property (weak, nonatomic) IBOutlet UITextView *recordd;
@property (weak, nonatomic) IBOutlet YYTextView *record;

@property (nonatomic, strong) NSMutableArray * classesCount;
@property (nonatomic, strong) NSMutableArray * personCunt;

- (IBAction)menuChoose:(id)sender;
- (IBAction)personChoose:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *menubtn;
@property (weak, nonatomic) IBOutlet UIButton *personBtn;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UIButton *typeLessonBtn;
@property (weak, nonatomic) IBOutlet UIButton *numLessonBtn;


@property (weak, nonatomic) IBOutlet UITextField *subjectTF;
@property (weak, nonatomic) IBOutlet UITextField *teacherFeatureTF;


@property (nonatomic, strong) ClassModel * model;

- (IBAction)beginMark:(id)sender;

@property (nonatomic, copy) NSString * evaluateItemId;
@property(nonatomic,copy)NSString *taskID;
@property (nonatomic, strong) NSMutableArray * evaluateTableArray;
@property (nonatomic, strong) NSMutableArray * evaluateLevelArray;

@property (nonatomic, strong) NSMutableArray * evaluateLevelArray2;

@property (nonatomic, strong) NSString * loginName;
@property (nonatomic, strong) NSString * passWord;


@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourLabel;

@property (weak, nonatomic) IBOutlet UIButton *clearButton;

@property(nonatomic,assign)BOOL shouldMutipleTap;
@property (weak, nonatomic) IBOutlet UILabel *chooseCountLabel;

@end
