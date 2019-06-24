//
//  EValueteViewController.m
//  PadEvaluate
//
//  Created by hzth-mac3 on 15/12/15.
//  Copyright © 2015年 hzth-mac3. All rights reserved.
//

#import "EValueteController.h"
#import "UpScoreViewController.h"
#import "DropDownMenu.h"
#import "ChooseClassCotroller.h"
#import "ChoosePersonController.h"
#import "NewEvaluateModel.h"
#import "TYHHttpTool.h"
#import "Public.h"
#import "MJExtension.h"
#import "LifeModel.h"
#import "SubLifeModel.h"
#import "SecondDropMenu.h"
#import "PersonModel.h"
#import "MBProgressHUD.h"

#import "UIView+Toast.h"

#import "GYZCustomCalendarPickerView.h"
#import "DLPickerView.h"
#import "EvaluateModel.h"

#import "YYText.h"
#import "ETTextView.h"

#import "SDPhotoBrowser.h"

#define OwnerSeparator      @"  -  "


#define WORD_LIMIT 3000
@interface EValueteController ()<DropDownMwnuDelegate,ClassMenuDelegate,PersonMenuDelegate,SecondDropMenuDelegate,UITextViewDelegate,UITextFieldDelegate,GYZCustomCalendarPickerViewDelegate,YYTextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SDPhotoBrowserDelegate>

@property (nonatomic, strong) LifeModel * lifeModel;
@property (nonatomic, copy) NSString * str;
@property (nonatomic, strong) NSMutableArray * classData;
@property (nonatomic, strong) NSMutableArray * personData;

// 蒙版
@property (nonatomic, strong) UIView * backView;
@property (nonatomic, strong) UIView * popView;
@property (nonatomic, strong) UIButton *commitBtn;
@property (nonatomic, strong) UIButton *handerView;

//@property(nonatomic,retain)YYTextView *popTextView;
//@property(nonatomic,retain)YYTextView *popTextviewRight;
@property(nonatomic,retain)ETTextView *popTextView;
@property(nonatomic,retain)ETTextView *popTextviewRight;
@property(nonatomic,copy)UIButton *addPicButton;
@property(nonatomic,retain)UILabel *tipLabel;
@property(nonatomic,retain)UILabel *titleLabel;
@property(nonatomic,copy)UIButton *button;
@property(nonatomic,strong)NSMutableDictionary *mutImgDict;
@property(nonatomic,strong)NSMutableArray *mutImgArray;
@property(nonatomic,strong)NSMutableArray *imgArray;//最终确定照片URl数组


@property(nonatomic,retain)NSMutableArray *lessonAndTypeArray;

@property(nonatomic,retain)NSMutableArray *tapArray;
@end

@implementation EValueteController
{
    //    __weak NSTimer *_timer;
    //    NSUInteger defaultSelectIndexPathRow;
    
    NSString *submitApplyDate;
    NSString *courseType;
    NSString *courseNum;
    UIImage *showImage;
}


- (NSMutableArray *)personData {
    
    if (_personData == nil) {
        self.personData = [[NSMutableArray alloc] init];
    }
    return _personData;
}
- (NSMutableArray *)classData {
    
    if (_classData == nil) {
        self.classData = [[NSMutableArray alloc] init];
    }
    return _classData;
}


- (void)initData {
    
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    _loginName = [defaults valueForKey:USER_DEFAULT_LOGINNAME];
    _passWord = [defaults valueForKey:USER_DEFAULT_PASSWORD];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    _tapArray = [NSMutableArray array];
    if (!self.shouldMutipleTap) {
        for (NewEvaluateModel *model in _evaluateTableArray) {
            if ([model.id integerValue] > 10) {
                [_tapArray addObject:model.id];
            }
        }
    }
    
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        //        [self doSomeWork];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_evaluateTableArray.count > 0) {
                
                //                NSString *defaultSelectIndexPathRowString = [[NSUserDefaults standardUserDefaults]objectForKey:@"defaultSelectIndexPathRow"];
                //                defaultSelectIndexPathRow = (NSInteger)defaultSelectIndexPathRowString;
                //                NSString *modelID = [[NSUserDefaults standardUserDefaults]objectForKey:@"defaultSelectIndexPathID"];
                //                defaultSelectIndexPathRow = 0;
                
                
                //                for (int i = 0 ; i < _evaluateTableArray.count; i ++) {
                //                    NewEvaluateModel * model = _evaluateTableArray[i];
                //                    if ([modelID isEqualToString:model.id]) {
                //                        defaultSelectIndexPathRow = (NSInteger)i;
                //                    }
                //                }
                
                NewEvaluateModel * model = _evaluateTableArray[(NSInteger )0];
                NSString * urlStr = [NSString stringWithFormat:@"%@/tp/mobile/teacherPlatform!getEvaluateStandard.action?sys_auto_authenticate=true&sys_username=%@&sys_password=%@&evaluateItemId=%@",BaseUrl,_loginName,_passWord,model.id];
                
                _evaluateItemId = model.id;
                NSLog(@"urlStr = %@",urlStr);
                _evaluateLevelArray = [[NSMutableArray alloc] init];
                [TYHHttpTool get:urlStr params:nil success:^(id json) {
                    _evaluateLevelArray = [LifeModel mj_objectArrayWithKeyValuesArray:json];
                    [self.lifeTableView reloadData];
                    
                    
                    //                    if (defaultSelectIndexPathRow) {
                    //                        NSIndexPath*indexPath=[NSIndexPath indexPathForRow:defaultSelectIndexPathRow inSection:0];
                    //                        [_leftTableView selectRowAtIndexPath:0 animated:NO scrollPosition:UITableViewScrollPositionTop];
                    //                    }
                } failure:^(NSError *error) {
                    NSLog(@"%@",error);
                }];
            }
        });
    });
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    [self initData];
    [self initLabel];
    //    [_scroolView  contentSizeToFit];
    
    _popTextView = [ETTextView new];
    _popTextviewRight = [ETTextView new];
    _addPicButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.deadTableView.dataSource = self;
    self.deadTableView.delegate = self;
    self.deadTableView.userInteractionEnabled = NO;
    self.deadTableView.tag = 101;
    
    
    self.lifeTableView.delegate = self;
    self.lifeTableView.dataSource = self;
    [self.lifeTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.lifeTableView.separatorStyle = NO;
    self.lifeTableView.tag = 102;
    
    
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    [self.leftTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.leftTableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    self.leftTableView.separatorStyle = NO;
    //    self.leftTableView.bounces = YES;
    
    self.leftTableView.tag = 103;
    if (self.shouldMutipleTap) {
        self.leftTableView.allowsMultipleSelection = YES;
    }
    
    self.record.delegate = self;
    self.mainItem.delegate = self;
    
    _evaluateLevelArray = [[NSMutableArray alloc] init];
    
    [self getClassesData];
    [self getLessonInfoData];
    //    [self timerInit];
    
    
    if([self isBlankString:[[NSUserDefaults standardUserDefaults]valueForKey:@"saveTimeString"]])
    {
        [self.timeBtn setTitle:[self getCurrentTime] forState:UIControlStateNormal];
        submitApplyDate = [self getCurrentTime];
    }
    
    NSString *textViewString = [[NSUserDefaults standardUserDefaults]valueForKey:@"saveTextViewPerTime"];
    if (![self isBlankString:textViewString]) {
        _record.text = textViewString;
    }
    
    //注册通知,监听键盘出现
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleKeyboardDidShow:)
                                                name:UIKeyboardDidShowNotification
                                              object:nil];
    //注册通知，监听键盘消失事件
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleKeyboardDidHidden)
                                                name:UIKeyboardDidHideNotification
                                              object:nil];
}

- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

- (void)getClassesData {
    
    NSString * urlStr  = [NSString stringWithFormat:@"%@/tp/mobile/teacherPlatform!getEclasses.action?sys_auto_authenticate=true&sys_username=%@&sys_password=%@",BaseUrl,_loginName,_passWord];
    NSLog(@"urlStrClass === %@",urlStr);
    
    [TYHHttpTool get:urlStr params:nil success:^(id json) {
        
        NSLog(@"json == %@",json);
        _classData = [ClassModel mj_objectArrayWithKeyValuesArray:json];
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)getLessonInfoData
{
    NSString * urlStr  = [NSString stringWithFormat:@"%@/tp/mobile/teacherPlatform!getCourseType.action?sys_auto_authenticate=true&sys_username=%@&sys_password=%@",BaseUrl,_loginName,_passWord];
    [TYHHttpTool get:urlStr params:nil success:^(id json) {
        _lessonAndTypeArray = [NSMutableArray array];
        [_lessonAndTypeArray addObjectsFromArray:[LessonModel mj_objectArrayWithKeyValuesArray:json]];
    } failure:^(NSError *error) {
        
    }];
}




- (void) textViewDidChange:(UITextView*)textview
{
    if ([textview isEqual:_popTextView] ) {
        _popTextView.font = [UIFont systemFontOfSize:16];
        
        [[NSUserDefaults standardUserDefaults]setValue:textview.text forKey:@"saveTextViewPerTime"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        //
        //        NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc]initWithAttributedString:textview.attributedText];
        //        [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, _popTextView.text.length)];
        //        _popTextView.attributedText = attriStr;
        //        _record.attributedText = attriStr;
        
        _record.attributedText = _popTextView.attributedText;
        
    }
    else if( [textview isEqual:_record])
    {
        [[NSUserDefaults standardUserDefaults]setValue:textview.text forKey:@"saveTextViewPerTime"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        //
        //        NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc]initWithAttributedString:textview.attributedText];
        //        [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, _record.text.length)];
        //        _popTextView.attributedText = attriStr;
        //        _record.attributedText = attriStr;
        _popTextView.attributedText = _record.attributedText;
    }
    
    else if([textview isEqual:_popTextviewRight])
    {
        //        if (textview.text.length > 0) {
        //            // 禁止系统表情的输入
        //            NSString *text = [self disable_emoji:[textview text]];
        //            if (![text isEqualToString:textview.text]) {
        //                NSRange textRange = [textview selectedRange];
        //                textview.text = text;
        //                [textview setSelectedRange:textRange];
        //            }
        //        }
        
        [[NSUserDefaults standardUserDefaults]setValue:textview.text forKey:@"saveTextViewPerTimeRight"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    if (textview.text.length >= WORD_LIMIT)
    {
        textview.text = [textview.text substringToIndex:WORD_LIMIT];
        [self.popView makeToast:@"输入内容超过3000字" duration:1.5 position:CSToastPositionCenter];
        
        //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入内容超过3000字" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //        [alert show];
    }
    _tipLabel.text = [NSString stringWithFormat:@"您最多可输入3000字,当前%lu/3000", (unsigned long)textview.text.length];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [[NSUserDefaults standardUserDefaults]setObject:toBeString forKey:@"TOPICNAME"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    if ([toBeString length] > 40) {
        textField.text = [toBeString substringToIndex:40];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"主题限制字数为40" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [[NSUserDefaults standardUserDefaults]setObject:textField.text forKey:@"TOPICNAME"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


- (IBAction)chooseClass:(UIButton *)sender {
    //
    //    self.model = _classesCount[indexPath.row];
    //
    //    NSLog(@"indexPath = %ld", (long)indexPath.row);
    //    NSLog(@"当前选择了%@", title);
    //    // 修改标题
    //    [_menubtn setTitle:title forState:UIControlStateNormal];
    
    __block NSInteger  indexNum = 0;
    
    
    NSMutableArray *nameArray = [NSMutableArray array];
    //    [nameArray addObject:@"不选择"];
    for (ClassModel *model in self.classData) {
        [nameArray addObject:model.name];
    }
    NSMutableArray *dataSource = [NSMutableArray arrayWithArray:nameArray];
    
    NSString *selectString = [[NSUserDefaults standardUserDefaults]valueForKey:@"SelectedClassName"];
    
    //    UIButton *button = (UIButton *)sender;
    
    DLPickerView *pickerView = [[DLPickerView alloc] initWithDataSource:dataSource
                                                       withSelectedItem:selectString
                                                      withSelectedBlock:^(id selectedItem) {
                                                          
                                                          //清空评价教师,重新选择
                                                          self.personId = @"";
                                                          [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"SelectedPersonName"];
                                                          [self.personBtn setTitle:@"请选择要评价人" forState:UIControlStateNormal];
                                                          
                                                          
                                                          [sender setTitle:selectedItem forState:UIControlStateNormal];
                                                          [[NSUserDefaults standardUserDefaults]setObject:selectedItem forKey:@"SelectedClassName"];
                                                          
                                                          [self.classData enumerateObjectsUsingBlock:^(ClassModel *classModel, NSUInteger idx, BOOL * _Nonnull stop) {
                                                              if ([classModel.name isEqualToString:selectedItem]) {
                                                                  indexNum = idx;
                                                                  *stop = YES;
                                                              }
                                                          }];
                                                          self.model = self.classData[indexNum];
                                                          [[NSUserDefaults standardUserDefaults]setObject:self.model.id forKey:@"SelectedClassID"];
                                                          [[NSUserDefaults standardUserDefaults]synchronize];
                                                          [self getPersonData];
                                                      }
                                ];
    [pickerView show];
}


- (IBAction)choosePerson:(id)sender {
    
    if (!self.personData.count) {
        [self.view makeToast:@"请先选择被评价班级" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
     NSString *selectString = [[NSUserDefaults standardUserDefaults]valueForKey:@"SelectedPersonName"];
    
    __block NSInteger  indexNum = 0;
    NSMutableArray *nameArray = [NSMutableArray array];
    //    [nameArray addObject:@"不选择"];
    for (PersonModel *model in self.personData) {
        [nameArray addObject:model.name];
    }
    NSMutableArray *dataSource = [NSMutableArray arrayWithArray:nameArray];
    
    UIButton *button = (UIButton *)sender;
    DLPickerView *pickerView = [[DLPickerView alloc] initWithDataSource:dataSource
                                                       withSelectedItem:selectString.length?selectString:nil
                                                      withSelectedBlock:^(id selectedItem) {
                                                          
                                                          [sender setTitle:selectedItem forState:UIControlStateNormal];
                                                          [[NSUserDefaults standardUserDefaults]setObject:selectedItem forKey:@"SelectedPersonName"];
                                                          
                                                          [self.personData enumerateObjectsUsingBlock:^(PersonModel *personModel, NSUInteger idx, BOOL * _Nonnull stop) {
                                                              if ([personModel.name isEqualToString:selectedItem]) {
                                                                  indexNum = idx;
                                                                  self.personId = personModel.id;
                                                                  *stop = YES;
                                                              }
                                                          }];
                                                          
                                                          [[NSUserDefaults standardUserDefaults]setObject:self.personId forKey:@"SelectedPersonID"];
                                                          
                                                          [[NSUserDefaults standardUserDefaults]synchronize];
                                                      }
                                ];
    
    [pickerView show];
    
}

- (IBAction)chooseTimeAction:(id)sender {
    
    GYZCustomCalendarPickerView *pickerView = [[GYZCustomCalendarPickerView alloc]initWithTitle:@"选择日期"];
    pickerView.delegate = self;
    pickerView.calendarType = GregorianCalendar;//日期类型
    [pickerView show];
}

#pragma QTCustomCalendarPickerViewDelegate
//接收日期选择器选项变化的通知
- (void)notifyNewCalendar:(IDJCalendar *)cal {
    NSString *result = @"";
    if ([cal isMemberOfClass:[IDJCalendar class]]) {//阳历
        
        NSString *year =[NSString stringWithFormat:@"%@",cal.year];
        NSString *month = [cal.month intValue] > 9 ? cal.month:[NSString stringWithFormat:@"0%@",cal.month];
        NSString *day = [cal.day intValue] > 9 ? cal.day:[NSString stringWithFormat:@"0%@",cal.day];
        result = [NSString stringWithFormat:@"%@-%@-%@",year,month, day];
        
    } else if ([cal isMemberOfClass:[IDJChineseCalendar class]]) {//阴历
        
        IDJChineseCalendar *_cal=(IDJChineseCalendar *)cal;
        
        NSArray *array=[_cal.month componentsSeparatedByString:@"-"];
        NSString *dateStr = @"";
        if ([[array objectAtIndex:0]isEqualToString:@"a"]) {
            dateStr = [NSString stringWithFormat:@"%@%@",dateStr,[_cal.chineseMonths objectAtIndex:[[array objectAtIndex:1]intValue]-1]];
        } else {
            dateStr = [NSString stringWithFormat:@"%@闰%@",dateStr,[_cal.chineseMonths objectAtIndex:[[array objectAtIndex:1]intValue]-1]];
        }
        result = [NSString stringWithFormat:@"%@%@",dateStr, [NSString stringWithFormat:@"%@", [_cal.chineseDays objectAtIndex:[_cal.day intValue]-1]]];
    }
    submitApplyDate = result;
    [self.timeBtn setTitle:submitApplyDate forState:UIControlStateNormal];
    
    [[NSUserDefaults standardUserDefaults]setValue:submitApplyDate forKey:@"saveTimeString"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (IBAction)chooseCourseTypeAction:(id)sender {
    
    NSMutableArray *nameArray = [NSMutableArray array];
    [nameArray addObject:@"不选择"];
    for (LessonModel *model in _lessonAndTypeArray) {
        [nameArray addObject:model.name];
    }
    NSMutableArray *dataSource = [NSMutableArray arrayWithObject:nameArray];
    
    UIButton *button = (UIButton *)sender;
    DLPickerView *pickerView = [[DLPickerView alloc] initWithDataSource:dataSource
                                                       withSelectedItem:button.titleLabel.text
                                                      withSelectedBlock:^(id selectedItem) {
                                                          if (![selectedItem[0] isEqualToString:@"不选择"]) {
                                                              courseType = selectedItem[0];
                                                              [[NSUserDefaults standardUserDefaults]setValue:courseType forKey:@"saveCourseTypeString"];
                                                              [[NSUserDefaults standardUserDefaults]synchronize];
                                                              [sender setTitle:selectedItem[0] forState:UIControlStateNormal];
                                                          }
                                                          else
                                                          {
                                                              [sender setTitle:@"不选择" forState:UIControlStateNormal];
                                                              courseType = @"";
                                                              [[NSUserDefaults standardUserDefaults]setValue:courseType forKey:@"saveCourseTypeString"];
                                                              [[NSUserDefaults standardUserDefaults]synchronize];
                                                          }
                                                          
                                                      }
                                ];
    
    [pickerView show];
    
}
- (IBAction)chooseCourseNumAction:(id)sender {
    
    NSMutableArray *numArray = [NSMutableArray array];
    [numArray addObject:@"不选择"];
    [numArray addObject:@"08:00 ~ 08:40"];
    [numArray addObject:@"08:50 ~ 09:30"];
    [numArray addObject:@"09:40 ~ 10:20"];
    [numArray addObject:@"10:35 ~ 11:15"];
    [numArray addObject:@"11:25 ~ 12:05"];
    [numArray addObject:@"13:40 ~ 14:20"];
    [numArray addObject:@"14:35 ~ 15:15"];
    [numArray addObject:@"15:25 ~ 16:05"];
    [numArray addObject:@"16:15 ~ 16:55"];
    
    //    for (int i = 1;i <= 12;i++) {
    //        [numArray addObject:[NSString stringWithFormat:@"第%d课节",i]];
    //    }
    NSMutableArray *dataSource = [NSMutableArray arrayWithObject:numArray];
    UIButton *button = (UIButton *)sender;
    DLPickerView *pickerView = [[DLPickerView alloc] initWithDataSource:dataSource
                                                       withSelectedItem:button.titleLabel.text
                                                      withSelectedBlock:^(id selectedItem) {
                                                          if (![selectedItem[0] isEqualToString:@"不选择"]) {
                                                              courseNum = selectedItem[0];
                                                              [[NSUserDefaults standardUserDefaults]setValue:courseNum forKey:@"saveCourseNumString"];
                                                              [[NSUserDefaults standardUserDefaults]synchronize];
                                                              [sender setTitle:selectedItem[0] forState:UIControlStateNormal];
                                                          }
                                                          else
                                                          {
                                                              [sender setTitle:@"不选择" forState:UIControlStateNormal];
                                                              courseNum = @"";
                                                              [[NSUserDefaults standardUserDefaults]setValue:courseNum forKey:@"saveCourseNumString"];
                                                              [[NSUserDefaults standardUserDefaults]synchronize];
                                                          }
                                                      }
                                ];
    [pickerView show];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.tag == 101) {
        
        return 1;
        
    } else if (tableView.tag == 102) {
        
        if (_evaluateLevelArray.count == 0) {
            
            return 5;
        } else
            return _evaluateLevelArray.count;
        
    } else
        
        return _evaluateTableArray.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 102) {
        LifeModel *model = [LifeModel new];
        if (_evaluateLevelArray.count > 0) {
            model =  _evaluateLevelArray[indexPath.row];
        }
        CGFloat cellHeight =0;
        //label的高度
        CGSize textMaxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 2 * 323, MAXFLOAT);
        CGFloat labelHeight = [model.note boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height;
        cellHeight += labelHeight;
        if (cellHeight >= 46) {
            return cellHeight;
        }else
            return 44;
    }
    else if(tableView.tag == 103)
    {
        NewEvaluateModel *model = [_evaluateTableArray objectAtIndex:indexPath.row];
        if ([self isBlankString:model.level]) {
            return 30;
        }else return 45;
    }
    else
    {
        return 44;
    }
}

- (CGFloat)heightForText:(NSString *)text
{
    //设置计算文本时字体的大小,以什么标准来计算
    NSDictionary *attrbute = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    return [text boundingRectWithSize:CGSizeMake(323, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrbute context:nil].size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 102) {
        
        static NSString * idenfitier = @"lifeCell";
        LifeCell *cell = (LifeCell *)[tableView dequeueReusableCellWithIdentifier:idenfitier];
        if (cell == nil) {
            cell = [[LifeCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: idenfitier];
        }
        if (_evaluateLevelArray.count > 0) {
            LifeModel * model =  _evaluateLevelArray[indexPath.row];
            
            if ([model.name isEqualToString:@"总分"]) {
                
                cell.two.text = [NSString stringWithFormat:@"%@",model.maxscore];
            } else{
                cell.two.text = [NSString stringWithFormat:@"%@~%@",model.minscore,model.maxscore];
            }
            if (model.levels.count > 0) {
                
                for (NSDictionary * dict in model.levels) {
                    
                    NSString * str  = [NSString stringWithFormat:@"%@(%@~%@)",dict[@"name"],dict[@"minscore"],dict[@"maxscore"]];
                    
                    self.str = [str stringByAppendingFormat:@"%@",self.str];
                };
            }
            NSLog(@"self.str  =  %@",self.str);
            cell.three.text = self.str;
            cell.four.text = model.note;
            cell.one.text = model.name;
            if ([self.str hasSuffix:@"(null)"]) {
                NSMutableString *string = [NSMutableString stringWithString:self.str];
                [string replaceCharactersInRange:NSMakeRange(self.str.length - 7, 6) withString:@""];
                cell.three.text = string;
            }
            self.str = nil;
        }
        
        //        UITapGestureRecognizer *tapGes = [UITapGestureRecognizer alloc]ini
        return cell;
        
        
    } else if (tableView.tag == 101) {
        
        static NSString * idenfitier = @"deadCell";
        DeadCell *cell = (DeadCell *)[tableView dequeueReusableCellWithIdentifier:idenfitier];
        if (cell == nil) {
            cell = [[DeadCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: idenfitier];
        }
        return cell;
        
    } else {
        
        
        if ([[_evaluateTableArray objectAtIndex:indexPath.row] isKindOfClass:[NewEvaluateModel class]]) {
            
            static NSString * idenfitier = @"leftCell";
            LeftCell *cell = (LeftCell *)[tableView dequeueReusableCellWithIdentifier:idenfitier];
            if (cell == nil) {
                cell = [[LeftCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: idenfitier];
            }
            cell.textLabel.numberOfLines = 0;
            
            NewEvaluateModel *model = [_evaluateTableArray objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@",model.name];
            
            cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.accessoryType = NO;
            cell.backgroundColor = [UIColor colorWithRed:(24 + model.IndentationLevel * 40) / 255.0 green:(171 + model.IndentationLevel * 40) / 255.0 blue:(142 + model.IndentationLevel * 40 )/ 255.0 alpha:0.2];
            
            if ([model.level isEqualToString:@"Inside"]) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@",model.name];
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.backgroundColor = [UIColor whiteColor];
                cell.textLabel.textColor = [UIColor blackColor];
            }
            //
            //            if (model.IndentationLevel == 0 ) {
            //                cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
            //                cell.textLabel.textColor = [UIColor blackColor];
            //                cell.accessoryType = NO;
            //                cell.backgroundColor = [UIColor colorWithRed:24 / 255.0 green:171 / 255.0 blue:142/ 255.0 alpha:0.2];
            //            }
            //            else if(model.IndentationLevel == 1)
            //            {
            //                cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
            //                cell.textLabel.textColor = [UIColor darkGrayColor];
            //                cell.accessoryType = NO;
            //                cell.backgroundColor = [UIColor colorWithRed:24 / 255.0 green:171 / 255.0 blue:142/ 255.0 alpha:0.1];
            //            }
            //
            return  cell;
        }
        else if ([[_evaluateTableArray objectAtIndex:indexPath.row] isKindOfClass:[NewEvaluateDetailModel class]]) {
            {
                static NSString * idenfitierr = @"lefttCell";
                LeftCell *cell = (LeftCell *)[tableView dequeueReusableCellWithIdentifier:idenfitierr];
                if (cell == nil) {
                    cell = [[LeftCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: idenfitierr];
                }
                cell.textLabel.numberOfLines = 0;
                
                NewEvaluateDetailModel *model = [_evaluateTableArray objectAtIndex:indexPath.row];
                
                cell.textLabel.text = [NSString stringWithFormat:@"     %@",model.name];
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.backgroundColor = [UIColor whiteColor];
                cell.textLabel.textColor = [UIColor blackColor];
                
                return cell;
            }
        }
        return [UITableViewCell new];
    }
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    if (tableView.tag == 103) {
        
        if ([[_evaluateTableArray objectAtIndex:indexPath.row] isKindOfClass:[NewEvaluateDetailModel class]]) {
            //            TYHContactDetailCell *cell = (TYHContactDetailCell *)[tableView cellForRowAtIndexPath:indexPath];
            
        }
        
        LeftCell *cell = (LeftCell *)[tableView cellForRowAtIndexPath:indexPath];
        NewEvaluateModel *model = [_evaluateTableArray objectAtIndex:indexPath.row];
        
        if (model.childs) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            BOOL isAlreadyInserted = NO;
            for (NewEvaluateModel *contactModel in model.childs) {
                NSInteger index = [_evaluateTableArray indexOfObjectIdenticalTo:contactModel];
                isAlreadyInserted=(index>0 && index!=NSIntegerMax);
                if(isAlreadyInserted) break;
            }
            if (isAlreadyInserted) {
                [self miniMizeThisRows:model.childs];
            }else{
                NSUInteger count=indexPath.row+1;
                NSMutableArray *arCells=[NSMutableArray array];
                for(NewEvaluateModel *dInner in model.childs ) {
                    [arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                    [_evaluateTableArray insertObject:dInner atIndex:count++];
                }
                [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        else
        {
            //
            NewEvaluateModel * model = _evaluateTableArray[indexPath.row];
            
            if (![model.level isEqualToString:@"Inside"]) {
                //            [self.view makeToast:@"该项不是评价项" duration:1.5 position:CSToastPositionCenter];
                [tableView deselectRowAtIndexPath:indexPath animated:NO];
                return;
            }
            else
            {
                NSString * urlStr = [NSString stringWithFormat:@"%@/tp/mobile/teacherPlatform!getEvaluateStandard.action?sys_auto_authenticate=true&sys_username=%@&sys_password=%@&evaluateItemId=%@",BaseUrl,_loginName,_passWord,model.id];
                
                if (![_evaluateItemId isEqualToString:model.id]) {
                    
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }
                
                if (self.shouldMutipleTap) {
                    if (_tapArray.count < 20) {
                        [ _tapArray addObject:model.id];
                        //
                    }
                    else
                    {
                        [tableView deselectRowAtIndexPath:indexPath animated:YES];
                        [self.view makeToast:@"您最多可选择20项" duration:1.5 position:CSToastPositionCenter];
                        return;
                    }
                }
                else
                {
                    _tapArray = [NSMutableArray arrayWithObject:model.id];
                }
                
                self.chooseCountLabel.text = [NSString stringWithFormat:@"已选择:%lu",(unsigned long)_tapArray.count];
                
                _evaluateItemId = model.id;
                
                _evaluateLevelArray = [[NSMutableArray alloc] init];
                [TYHHttpTool get:urlStr params:nil success:^(id json) {
                    _evaluateLevelArray = [LifeModel mj_objectArrayWithKeyValuesArray:json];
                    [self.lifeTableView reloadData];
                } failure:^(NSError *error) {
                    NSLog(@"%@",error);
                }];
            }
            
        }
        if (model.userList) {
            BOOL isAlreadyInserted = NO;
            for (NewEvaluateDetailModel *userModel in model.userList) {
                NSInteger index = [_evaluateTableArray indexOfObjectIdenticalTo:userModel];
                isAlreadyInserted=(index>0 && index!=NSIntegerMax);
                if(isAlreadyInserted) break;
            }
            if (isAlreadyInserted) {
                [self miniMizeThisRowsWithUserModel:model.userList];
            }else{
                NSUInteger count=indexPath.row+1;
                NSMutableArray *arCells=[NSMutableArray array];
                for(NewEvaluateDetailModel *dInner in model.userList ) {
                    [arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                    [_evaluateTableArray insertObject:dInner atIndex:count++];
                }
                [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        
        
    }
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewEvaluateModel * model = _evaluateTableArray[indexPath.row];
    NSMutableArray *array = [NSMutableArray arrayWithArray:_tapArray];
    
    if ([model.level isEqualToString:@"Inside"]) {
        if (self.shouldMutipleTap) {
            for (NSString *tapString in array) {
                if ([model.id isEqualToString:tapString]) {
                    [_tapArray removeObject:tapString];
                }
            }
        }
    }
    self.chooseCountLabel.text = [NSString stringWithFormat:@"已选择:%lu",(unsigned long)_tapArray.count];
}



-(void)miniMizeThisRows:(NSArray*)ar{
    for (NewEvaluateModel *model in ar) {
        NSUInteger indexToRemove = [_evaluateTableArray indexOfObjectIdenticalTo:model];
        if (model.userList && model.userList.count > 0) {
            [self miniMizeThisRowsWithUserModel:model.userList];
        }
        if (model.childs && model.childs.count > 0) {
            [self miniMizeThisRows:model.childs];
        }
        if([_evaluateTableArray indexOfObjectIdenticalTo:model]!=NSNotFound) {
            [_evaluateTableArray removeObjectIdenticalTo:model];
            [_leftTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                                    [NSIndexPath indexPathForRow:indexToRemove inSection:0]
                                                    ]
                                  withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}


-(void)miniMizeThisRowsWithUserModel:(NSArray*)ar{
    for (NewEvaluateModel *model in ar) {
        
        NSUInteger indexToRemove = [_evaluateTableArray indexOfObjectIdenticalTo:model];
        if([_evaluateTableArray indexOfObjectIdenticalTo:model]!=NSNotFound) {
            [_evaluateTableArray removeObjectIdenticalTo:model];
            [_leftTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                                    [NSIndexPath indexPathForRow:indexToRemove inSection:0]
                                                    ]
                                  withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}


//返回行缩进 有三个方法一起配合使用才生效

-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger tempNnum = indexPath.row;
    if (indexPath.row >= _evaluateTableArray.count) {
        tempNnum = _evaluateTableArray.count - 1;
    }
    
    NewEvaluateModel *model = [_evaluateTableArray objectAtIndex:tempNnum];
    return model.IndentationLevel*0.5;
}




- (void)getDataArrayCount:(NSMutableArray *)array {
    
    self.classesCount = [[NSMutableArray alloc] init];
    self.classesCount = array;
    
}
- (void)getDataArrayPersonCount:(NSMutableArray *)array {
    
    self.personCunt = [[NSMutableArray alloc] init];
    self.personCunt = array;
    
}

#pragma mark - DropdownMenuDelegate
//下拉菜单被销毁了
- (void)dropdownMenuDidDismiss:(DropDownMenu *)menu
{
    _menubtn.selected = NO;
    
}
- (void)dropdownPersonMenuDidDismiss:(SecondDropMenu *)menu
{
    _personBtn.selected = NO;
    
}

//下拉菜单显示了
- (void)dropdownMenuDidShow:(DropDownMenu *)menu
{
    _menubtn.selected = YES;
    
}
- (void)dropdownPersonMenuDidShow:(SecondDropMenu *)menu
{
    _personBtn.selected = YES;
    
}
#pragma mark - TitleMenuDelegate
-(void)selectAtIndexPath:(NSIndexPath *)indexPath title:(NSString *)title
{
    
}
- (void)getPersonData {
    
    NSString * urlStr  = [NSString stringWithFormat:@"%@/tp/mobile/teacherPlatform!getTeachers.action?sys_auto_authenticate=true&sys_username=%@&sys_password=%@&eclassId=%@",BaseUrl,_loginName,_passWord,self.model.id];
    
    NSLog(@"urlStrPerson === %@",urlStr);
    
    [TYHHttpTool get:urlStr params:nil success:^(id json) {
        
        //        NSLog(@" person json == %@",json);
        
        _personData = [PersonModel mj_objectArrayWithKeyValuesArray:json];
        
        
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)selectPersonAtIndexPath:(NSIndexPath *)indexPath title:(NSString *)title {
    
    PersonModel * model = _personCunt[indexPath.row];
    self.personId = model.id;
    [_personBtn setTitle:title forState:UIControlStateNormal];
    
    [[NSUserDefaults standardUserDefaults]setObject:model.id forKey:@"SelectedPersonID"];
    [[NSUserDefaults standardUserDefaults]setObject:model.name forKey:@"SelectedPersonName"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
- (IBAction)beginMark:(id)sender {
    
    UpScoreViewController *main = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"UpScoreViewController"];
    
    main.item = self.mainItem.text;
    main.personId = self.personId;
    main.classId = _model.id;
    
    NSMutableString *tapEvaluateItemIdString = [NSMutableString string];
    for (NSString *tapString in _tapArray) {
        [tapEvaluateItemIdString appendFormat:@"%@,",tapString];
    }
    
    main.evaluateItemId = tapEvaluateItemIdString;
    main.evaluateIDArray = [NSMutableArray arrayWithArray:_tapArray];
    
    //    main.content = [NSString stringWithFormat:@"%@",self.record.text];
    main.content = [self emojiEncode:_popTextView.attributedText];
    
    if (![self isBlankString:_popTextView.text]) {
        NSString *textStr = [[self textStringWithSymbol:@"[图片]" attributeString:_popTextView.attributedText] mutableCopy];
        NSMutableArray *arry = [NSMutableArray arrayWithArray:self.mutImgArray];
    }
    main.textviewImageArray = [NSMutableArray arrayWithArray:_mutImgArray];
    
    //    main.content = self.record.text;
    
    main.taskID = self.taskID;
    main.evaluateLevelArray = self.evaluateLevelArray;
    main.courseType = courseType;
    main.lesson = courseNum;
    main.researchDate = submitApplyDate;
    main.simpleEvaluate = self.popTextviewRight.text;
    main.courseInfoArray = [NSMutableArray arrayWithArray:_lessonAndTypeArray];
    
    if([self isBlankString:_model.id]) {
        [self.view makeToast:@"请选择被评价班级" duration:1.5 position:CSToastPositionCenter];
    }
    else  if ([self isBlankString:self.personId]) {
        [self.view makeToast:@"请选择被评价人" duration:1.5 position:CSToastPositionCenter];
    }
    //    else  if ([self isBlankString:courseType]) {
    //        [self.view makeToast:@"请选择类型" duration:1.5 position:CSToastPositionCenter];
    //    }
    else if([self isBlankString:submitApplyDate])
    {
        [self.view makeToast:@"请选择时间" duration:1.5 position:CSToastPositionCenter];
    }
    
    else
        [self.navigationController pushViewController:main animated:YES];
    
    [self saveRichTextview];
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    //    [_timer invalidate];
    //    _timer = nil;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //临时注释
    //    NSString *textViewString = [[NSUserDefaults standardUserDefaults]valueForKey:@"saveTextViewPerTime"];
    //    if (![self isBlankString:textViewString]) {
    //        _record.text = textViewString;
    //    }
    
    //    [self readRichTextview];
    
    NSString *textViewStringRight = [[NSUserDefaults standardUserDefaults]valueForKey:@"saveTextViewPerTimeRight"];
    if (![self isBlankString:textViewStringRight]) {
        _popTextviewRight.text = textViewStringRight;
    }
    
    NSString *textFieldString =[[NSUserDefaults standardUserDefaults] objectForKey:@"TOPICNAME"];
    if (![self isBlankString: textFieldString]) {
        _mainItem.text = textFieldString;
    }
    
    NSString *SelectedPersonID =[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedPersonID"];
    if (![self isBlankString:SelectedPersonID]) {
        self.personId = SelectedPersonID;
    }
    NSString *SelectedPersonName =[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedPersonName"];
    if (![self isBlankString:SelectedPersonName]) {
        [_personBtn setTitle:SelectedPersonName forState:UIControlStateNormal];
    }
    NSString *SelectedClassID =[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedClassID"];
    if (![self isBlankString:SelectedClassID]) {
        _model = [ClassModel new];
        self.model.id = SelectedClassID;
    }
    NSString *SelectedClassName =[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedClassName"];
    if (![self isBlankString:SelectedClassName]) {
        [_menubtn setTitle:SelectedClassName forState:UIControlStateNormal];
    }
    
    
    NSString *saveTimeString =[[NSUserDefaults standardUserDefaults] objectForKey:@"saveTimeString"];
    if (![self isBlankString:saveTimeString]) {
        [self.timeBtn setTitle:saveTimeString forState:UIControlStateNormal];
        submitApplyDate = saveTimeString;
    }
    NSString *saveCourseNumString =[[NSUserDefaults standardUserDefaults] objectForKey:@"saveCourseNumString"];
    if (![self isBlankString:saveCourseNumString]) {
        [self.numLessonBtn setTitle:saveCourseNumString forState:UIControlStateNormal];
        courseNum = saveCourseNumString;
    }
    
    NSString *saveCourseTypeString =[[NSUserDefaults standardUserDefaults] objectForKey:@"saveCourseTypeString"];
    if (![self isBlankString:saveCourseTypeString]) {
        [self.typeLessonBtn setTitle:saveCourseTypeString forState:UIControlStateNormal];
        courseType = saveCourseTypeString;
    }
}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

-(void)initLabel
{
    _oneLabel.layer.masksToBounds = YES;
    _oneLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _oneLabel.layer.borderWidth = 0.5f;
    
    _twoLabel.layer.masksToBounds = YES;
    _twoLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _twoLabel.layer.borderWidth = 0.5f;
    
    _threeLabel.layer.masksToBounds = YES;
    _threeLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _threeLabel.layer.borderWidth = 0.5f;
    
    _fourLabel.layer.masksToBounds = YES;
    _fourLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _fourLabel.layer.borderWidth = 0.5f;
    
    _lifeTableView.layer.masksToBounds = YES;
    _lifeTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _lifeTableView.layer.borderWidth = 0.5f;
    
}

-(void)clearNSUserDefaults
{
    
    //清空两个TextView的值
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:_evaluateItemId];
    [[NSUserDefaults standardUserDefaults]setObject:[NSMutableArray array] forKey:_evaluateItemId];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"saveImageDataArray"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"saveImageNameArray"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"saveImageNoteArray"];
    [[NSUserDefaults standardUserDefaults]setObject:[NSMutableArray array] forKey:@"saveImageNameArray"];
    [[NSUserDefaults standardUserDefaults]setObject:[NSMutableArray array] forKey:@"saveImageNoteArray"];
    [[NSUserDefaults standardUserDefaults]setObject:[NSMutableArray array] forKey:@"saveImageDataArray"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
}


- (void) keyboardWillHide : (NSNotification*)notification {
    _scroolView.contentOffset = CGPointMake(0, 0);
}



#pragma mark - 放大方法

- (UIView *)backView
{
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor lightGrayColor];
        _backView.alpha = 0.5f;
        _backView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return _backView;
}

- (UIView *)popView {
    
    if (_popView == nil) {
        
        self.popView = [[UIView alloc] init];
        _popView.layer.masksToBounds = YES;
        _popView.layer.cornerRadius = 20;
        self.popView.backgroundColor = [UIColor whiteColor];
    }
    return _popView;
}

#define kWindow  [UIApplication sharedApplication].keyWindow

- (IBAction)showBigTextViewAction:(id)sender {
    
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.25 animations:^{
        self.popView.frame = CGRectMake(60, 40, [UIScreen mainScreen].bounds.size.width - 120, [UIScreen mainScreen].bounds.size.height - 80);
    }];
    
    //  添加蒙版
    self.backView.frame = kWindow.bounds;
    [kWindow addSubview:self.backView];
    
    //  添加蒙版
    self.backView.frame = kWindow.bounds;
    [kWindow addSubview:self.backView];
    
    // 在蒙版上添加 popView;
    [kWindow addSubview:self.popView];
    [kWindow bringSubviewToFront:self.popView];
    
    // 添加确定按钮
    _button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _button.frame = CGRectMake(self.popView.frame.size.width - 40,0, 40, 40);
    [_button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_button setBackgroundImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    [self.popView addSubview:_button];
    [_button addTarget:self action:@selector(dismiss:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.popView.frame.size.width / 2 - 50, 30, 100, 30)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont boldSystemFontOfSize:22];
    _titleLabel.textColor = [UIColor darkGrayColor];
    _titleLabel.text = @"调研记录";
    [self.popView addSubview:_titleLabel];
    
    _popTextView.frame = CGRectMake(30, 80, self.popView.frame.size.width - 310, self.popView.frame.size.height - 60 - 80 - 20);
    _popTextView.font = [UIFont systemFontOfSize:16];
    _popTextView.layer.masksToBounds = YES;
    _popTextView.layer.cornerRadius = 5.0f;
    _popTextView.delegate = self;
    _popTextView.placeholder = @"教学过程简要记录";
    _popTextView.layer.borderWidth = 1.f;
    
    NSMutableAttributedString *attriStr = [_popTextView.attributedText mutableCopy];
    [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, _popTextView.text.length)];
    _popTextView.attributedText = attriStr;
    
    
    //临时注释
    NSString *textViewString = [[NSUserDefaults standardUserDefaults]valueForKey:@"saveTextViewPerTime"];
    if (![self isBlankString:textViewString]) {
        _popTextView.attributedText = _record.attributedText;
    }
    
    
    [self readRichTextview];
    
    
    _popTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    if (!_popTextView.superview) {
        [self.popView addSubview:_popTextView];
    }
    
    
    
    //    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    //    [topView setBarStyle:UIBarStyleDefault];//设置为默认的风格白色
    ////    UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    //    UIBarButtonItem *helloButton = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:nil];
    //
    //    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    //    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    //    NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
    //    [topView setItems:buttonsArray];
    //    [_popTextView setInputAccessoryView:topView];//键盘上加这个视图
    //
    
    
    
    _popTextviewRight.frame = CGRectMake(30 + 600 + 20, 80, self.popView.frame.size.width - 310 - 340 - 30, self.popView.frame.size.height - 60 - 80 - 20);
    _popTextviewRight.font = [UIFont systemFontOfSize:16];
    _popTextviewRight.layer.masksToBounds = YES;
    _popTextviewRight.layer.cornerRadius = 5.0f;
    _popTextviewRight.delegate = self;
    _popTextviewRight.placeholder = @"简评";
    _popTextviewRight.layer.borderWidth = 1.f;
    NSString *textViewStringRight = [[NSUserDefaults standardUserDefaults]valueForKey:@"saveTextViewPerTimeRight"];
    if (![self isBlankString:textViewStringRight]) {
        _popTextviewRight.text = textViewStringRight;
    }
    _popTextviewRight.layer.borderColor = [UIColor lightGrayColor].CGColor;
    if (!_popTextviewRight.superview) {
        [self.popView addSubview:_popTextviewRight];
    }
    
    
    _addPicButton.frame = CGRectMake(30, 80 + self.popTextView.frame.size.height + 10, 100, 30);
    _addPicButton.layer.masksToBounds = YES;
    _addPicButton.layer.cornerRadius = 5.0f;
    _addPicButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _addPicButton.layer.borderWidth = 1.f;
    [_addPicButton setTitle:@"添加图片" forState:UIControlStateNormal];
    [_addPicButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_addPicButton addTarget:self action:@selector(AddPictureAction) forControlEvents:UIControlEventTouchUpInside];
    if (!_addPicButton.superview) {
        [self.popView addSubview:_addPicButton];
    }
    
    
    _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.popView.frame.size.width - 30 - 600, 80 + self.popTextView.frame.size.height + 10, 350, 30)];
    _tipLabel.textAlignment = NSTextAlignmentRight;
    _tipLabel.font = [UIFont boldSystemFontOfSize:18];
    _tipLabel.textColor = [UIColor lightGrayColor];
    _tipLabel.text = [NSString stringWithFormat:@"您最多可输入3000字,当前%lu/3000", (unsigned long)_popTextView.text.length];
    
    if (!_tipLabel.superview) {
        [self.popView addSubview:_tipLabel];
    }
    
}


- (void)dismiss:(UIButton *)btn {
    [self.backView removeFromSuperview];
    [self.popView removeFromSuperview];
    [self.popTextviewRight removeFromSuperview];
    [self.tipLabel removeFromSuperview];
    [self.titleLabel removeFromSuperview];
    [self.button removeFromSuperview];
    _backView = nil;
    
    _record.attributedText = _popTextView.textStorage;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self dismiss:nil];
}

-(void)dismissKeyBoard
{
    [_popTextView resignFirstResponder];
}


-(void)AddPictureAction
{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"添加图片" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    //添加Button
    [alert addAction: [UIAlertAction actionWithTitle: @"拍照" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //处理点击拍照
        NSLog(@"处理点击拍照");
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIImagePickerController *ipc=[[UIImagePickerController alloc] init];
            ipc.sourceType=UIImagePickerControllerSourceTypeCamera;
            ipc.delegate=self;
            ipc.allowsEditing=NO;
            [self presentViewController:ipc animated:YES completion:nil];
        }
    }]];
    
    [alert addAction: [UIAlertAction actionWithTitle: @"从相册选取" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //处理点击从相册选取
        NSLog(@"处理点击从相册选取");
        
        UIImagePickerController *ipc=[[UIImagePickerController alloc] init];
        ipc.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        ipc.delegate=self;
        ipc.allowsEditing=NO;
        [self presentViewController:ipc animated:YES completion:nil];
        
    }]];
    
    [alert addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController: alert animated: YES completion: nil];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *) info{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImage * img = [info objectForKey:UIImagePickerControllerOriginalImage];
            UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
        }
        
        UIImage * img = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        img = [UIImage imageWithData:[NSData dataWithData:[self zipNSDataWithImage:img]]];
        NSMutableAttributedString *attriStr = [_popTextView.attributedText mutableCopy];
        
        __block NSUInteger base = 0;
        //遍历
        [attriStr enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attriStr.length)
                             options:0
                          usingBlock:^(id value, NSRange range, BOOL *stop) {
                              //检查类型是否是自定义NSTextAttachment类
                              if (value && [value isKindOfClass:[NSTextAttachment class]] ) {
                                  base++;
                              }
                          }];
        
        NSString *string = [NSString stringWithFormat:@"\nAttachment%lu.png\n",base];
        NSAttributedString *needAddString = [[NSAttributedString alloc]initWithString:string];
        [attriStr appendAttributedString:needAddString];
        
        
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc]initWithData:nil ofType:nil];
        [textAttachment setImage:img];
        
        textAttachment.bounds = CGRectMake(24, 0, self.popTextView.frame.size.width - 48, [self getImgHeightWithImg:img]);
        NSAttributedString* imageAttachment = [NSAttributedString attributedStringWithAttachment:textAttachment];
        [attriStr appendAttributedString:imageAttachment];
        
        NSString *nString = [NSString stringWithFormat:@" \n\n"];
        NSAttributedString *nAddString = [[NSAttributedString alloc]initWithString:nString];
        [attriStr appendAttributedString:nAddString];
        
        
        [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, _popTextView.text.length)];
        _popTextView.attributedText = attriStr;
        _popTextView.font = [UIFont systemFontOfSize:16];
        [_popTextView becomeFirstResponder];
        
    }];
    
}

//根据屏幕宽度适配高度
- (CGFloat)getImgHeightWithImg:(UIImage *)img
{
    CGFloat height = ((self.popTextView.frame.size.width - 48)/ img.size.width) * img.size.height;
    return height;
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        [_popTextView becomeFirstResponder];
    }];
}


#pragma mark - 富文本转换操作
/** 将富文本转换为带有图片标志的纯文本*/
- (NSString *)textStringWithSymbol:(NSString *)symbol attributeString:(NSAttributedString *)attributeString{
    NSString *string = attributeString.string;
    string = [self stringDeleteString:@"\n" frontString:@"[图片]" inString:string];
    //最终纯文本
    NSMutableString *textString = [NSMutableString stringWithString:string];
    //替换下标的偏移量
    __block NSUInteger base = 0;
    
    
    //遍历
    [attributeString enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attributeString.length)
                                options:0
                             usingBlock:^(id value, NSRange range, BOOL *stop) {
                                 //检查类型是否是自定义NSTextAttachment类
                                 if (value && [value isKindOfClass:[NSTextAttachment class]]) {
                                     //替换
                                     [textString replaceCharactersInRange:NSMakeRange(range.location + base, range.length) withString:symbol];
                                     //增加偏移量
                                     base += (symbol.length - 1);
                                     //将富文本中最终确认的照片取出来
                                     NSTextAttachment *attachmentImg = (NSTextAttachment *)value;
                                     [self.mutImgArray addObject:attachmentImg.image];
                                 }
                             }];
    //-------------- 最后点击完成事件时 通过对比将富文本中最终确定的照片审选出来 找到对应照片的URl地址
    NSArray *keyArray = [self.mutImgDict allKeys];
    
    for (int i = 0; i < _mutImgArray.count; i ++) {
        UIImage *img = _mutImgArray[i];
        for (int j = 0; j < keyArray.count; j ++) {
            UIImage *myImg = [self.mutImgDict valueForKey:keyArray[j]];
            if (myImg == img) {
                [self.imgArray addObject:keyArray[j]];
            }
        }
    }
    //--------------
    return textString;
}
/** 删除字符串*/
- (NSString *)stringDeleteString:(NSString *)deleteString frontString:(NSString *)frontString inString:(NSString *)inString{
    NSArray *ranges = [self rangeOfSymbolString:frontString inString:inString];
    NSMutableString *mutableString = [inString mutableCopy];
    NSUInteger base = 0;
    for (NSString *rangeString in ranges) {
        NSRange range = NSRangeFromString(rangeString);
        [mutableString deleteCharactersInRange:NSMakeRange(range.location - deleteString.length + base, deleteString.length)];
        base -= deleteString.length;
    }
    return [mutableString copy];
}
/** 统计文本中所有图片资源标志的range*/
- (NSArray *)rangeOfSymbolString:(NSString *)symbol inString:(NSString *)string {
    NSMutableArray *rangeArray = [NSMutableArray array];
    NSString *string1 = [string stringByAppendingString:symbol];
    NSString *temp;
    for (int i = 0; i < string.length; i ++) {
        temp = [string1 substringWithRange:NSMakeRange(i, symbol.length)];
        if ([temp isEqualToString:symbol]) {
            NSRange range = {i, symbol.length};
            [rangeArray addObject:NSStringFromRange(range)];
        }
    }
    return rangeArray;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    
    showImage = textAttachment.image;
    
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    
    //设置容器视图,父视图
    
    browser.sourceImagesContainerView = self.view;
    
    browser.currentImageIndex = 0;
    
    browser.imageCount = 1;
    
    //设置代理
    
    browser.delegate = self;
    
    //显示图片浏览器
    
    [browser show];
    return YES;
    
}


- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return showImage;
}



#pragma mark - 懒加载
- (NSMutableArray *)mutImgArray
{
    if (!_mutImgArray) {
        _mutImgArray = [NSMutableArray array];
    }
    return _mutImgArray;
}
- (NSMutableDictionary *)mutImgDict
{
    if (!_mutImgDict) {
        _mutImgDict = [NSMutableDictionary dictionary];
    }
    return _mutImgDict;
}
-(NSMutableArray *)imgArray
{
    if (!_imgArray) {
        _imgArray = [NSMutableArray array];
    }
    return _imgArray;
}

- (NSString *)emojiEncode:(NSAttributedString *)string
{
    NSString *htmlString = [self htmlStringByHtmlAttributeString:string];
    NSString *uniStr = [NSString stringWithUTF8String:[htmlString UTF8String]];
    NSData *uniData = [uniStr dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *emojiText = [[NSString alloc] initWithData:uniData encoding:NSUTF8StringEncoding];
    return emojiText;
}

-(NSString *)htmlStringByHtmlAttributeString:(NSAttributedString *)htmlAttributeString{
    
    //    __block NSUInteger base = 0;
    //    __block NSMutableAttributedString *attriStr = [_popTextView.attributedText mutableCopy];
    //
    //    //遍历
    //    [_popTextView.attributedText enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, _popTextView.attributedText.length)
    //                                            options:0
    //                                         usingBlock:^(id value, NSRange range, BOOL *stop) {
    //                                             //检查类型是否是自定义NSTextAttachment类
    //                                             if (value && [value isKindOfClass:[NSTextAttachment class]]) {
    //                                                 base++;
    //                                             }}];
    //
    //    __block NSUInteger base2 = 0;
    //
    //
    ////    NSMutableAttributedString
    //    for (int i = 0; i <= base;i++) {
    //        base2 = 0;
    //        [attriStr enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attriStr.length)
    //                                                options:0
    //                                             usingBlock:^(id value, NSRange range, BOOL *stop) {
    //                                                 //检查类型是否是自定义NSTextAttachment类
    //                                                 if (value && [value isKindOfClass:[NSTextAttachment class]]) {
    //                                                     if (base2 == i) {
    //                                                         NSString *string = [NSString stringWithFormat:@"Attachment%lu.png",(unsigned long)i];
    //                                                         NSAttributedString *needAddString = [[NSAttributedString alloc]initWithString:string];
    //                                                         [attriStr insertAttributedString:needAddString atIndex:range.location];
    //                                                         *stop = YES;
    //                                                     }
    //                                                     base2++;
    //                                                 }
    //                                             }];
    //    }
    //
    //    [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, _popTextView.text.length)];
    
    
    //    ====
    //    NSString *htmlString;
    //    NSDictionary *exportParams = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]
    //                                   };
    //    NSData *htmlData = [htmlAttributeString dataFromRange:NSMakeRange(0, htmlAttributeString.length) documentAttributes:exportParams error:nil];
    //    htmlString = [[NSString alloc] initWithData:htmlData encoding: NSUTF8StringEncoding];
    //
    //    return htmlString;
    
    NSDictionary *tempDic = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                              NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]};
    NSData *htmlData = [htmlAttributeString dataFromRange:NSMakeRange(0, htmlAttributeString.length)
                                       documentAttributes:tempDic
                                                    error:nil];
    return [[NSString alloc] initWithData:htmlData
                                 encoding:NSUTF8StringEncoding];
    
}

//禁用emoji
- (NSString *)disable_emoji:(NSString *)text{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}


-(void)saveRichTextview
{
    //    NSMutableAttributedString * context = [[NSMutableAttributedString alloc]init];
    //    context = _popTextView.textStorage;//把文本输入框内容赋给存储
    //
    //    NSData *data = [context dataFromRange:NSMakeRange(0, context.length) documentAttributes:@{NSDocumentTypeDocumentAttribute:NSRTFDTextDocumentType} error:nil];   //将 NSAttributedString 转为NSData
    //    [[NSUserDefaults standardUserDefaults]setObject:data forKey:@"saveRichTextView"];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)readRichTextview
{
    //    NSData *outputData = [[NSUserDefaults standardUserDefaults] objectForKey:@"saveRichTextView"];
    //
    //    NSAttributedString *temp = [[NSAttributedString alloc] initWithData:outputData options:@{NSDocumentTypeDocumentAttribute : NSRTFDTextDocumentType} documentAttributes:nil error:nil];     //读取
    //
    //    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithAttributedString:temp];
    //
    //    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, _popTextView.text.length)];
    //    [att enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, att.length)
    //                         options:0
    //                      usingBlock:^(id value, NSRange range, BOOL *stop) {
    //                          //检查类型是否是自定义NSTextAttachment类
    //                          if (value && [value isKindOfClass:[NSTextAttachment class]] ) {
    //                              NSTextAttachment *textAttachment = [[NSTextAttachment alloc]initWithData:nil ofType:nil];
    //                              [textAttachment setImage:value];
    //                              textAttachment.bounds = CGRectMake(24, 0, self.popTextView.frame.size.width - 48, [self getImgHeightWithImg:value]);
    //                          }
    //                      }];
    
    //    [_popTextView  setAttributedText:att];
    //    [_record setAttributedText:att];
}


- (void)handleKeyboardDidShow:(NSNotification*)paramNotification
{
    //获取键盘的高度
    //获取键盘高度
    NSValue *keyboardRectAsObject=[[paramNotification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect;
    [keyboardRectAsObject getValue:&keyboardRect];
    self.popTextView.contentInset=UIEdgeInsetsMake(0, 0,keyboardRect.size.height, 0);
    self.popTextviewRight.contentInset=UIEdgeInsetsMake(0, 0,keyboardRect.size.height, 0);
}

- (void)handleKeyboardDidHidden
{
    self.popTextView.contentInset=UIEdgeInsetsZero;
    self.popTextviewRight.contentInset=UIEdgeInsetsZero;
}


-(NSData *)zipNSDataWithImage:(UIImage *)sourceImage{
    //进行图像尺寸的压缩
    CGSize imageSize = sourceImage.size;//取出要压缩的image尺寸
    CGFloat width = imageSize.width;    //图片宽度
    CGFloat height = imageSize.height;  //图片高度
    //1.宽高大于1280(宽高比不按照2来算，按照1来算)
    if (width>1280||height>1280) {
        if (width>height) {
            CGFloat scale = height/width;
            width = 1280;
            height = width*scale;
        }else{
            CGFloat scale = width/height;
            height = 1280;
            width = height*scale;
        }
        //2.宽大于1280高小于1280
    }else if(width>1280||height<1280){
        CGFloat scale = height/width;
        width = 1280;
        height = width*scale;
        //3.宽小于1280高大于1280
    }else if(width<1280||height>1280){
        CGFloat scale = width/height;
        height = 1280;
        width = height*scale;
        //4.宽高都小于1280
    }else{
    }
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [sourceImage drawInRect:CGRectMake(0,0,width,height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //进行图像的画面质量压缩
    NSData *data=UIImageJPEGRepresentation(newImage, 1.0);
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(newImage, 0.7);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(newImage, 0.8);
        }else if (data.length>200*1024) {
            //0.25M-0.5M
            data=UIImageJPEGRepresentation(newImage, 0.9);
        }
    }
    return data;
}


@end

