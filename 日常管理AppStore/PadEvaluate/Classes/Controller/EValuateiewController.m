//
//  EValuateiewController.m
//  PadEvaluate
//
//  Created by hzth-mac3 on 15/12/15.
//  Copyright © 2015年 hzth-mac3. All rights reserved.
//

#import "EValuateiewController.h"
#import "UpScoreViewController.h"
#import "EValueteController.h"
#import "TYHHttpTool.h"
#import "Public.h"
#import "MJExtension.h"
#import "WorkListModal.h"
#import "NewEvaluateModel.h"
#import "OnceEnterModel.h"


@interface EValuateiewController ()

@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSUserDefaults * userDefault;

@property(nonatomic,retain)NSMutableArray *dataSource;

@end

@implementation EValuateiewController


- (void)initData {

    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    _loginName = [defaults valueForKey:USER_DEFAULT_LOGINNAME];
    _passWord = [defaults valueForKey:USER_DEFAULT_PASSWORD];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    
    self.adminName.text = self.model.name;
    [self initTableView];
    // 获取列表数据
    
//    UIView * clearview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
//    clearview.backgroundColor = [UIColor TabBarColorGreen];
//    clearview.userInteractionEnabled = NO;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
//                                             initWithCustomView:clearview];

    self.title = @"日常管理";
    
    
    
    
}

- (void)getTableviewData {

    
    NSString * urlStr = [NSString stringWithFormat:@"%@/tp/mobile/teacherPlatform!getUserTask.action?sys_auto_authenticate=true&sys_username=%@&sys_password=%@",BaseUrl,_loginName,_passWord];
    NSLog(@"%@",urlStr);
    
    //新加  taskFlag  0代表没有任务  1代表有任务
    
    
    self.dataArray = [[NSMutableArray alloc] init];
    [TYHHttpTool get:urlStr params:nil success:^(id json) {
        
       self.dataArray = [WorkListModal mj_objectArrayWithKeyValuesArray:json];
//        NSLog(@"json === %@",json);
        
        [self.newsTabelView reloadData];
        
        NSLog(@"self.dataArray == %@ ",self.dataArray);
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)initTableView {

    self.newsTabelView.delegate = self;
    self.newsTabelView.dataSource = self;
    [self.newsTabelView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.newsTabelView.rowHeight = 66;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString * strlist = [NSString stringWithFormat:@"任务列表(%ld)",(long)self.dataArray.count];
    _listCount.text = strlist;
    
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString * idenfitier = @"secondCell";
    SecondCell *cell = (SecondCell *)[tableView dequeueReusableCellWithIdentifier:idenfitier];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:idenfitier forIndexPath:indexPath];
    }
    WorkListModal * model = _dataArray[indexPath.row];
    cell.evaluateName.text = model.name;
    cell.stepName.text = [NSString stringWithFormat:@"%@",model.stepName];
    cell.stepName.textColor = [UIColor TabBarColorGreen];
    
//    cell.stepName.frame = CGRectMake(cell.frame.size.width - cell.stepName.frame.size.width - 30, cell.stepName.frame.origin.y, cell.stepName.frame.size.width, cell.stepName.frame.size.height);
    
    if ([model.submitNum isEqualToString:@"0"]) {
        cell.unEvaluate.text = @"完成调研数量:0";
    } else {
        cell.unEvaluate.text = [NSString stringWithFormat:@"完成调研数量:%@",model.submitNum];
        cell.unEvaluate.textColor = [UIColor TabBarColorGreen];
    }
    cell.timeLabel.text = [NSString stringWithFormat:@"%@ ~ %@",model.startDate,model.endDate];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [self clearNSUserDefaults];
    WorkListModal * model = _dataArray[indexPath.row];

    
    EValueteController *main = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EValueteController"];
    
    if ([self isBlankString:model.evaluateItemId]) {
        NSString * urlStr = [NSString stringWithFormat:@"%@/tp/mobile/teacherPlatform!getEvaluateItemTree.action?sys_auto_authenticate=true&sys_username=%@&sys_password=%@&taskID=%@",BaseUrl,_loginName,_passWord,model.taskId];
        
        [TYHHttpTool get:urlStr params:nil success:^(id json) {
            
            main.evaluateTableArray = [NSMutableArray arrayWithArray:[self handleContactList:[json objectForKey:@"evaluateItems"]]];
            
            main.taskID = model.taskId;
            //临时注释
//            main.shouldMutipleTap = ![model.taskFlag integerValue];
            main.shouldMutipleTap = YES;
            
            [self.navigationController pushViewController:main animated:YES];
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        return;
    }
    
    main.evaluateItemId = model.evaluateItemId;
        NSMutableArray *tmpArray = [NSMutableArray array];
    NewEvaluateModel *tmpModel = [NewEvaluateModel new];
    tmpModel.name = model.name;
//    tmpModel.id = model.taskId;
    
    tmpModel.id = model.evaluateItemId.length ? model.evaluateItemId : @"";
    [tmpArray addObject:tmpModel];
    
        main.evaluateTableArray = tmpArray;
        main.taskID = model.taskId;
        [self.navigationController pushViewController:main animated:YES];
}

#pragma mark - Navigation

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getTableviewData];
}

- (IBAction)quitLogin:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)evaluate:(id)sender {
    
    
    
    
    NSString * urlStr = [NSString stringWithFormat:@"%@/tp/mobile/teacherPlatform!getEvaluateItemTree.action?sys_auto_authenticate=true&sys_username=%@&sys_password=%@",BaseUrl,_loginName,_passWord];
    NSLog(@"%@",urlStr);
    
    
    [TYHHttpTool get:urlStr params:nil success:^(id json) {
        
        EValueteController *main = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EValueteController"];
        
        main.evaluateTableArray = [NSMutableArray arrayWithArray:[self handleContactList:[json objectForKey:@"evaluateItems"]]];
        ;
        main.shouldMutipleTap = YES;
        
        [self.navigationController pushViewController:main animated:YES];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
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

-(void)clearNSUserDefaults
{
    //清空两个TextView的值
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"saveImageDataArray"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"saveImageNameArray"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"saveImageNoteArray"];
    
    [[NSUserDefaults standardUserDefaults]setObject:[NSMutableArray array] forKey:@"saveImageNameArray"];
    [[NSUserDefaults standardUserDefaults]setObject:[NSMutableArray array] forKey:@"saveImageNoteArray"];
    [[NSUserDefaults standardUserDefaults]setObject:[NSMutableArray array] forKey:@"saveImageDataArray"];
    
//    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"defaultSelectIndexPathRow"];
//    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"defaultSelectIndexPathRow"];
//    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"defaultSelectIndexPathID"];
//    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"defaultSelectIndexPathID"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


#pragma mark - -----
- (NSMutableArray *)handleContactList:(NSMutableArray *)array;
{
    NSMutableArray *totalArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    
    static NSUInteger indentation = 0;
    
    for (NSDictionary *dic in array) {
        NewEvaluateModel *contactModel = [[NewEvaluateModel alloc] init];
        contactModel.IndentationLevel = indentation;
        contactModel.id = dic[@"id"];
        contactModel.name = dic[@"name"];
        contactModel.parentId = dic[@"parentId"];

        NSMutableArray *childsArray = [dic objectForKey:@"childs"];
        if (childsArray && childsArray.count > 0) {
            contactModel.childs = [self addSubContact:childsArray withContactModel:contactModel andIndentation:indentation];
        }
        
//        NSMutableArray *userListArray = [dic objectForKey:@"userList"];
//        if (userListArray && userListArray.count >0) {
//            contactModel.userList = [self addSubUserList:userListArray withContactModel:contactModel andIndentation:indentation];
//        }
        
        [totalArray addObject:contactModel];
    }
    
    return totalArray;
}

- (NSMutableArray *)addSubContact:(NSMutableArray *)childsArray withContactModel:(NewEvaluateModel *)model andIndentation:(NSUInteger)indentation
{
    indentation ++;
    model.childs = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSDictionary *dic in childsArray) {
        NSString *parentId = [dic objectForKey:@"parentId"];
        if ([model.id isEqualToString:parentId]) {
            NewEvaluateModel *contactModel = [[NewEvaluateModel alloc] init];
            contactModel.IndentationLevel = indentation;
            contactModel.id = [dic objectForKey:@"id"];
            
            contactModel.name = [dic objectForKey:@"name"];
            contactModel.parentId = [dic objectForKey:@"parentId"];
            
            [model.childs addObject:contactModel];
            
            NSMutableArray *subArray = [dic objectForKey:@"childs"];
            if (subArray && subArray.count > 0) {
                contactModel.childs = [self addSubContact:subArray withContactModel:contactModel andIndentation:indentation];
            }
            else
            {
                contactModel.level = @"Inside";
            }
//            NSMutableArray *userListArray = [dic objectForKey:@"userList"];
//            if (userListArray && userListArray.count >0) {
//                contactModel.userList = [self addSubUserList:userListArray withContactModel:contactModel andIndentation:indentation];
//            }
        }
    }
    return model.childs;
}


- (NSMutableArray *)addSubUserList:(NSMutableArray *)userListArray withContactModel:(NewEvaluateModel *)model andIndentation:(NSUInteger)indentation
{
    indentation ++;
    model.userList = [[NSMutableArray alloc] initWithCapacity:0];
    //    model.userList = [AssetListDetailsModel objectArrayWithKeyValuesArray:userListArray];
    for (NSDictionary *userDic in userListArray) {
        NewEvaluateDetailModel *userModel = [[NewEvaluateDetailModel alloc] init];
//        userModel.IndentationLevel = indentation;
        userModel.IndentationLevel = 100;
        userModel.id = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"id"]];
        userModel.name = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"name"]];
        [model.userList addObject:userModel];
        
    }
    return model.userList;
}

@end
