//
//  ChooseClassCotroller.m
//  PadEvaluate
//
//  Created by hzth-mac3 on 15/12/17.
//  Copyright © 2015年 hzth-mac3. All rights reserved.
//

#import "ChooseClassCotroller.h"
#import "DropDownMenu.h"
#import "Public.h"
#import "TYHHttpTool.h"
#import "MJExtension.h"
#import "ClassModel.h"

@interface ChooseClassCotroller ()

@property (nonatomic, strong) NSMutableArray * data;

@end
@implementation ChooseClassCotroller
- (void)initData {
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    _loginName = [defaults valueForKey:USER_DEFAULT_LOGINNAME];
    _passWord = [defaults valueForKey:USER_DEFAULT_PASSWORD];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    self.data = [NSMutableArray arrayWithArray:_classData];
    [self.tableView reloadData];
    NSLog(@"self.data = %@",self.data);
}
//    [self getClassesData];
//}
//- (void)getClassesData {
//
//    NSString * urlStr  = [NSString stringWithFormat:@"%@/tp/mobile/teacherPlatform!getEclasses.action?sys_auto_authenticate=true&sys_username=%@&sys_password=%@",BaseUrl,_loginName,_passWord];
//    NSLog(@"urlStrClass === %@",urlStr);
//
//    [TYHHttpTool get:urlStr params:nil success:^(id json) {
//       
//        NSLog(@"json == %@",json);
//        _data = [ClassModel mj_objectArrayWithKeyValuesArray:json];
//       
//        [self.tableView reloadData];
//    } failure:^(NSError *error) {
//        
//    }];
//}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_delegate) {
        
        [_delegate getDataArrayCount:_data];
        
    }
    NSLog(@"%d",_data.count);
    return _data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"classCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:ID];
    }
    // title
    ClassModel * model = _data[indexPath.row];
    
    cell.detailTextLabel.text = model.name;
    
    cell.contentView.backgroundColor = [UIColor colorWithRed:24 / 255.0 green:171 / 255.0 blue:142/ 255.0 alpha:0.6];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.drop) {
        [self.drop disMiss];
    }
    if (_delegate) {
        
        ClassModel * model = _data[indexPath.row];
        [_delegate selectAtIndexPath:indexPath title:model.name];
    }
    
}
@end
