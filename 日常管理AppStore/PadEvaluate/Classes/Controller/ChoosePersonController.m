//
//  ChoosePersonController.m
//  PadEvaluate
//
//  Created by hzth-mac3 on 15/12/18.
//  Copyright © 2015年 hzth-mac3. All rights reserved.
//

#import "ChoosePersonController.h"
#import "SecondDropMenu.h"
#import "Public.h"
#import "TYHHttpTool.h"
#import "PersonModel.h"
#import "MJExtension.h"
#import "UIView+Toast.h"

@interface ChoosePersonController ()

@property (nonatomic, strong) NSMutableArray * data;

@end
@implementation ChoosePersonController
- (void)initData {
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    _loginName = [defaults valueForKey:USER_DEFAULT_LOGINNAME];
    _passWord = [defaults valueForKey:USER_DEFAULT_PASSWORD];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    self.data = [NSMutableArray arrayWithArray:_personData];
    [self.tableView reloadData];
    NSLog(@"self.data = %@",self.data);
   
//    [self getPersonData];
    
}
/*
 获取被评价教师
 /tp/mobile/teacherPlatform!getTeachers.action
 参数:
 eclassId 班级id
 */
//- (void)getPersonData {
//    
//    NSString * urlStr  = [NSString stringWithFormat:@"%@/tp/mobile/teacherPlatform!getTeachers.action?sys_auto_authenticate=true&sys_username=%@&sys_password=%@&eclassId=%@",BaseUrl,_loginName,_passWord,self.ID];
//    
//    NSLog(@"urlStrPerson === %@",urlStr);
//    
//    [TYHHttpTool get:urlStr params:nil success:^(id json) {
//       
//        NSLog(@" person json == %@",json);
//        
//        _data = [PersonModel mj_objectArrayWithKeyValuesArray:json];
//        
//        [self.tableView reloadData];
//        
//    } failure:^(NSError *error) {
//        
//    }];
//    
//    
//}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_delegate) {
        [_delegate getDataArrayPersonCount:_data];
        if (!_personData.count) {
            [self.view makeToast:@"请先选择被评价班级" duration:1.5 position:CSToastPositionCenter];
        }
    }
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
//    tableView.bounces = NO;
    
    static NSString *ID = @"personCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    // title
    PersonModel * model = _data[indexPath.row];
    cell.detailTextLabel.text = model.name;
    
    cell.contentView.backgroundColor = [UIColor colorWithRed:24 / 255.0 green:171 / 255.0 blue:142/ 255.0 alpha:0.6];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.drops) {
        [self.drops disunclear];
    }
    if (_delegate) {
        PersonModel * model = _data[indexPath.row];
        [_delegate selectPersonAtIndexPath:indexPath title:model.name];
    }
    
}
@end
