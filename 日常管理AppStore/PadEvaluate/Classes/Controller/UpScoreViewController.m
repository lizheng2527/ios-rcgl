//
//  UpScoreViewController.m
//  PadEvaluate
//
//  Created by hzth-mac3 on 15/12/15.
//  Copyright © 2015年 hzth-mac3. All rights reserved.
//

#import "UpScoreViewController.h"
#import "Public.h"
#import "TYHHttpTool.h"
#import "MJExtension.h"
#import "OnceEnterModel.h"
#import "LifeModel.h"
#import "AFNetworking.h"
#import "UIView+Toast.h"
#import "MBProgressHUD.h"
#import "ZXCollectionCell.h"

#import "LifeModel.h"
#import "YYCache.h"

#import "EvaluateModel.h"
#import "ExamModel.h"

#import "UploadScoreHeaderView.h"
#import "UploadImageHeaderView.h"

#import "TZImagePickerController.h"

#import "JCAlertController.h"
#import "NSData+Compress.h"


#define NUMBERS @"0123456789."
#define fDeviceWidth self.upImageCollectionView.frame.size.width
#define fDeviceHeight self.upImageCollectionView.frame.size.width


@interface UpScoreViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,ZXCollectionCellDelegate,UITextViewDelegate,TZImagePickerControllerDelegate>


@property (nonatomic, strong) NSMutableArray * newsArray;
@property (nonatomic, strong) NSMutableArray * jsonArray;
@property (nonatomic, assign) int sumScore;
@property (nonatomic, copy) NSString * valueStr;
@property (nonatomic, copy) NSString * responsePicId;
@property (nonatomic, copy) NSMutableArray * imageArray;
@property (nonatomic, copy) UITextField * slider;
@property (nonatomic, copy) NSDictionary * dict1;

@property (nonatomic, copy) NSDictionary * dict2;

@property (nonatomic, copy) NSDictionary * dict3;

@property (nonatomic, copy) NSDictionary * dict4;
@property (nonatomic, strong) OnceEnterModel * models;
//@property (nonatomic, assign) int

@property(nonatomic,retain)NSMutableArray *exampleArray;
@end

@implementation UpScoreViewController
{
    NSMutableArray *uploadImageNameArray;
    NSMutableArray *uploadImageNoteArray;
    NSMutableArray *uploadImageArray;
    MBProgressHUD *hud;
    
    NSMutableArray *tempTextFieldStringArray;
    
    NSMutableArray *sumArray;
    NSMutableDictionary *sumHeaderViewDic;
    
    NSInteger tempRow;
    NSUInteger tempSection;
    UIBarButtonItem * rightItem;
    
    
}



static int sum = 0;

- (NSMutableArray *)imageArray {
    
    if (_imageArray == nil) {
        _imageArray = [[NSMutableArray alloc] init];
    }
    return _imageArray;
}

- (NSMutableArray *)jsonArray {
    
    if (_jsonArray == nil) {
        _jsonArray = [[NSMutableArray alloc] init];
    }
    return _jsonArray;
}



- (NSMutableArray *)newsArray {
    
    if (_newsArray == nil) {
        _newsArray = [[NSMutableArray alloc] init];
    }
    else _newsArray =[NSMutableArray arrayWithObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"saveNewsArrayPerDismissView"]];
    return _newsArray;
}
- (void)initData {
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    _loginName = [defaults valueForKey:USER_DEFAULT_LOGINNAME];
    _passWord = [defaults valueForKey:USER_DEFAULT_PASSWORD];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUploadArray];
    
    // Do any additional setup after loading the view.
    
    self.upCollectionView.delegate = self;
    self.upCollectionView.dataSource = self;
    self.upCollectionView.tag = 10000;
    
    self.unitCollection.delegate = self;
    self.unitCollection.dataSource = self;
    self.unitCollection.tag = 100001;
    
    rightItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:(UIBarButtonItemStylePlain) target:self action:@selector(updownNetData)];
    self.navigationItem.rightBarButtonItem = rightItem;
    _comment.delegate = self;
    
    _exampleArray = [NSMutableArray array];
    
    
    
//    YYCache *cache = [YYCache cacheWithName:@"saveExamDataCACHE"];
//    id value = [cache objectForKey:@"saveExamDataArray"];
    
//    NSMutableArray *vuale=[NSMutableArray arrayWithObject:[cache objectForKey:@"saveExamDataArray"]] ;
    
    
    NSMutableArray *tempExamModelArray = [NSMutableArray array];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"saveExamDataArray"]];

        for (NSData  * data in array) {
            ExamModel *model = [[ExamModel alloc]init];
            model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            
            if (model.imageArray.count) {
                UIImage *image = model.imageArray.lastObject;
                if (image.size.width != 54 ) {
                    [model.imageArray addObject:[UIImage imageNamed:@"icon_add_normal"]];
                }
            }
            [tempExamModelArray addObject:model];
        }
    
    if (tempExamModelArray.count) {
        _exampleArray = [NSMutableArray arrayWithArray:tempExamModelArray];
        [_upImageCollectionView reloadData];
        
    }
    
    //    rightItem.enabled = NO;
    
    [self getEvaluateRecord];
    
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(textViewDidTap)];
    [_comment addGestureRecognizer:ges];
}
- (void)getEvaluateRecord {
    
    sumHeaderViewDic = [NSMutableDictionary dictionary];
    
    for (LessonModel *model in self.courseInfoArray) {
        if([self.courseType isEqualToString:model.name])
            self.courseType = model.code;
    }
    
    NSDictionary *parameter=@{@"sys_auto_authenticate": @"true",@"sys_username": _loginName,@"sys_password": _passWord,@"evaluateItemId":_evaluateItemId,@"classId":_classId,@"teacherId":_personId,@"researchDate":self.researchDate.length?self.researchDate:@"",@"courseType":self.courseType.length?self.courseType:@"",@"lesson":[self getLessonTime],@"investigationUser":self.taskID.length?self.taskID:@""};
    
    
    [TYHHttpTool gets:[NSString stringWithFormat:@"%@/tp/mobile/teacherPlatform!canDoEvaluate.action",BaseUrl] params:parameter success:^(id json) {
        if (![[[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding] isEqualToString:@"0"]) {
            
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"这节课您已经评价过该老师,不能再做出评价" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        else
        {
            
            NSString * urlStr = [NSString stringWithFormat:@"%@/tp/mobile/teacherPlatform!getScoreStandards.action?sys_auto_authenticate=true&sys_username=%@&sys_password=%@&evaluateItemId=%@&eclassId=%@&taskId=%@",BaseUrl,_loginName,_passWord,_evaluateItemId,_classId,self.taskID.length?self.taskID:@""];
            
            NSLog(@"urlStr == %@",urlStr);
            
            [TYHHttpTool get:urlStr params:nil success:^(id json) {
                
                NSMutableArray *handlerArray = [NSMutableArray arrayWithArray:[UpScoreModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"evaluateItems"]]];
                for (UpScoreModel *model in handlerArray) {
                    model.scoreStandardsModelArray = [NSMutableArray arrayWithArray:[OnceEnterModel mj_objectArrayWithKeyValuesArray:model.scoreStandards]] ;
                    model.totalScoreStandardsModelArray = [NSMutableArray arrayWithArray:[OnceEnterModel mj_objectArrayWithKeyValuesArray:model.totalScoreStandards]] ;
                }
                _newsArray = [NSMutableArray arrayWithArray:handlerArray];
                
                sumArray = [NSMutableArray array];
                [_newsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [sumArray addObject:@"0"];
                }];
                
                
                if (tempTextFieldStringArray.count) {
                    [_newsArray enumerateObjectsUsingBlock:^(UpScoreModel *upModel, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        [upModel.scoreStandardsModelArray enumerateObjectsUsingBlock:^(OnceEnterModel *onceModel, NSUInteger idx2, BOOL * _Nonnull stop) {
                            //                            onceModel.textFieldString = tempTextFieldStringArray[idx][idx2];
                            
                            for (NSString *evaID in _evaluateIDArray) {
                                
                                if ([evaID isEqualToString: upModel.id]) {
                                    
                                    for (NSDictionary *dic in tempTextFieldStringArray) {
                                        
                                        if([[dic objectForKey:evaID] count])
                                        {
                                            NSArray *textFieldStringArray = [dic valueForKey:evaID];
                                            onceModel.textFieldString = textFieldStringArray[idx2];
                                        }
                                    }
                                }
                            }
                            
                            NSDictionary * dict1 = @{@"evaluateStandard":@{
                                                             @"id": onceModel.id
                                                             },
                                                     @"score": [NSString stringWithFormat:@"%ld",(long)[onceModel.textFieldString integerValue]]
                                                     //                                                       @"level": @"A"
                                                     };
                            self.dict1  = dict1;
                            [self.jsonArray addObject:self.dict1];
                            
                        }];
                        
                        [tempTextFieldStringArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx3, BOOL * _Nonnull stop) {
                            
                            NSDictionary *dic = obj;
                            if ([[dic allKeys][0] isEqualToString:upModel.id]) {
                                sum = 0;
                                for (NSString *string in [dic objectForKey:[dic allKeys][0]]) {
                                    sum += [string integerValue];
                                }
                                
                                [sumArray replaceObjectAtIndex:idx withObject:[NSString stringWithFormat:@"%d",sum]];
                            }
                        }];
                        
                    }];
                }

                [self.upCollectionView reloadData];
            } failure:^(NSError *error) {
                
            }];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

- (void)updownNetData {
    
    NSLog(@"_item = %@, _content = %@, _comment =%@, _evaluateItemId = %@, _personId= %@, _classId = %@",_item,_content,_comment.text,_evaluateItemId,_personId,_classId);
    
    for (UpScoreModel *upModel in _newsArray) {
        for (OnceEnterModel *onceModel in upModel.scoreStandardsModelArray) {
            if ([self isBlankString:onceModel.textFieldString]) {
                [self.view makeToast:@"有部分评分项目未填写" duration:1.5 position:CSToastPositionCenter];
                return;
            }
        }
    }
    
    
    if ([self isBlankString:_comment.text]) {
        [self.view makeToast:@"请输入评语" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    NSMutableArray *picIdArray = [NSMutableArray array];
    NSMutableString *picString = [NSMutableString string];
    if (![self isBlankString:_item] && ![self isBlankString:_content] && ![self isBlankString:_comment.text] && ![self isBlankString:_evaluateItemId] && ![self isBlankString:_personId] && ![self isBlankString:_classId] &&_jsonArray.count>0) {
        
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelFont = [UIFont systemFontOfSize:12];
        hud.labelText = @"正在提交数据";
        hud.detailsLabelText = @"上传数据包含图片时请耐心等待";
        rightItem.enabled = NO;
        
        __block NSMutableArray *tempExamArray = [NSMutableArray arrayWithCapacity:0];
        
        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
        
        [_exampleArray enumerateObjectsUsingBlock:^(ExamModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ExamModel *objNew = [ExamModel new];
            objNew.name = obj.name;
            objNew.note = obj.note;
            objNew.imageArray = [NSMutableArray array];
            [objNew.imageArray addObjectsFromArray:obj.imageArray];
            [tempArray addObject:objNew];
        }];
        
        
        [tempArray enumerateObjectsUsingBlock:^(ExamModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.imageArray.count > 1) {
                [obj.imageArray removeLastObject];
                [tempExamArray addObject:obj];
            }
        }];
        
        
        
        for (ExamModel *model in tempExamArray) {
            if (model.imageArray.count) {
                if ([self isBlankString:model.name] || [self isBlankString:model.note]) {
                    [self.view makeToast:@"案例名称和案例说明不能为空白,请仔细检查" duration:1.5 position:CSToastPositionCenter];
                    [hud removeFromSuperview];
                    rightItem.enabled = YES;
                    return;
                }
            }
        }
        
        
        for (int i = 0; i < tempExamArray.count; i++) {
            
            ExamModel  *obj = tempExamArray[i];
            if (obj.imageArray.count > 0 ) {
                
                NSString * urlStr = [NSString stringWithFormat:@"%@/tp/mobile/teacherPlatform!saveEvaluateExample.action?sys_auto_authenticate=true&sys_username=%@&sys_password=%@",BaseUrl,_loginName,_passWord];
                
                NSMutableDictionary * params = [NSMutableDictionary dictionary];
                params[@"name"]= obj.name;
                params[@"note"]= obj.note;
                params[@"uploadFileNames"] = [NSString stringWithFormat:@"image%lu.png",(unsigned long)i];
                
                __block NSMutableArray *imageDataArray = [NSMutableArray array];
                [obj.imageArray enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    
                    UIImage *imageNew = image;
                    //设置image的尺寸
                    CGSize imagesize = imageNew.size;
                    imageNew = [self imageCompressForWidth:imageNew targetWidth:imagesize.width];
                    NSData *data = UIImageJPEGRepresentation(imageNew,0.8);
                    [imageDataArray addObject:data];
                }];
                
                AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
                [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                    
                    [imageDataArray enumerateObjectsUsingBlock:^(NSData *data, NSUInteger idxx, BOOL * _Nonnull stop) {
                        [formData appendPartWithFileData:data name:@"uploadFiles" fileName:[NSString stringWithFormat:@"image%lu.png",(unsigned long)idxx] mimeType:@"image/png"];
                    }];
                    
                } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"上传成功responseObject == %@",responseObject);
                    _responsePicId = responseObject[@"id"];
                    [picIdArray addObject:_responsePicId];
                    
                    [self.view makeToast:[NSString stringWithFormat:@"上传案例图片%d成功",i+1] duration:1 position:nil];
                    
                    if (picIdArray.count == tempExamArray.count) {
                        for (NSString *picId in picIdArray) {
                            [picString appendFormat:@"%@,",picId];
                        }
                        _responsePicId = picString;
                            [self summit];
                        }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [self.view makeToast:[NSString stringWithFormat:@"上传案例图片%d失败",i+1] duration:1 position:nil];
                    [hud removeFromSuperview];
                    
                    rightItem.enabled = YES;
                }];
            }
        }
            
        
        
//        dispatch_sync(dispatch_queue_create("zy", DISPATCH_QUEUE_SERIAL), ^{
//            {
//                [tempExamArray enumerateObjectsUsingBlock:^(ExamModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    if (obj.imageArray.count > 0 ) {
//
//                        NSString * urlStr = [NSString stringWithFormat:@"%@/tp/mobile/teacherPlatform!saveEvaluateExample.action?sys_auto_authenticate=true&sys_username=%@&sys_password=%@",BaseUrl,_loginName,_passWord];
//
//                        NSMutableDictionary * params = [NSMutableDictionary dictionary];
//                        params[@"name"]= obj.name;
//                        params[@"note"]= obj.note;
//                        params[@"uploadFileNames"] = [NSString stringWithFormat:@"image%lu.png",(unsigned long)idx];
//
//                        __block NSMutableArray *imageDataArray = [NSMutableArray array];
//                        [obj.imageArray enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL * _Nonnull stop) {
//
//                            UIImage *imageNew = image;
//                            //设置image的尺寸
//                            CGSize imagesize = imageNew.size;
//                            imageNew = [self imageCompressForWidth:imageNew targetWidth:imagesize.width];
//                            NSData *data = UIImageJPEGRepresentation(imageNew,0.8);
//                            [imageDataArray addObject:data];
//                        }];
//
//
//                        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
//                        [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//
//                            [imageDataArray enumerateObjectsUsingBlock:^(NSData *data, NSUInteger idxx, BOOL * _Nonnull stop) {
//                                [formData appendPartWithFileData:data name:@"uploadFiles" fileName:[NSString stringWithFormat:@"image%lu.png",(unsigned long)idxx] mimeType:@"image/png"];
//                            }];
//
//                        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//
//                            NSLog(@"上传成功responseObject == %@",responseObject);
//                            _responsePicId = responseObject[@"id"];
//                            [picIdArray addObject:_responsePicId];
//
//                            [self.view makeToast:[NSString stringWithFormat:@"上传案例图片%lu成功",idx+1] duration:1 position:nil];
//
//                            if (picIdArray.count == tempExamArray.count) {
//                                for (NSString *picId in picIdArray) {
//                                    [picString appendFormat:@"%@,",picId];
//                                }
//                                _responsePicId = picString;
//                                [self summit];
//                            }
//
//                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                            [self.view makeToast:[NSString stringWithFormat:@"上传案例图片%lu失败",idx+1] duration:1 position:nil];
//                            [hud removeFromSuperview];
//                        }];
//
//                    }
//
//                }];
//            }
//        });

        if (!tempExamArray.count) {
            _responsePicId = @"";
            [self summit];
        }
        
    } else {
        [self.view makeToast:@"有部分项目未填写,请检查本页面和前页面的填写数据" duration:2 position:CSToastPositionCenter];
        rightItem.enabled = NO;
    }
    
}


-(void)summit
{
    [self.view endEditing:YES];
    
    for (LessonModel *model in self.courseInfoArray) {
        if([self.courseType isEqualToString:model.name])
            self.courseType = model.code;
    }
    
    //        NSArray *numArray1 = [self.lesson componentsSeparatedByString:@"第"];
    //        NSArray *numArray2= [numArray1[1] componentsSeparatedByString:@"课节"];
    //        self.lesson = numArray2[0];
    
    NSMutableString *evaluateItemIdsString = [NSMutableString string];
    for (UpScoreModel *model in _newsArray) {
        if (_newsArray.count == 1) {
            [evaluateItemIdsString appendFormat:@"%@",model.id];
        }else
            [evaluateItemIdsString appendFormat:@"%@,",model.id];
    }
    NSMutableString *sumScoresString = [NSMutableString string];
    for (NSString *string in sumArray) {
        if (sumArray.count == 1) {
            [sumScoresString appendFormat:@"%@",string];
        }else
            [sumScoresString appendFormat:@"%@,",string];
    }
    

    NSDictionary * dict = @{@"teacherEvaluateRecord":@{
                                    @"subject":self.subject.length?self.subject:@"",
                                    @"teacherFeature":self.teacherFeature.length?self.teacherFeature:@"",
                                    @"courseType":self.courseType.length?self.courseType:@"",
                                    @"researchDate":self.researchDate.length?self.researchDate:@"",
                                    @"lesson":self.lesson,
                                    
                                    @"title":_item,
//                                    @"content":[self emojiEncode:_contentAttributedString],
                                    @"content":_content.length?_content:@"",
                                    @"comment":_comment.text.length?_comment.text:@"",
                                    @"simpleEvaluate":self.simpleEvaluate.length?[self emojiEncodeNSString:self.simpleEvaluate]:@"",
                                    @"teacher":@{
                                            @"id":_personId
                                            },
                                    
                                    @"eclass":@{
                                            @"id":_classId
                                            },
                                    @"investigationUser":@{
                                            @"id":_taskID.length?_taskID:@""
                                            }
                                    },
                            @"teacherScores":_jsonArray,
                            
                            @"exampleIds": _responsePicId,
                            
                            @"evaluateItem":evaluateItemIdsString,
                            
                            @"sumScore":sumScoresString,
                            
                            @"fileNames":@"Attachment.png",
                            };
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    //        params[@"sys_auto_authenticate"] = @"ture";
    //        params[@"sys_username"] = _loginName;
    //        params[@"sys_password"] = _passWord;
    params[@"jsonData"] = jsonString;
    
    NSLog(@"params  ===   %@",params);
    
    NSString * urlStr = [NSString stringWithFormat:@"%@/tp/mobile/teacherPlatform!saveTeacherEvaluateRecord.action?sys_auto_authenticate=true&sys_username=%@&sys_password=%@",BaseUrl,_loginName,_passWord];

        __block NSMutableArray *imageDataArray = [NSMutableArray array];
        [_textviewImageArray enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData *data = UIImagePNGRepresentation(image);
            [imageDataArray addObject:data];
        }];
    
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", @"text/plain",nil]];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
        [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            [imageDataArray enumerateObjectsUsingBlock:^(NSData *data, NSUInteger idxx, BOOL * _Nonnull stop) {
                [formData appendPartWithFileData:data name:@"uploadFiles" fileName:[NSString stringWithFormat:@"image%lu.png",(unsigned long)idxx] mimeType:@"image/png"];
            }];
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString * dataAJax = [[NSString  alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if ([dataAJax isEqualToString:@"ok"]) {
                [hud removeFromSuperview];
                _comment.text = nil;
                [self clearNSUserDefaults];
                [self.view makeToast:@"提交成功" duration:1.5 position:CSToastPositionCenter];
                
                uploadImageArray = [NSMutableArray array];
                uploadImageNameArray = [NSMutableArray array];
                uploadImageNoteArray = [NSMutableArray array];
                _exampleArray = [NSMutableArray array];
                _newsArray = [NSMutableArray array];
                [_upImageCollectionView reloadData];
                [_upCollectionView reloadData];
                
                

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)( 2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            }
            else
            {
                [self.view makeToast:[NSString stringWithFormat:@"上传失败,请重试"] duration:1 position:nil];
                [hud removeFromSuperview];
                rightItem.enabled = YES;
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.view makeToast:[NSString stringWithFormat:@"上传调研记录图片失败"] duration:1 position:nil];
            [hud removeFromSuperview];
            
            rightItem.enabled = YES;
        }];
    
}

#pragma mark - Collection View Data Source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"%ld",(long)_newsArray.count);
    if ([collectionView isEqual:_upCollectionView]) {
        UpScoreModel *model = _newsArray[section];
        return model.scoreStandardsModelArray.count;
    }
    else
    {
        ExamModel *model =_exampleArray[section];
        if (model.imageArray.count && model.imageArray.count <= 6) {
            return model.imageArray.count;
        }else if(model.imageArray.count > 6)
            return 6;
        else return 0;
    }
    return 0;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if ([collectionView isEqual:_upCollectionView]) {
        return UIEdgeInsetsMake(0, 0, 14, 0);
    }else
        return UIEdgeInsetsMake(14, 0, 0, 0);//分别为上、左、下、右
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:_upCollectionView]) {
        static NSString *collectionCellID = @"collectionCell";
        UpScoreCell *cell = (UpScoreCell *)[self.upCollectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
        sum = 0;
        
        UpScoreModel *upscoreModel = _newsArray[indexPath.section];
        OnceEnterModel *model = upscoreModel.scoreStandardsModelArray[indexPath.item];
        model.levelModelArray = [NSMutableArray arrayWithArray:[SubLifeModel mj_objectArrayWithKeyValuesArray:model.levels]];
        
        self.models = model;
        
        cell.evaluate.text = model.name;
        cell.textFieldCount.delegate = self;
        cell.textFieldCount.tag = indexPath.item + 1000 * (indexPath.section + 1);
        NSString * placehoder = [NSString stringWithFormat:@"%@-%@",model.minscore,model.maxscore];
        cell.textFieldCount.placeholder = placehoder;
        cell.textFieldCount.text = model.textFieldString;
        
        
        for (SubLifeModel *levelModel in model.levelModelArray) {
            if ([model.textFieldString integerValue] <= [levelModel.maxscore integerValue] && [model.textFieldString integerValue] >= [levelModel.minscore integerValue]) {
                if (![self isBlankString:model.textFieldString]) {
                    cell.levelLabel.text = levelModel.name;
                }
                else cell.levelLabel.text = @"";
            }
        }
        
        
        //        if (tempTextFieldStringArray.count) {
        //            cell.textFieldCount.text = [NSString stringWithFormat:@"%@",tempTextFieldStringArray[indexPath.section][indexPath.row]];
        //        }
        return cell;
    }
    else
    {
        static NSString *identify = @"cell";
        ZXCollectionCell *cell = (ZXCollectionCell *)[_upImageCollectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        if (!cell) {
            NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
        }
        ExamModel *model  = _exampleArray[indexPath.section];
        if (model.imageArray.count) {
            cell.imgView.image = [model.imageArray objectAtIndex:indexPath.row];
            if (model.imageArray.count == 1) {
                cell.close.hidden = YES;
            }else cell.close.hidden = NO;
            if (indexPath.row == model.imageArray.count - 1) {
                cell.close.hidden = YES;
            }else cell.close.hidden = NO;
        }
        
//        if (uploadImageArray.count) {
//            cell.imgView.image = [uploadImageArray objectAtIndex:indexPath.row];
//        }
        cell.delegate = self;
        return cell;
    }
};


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:_upCollectionView]) {
        UpScoreModel *upModel = _newsArray[indexPath.section];
        OnceEnterModel *enterModel  = upModel.scoreStandardsModelArray[indexPath.item];
        LifeModel *model = [LifeModel mj_objectWithKeyValues:enterModel.mj_keyValues];
        
        
        NSString *levelString = @"";
        if (model.levels.count > 0) {
            
            for (NSDictionary * dict in model.levels) {
                
                NSString * str  = [NSString stringWithFormat:@"%@(%@~%@)\n",dict[@"name"],dict[@"minscore"],dict[@"maxscore"]];
                
                levelString = [str stringByAppendingFormat:@"%@",levelString];
            };
        }
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:model.name message:[NSString stringWithFormat:@"评分等级:\n%@\n评分备注:\n%@",levelString,model.note] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        NSLog(@"%ld-----",(long)indexPath.item);
    }
}

// collectionView header 的高度设置
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if ([collectionView isEqual:_upCollectionView]) {
        return CGSizeMake(0, 40);
    }else return CGSizeMake(0, 40);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([collectionView isEqual:_upCollectionView]) {
        UICollectionReusableView *reusableview = nil ;
        
        if (kind == UICollectionElementKindSectionHeader ){
            
            UploadScoreHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind : UICollectionElementKindSectionHeader withReuseIdentifier : @"headerView" forIndexPath :indexPath];
            
            UpScoreModel *upscoreModel = _newsArray[indexPath.section];
            //            OnceEnterModel *model = upscoreModel.scoreStandardsModelArray[indexPath.item];
            
            headerView.itemNameLabel.text = upscoreModel.name;
            headerView.sumScoreLabel.text = sumArray[indexPath.section];
            
            UpScoreModel *upModel = _newsArray[indexPath.section];
            OnceEnterModel *sumScoreModel = [OnceEnterModel new];
            if (upModel.totalScoreStandardsModelArray.count) {
                sumScoreModel = upModel.totalScoreStandardsModelArray[0];
            }
            sumScoreModel.levelModelArray = [NSMutableArray arrayWithArray:[SubLifeModel mj_objectArrayWithKeyValuesArray:sumScoreModel.levels]];
            for (SubLifeModel *levelModel in sumScoreModel.levelModelArray) {
                if ([sumArray[indexPath.section] integerValue] <= [levelModel.maxscore integerValue] && [sumArray[indexPath.section] integerValue] >= [levelModel.minscore integerValue]) {
                    if (![self isBlankString:[NSString stringWithFormat:@"%@",sumArray[indexPath.section]]]) {
                        headerView.sumScoreLabel.text = [NSString stringWithFormat:@"%@\n%@  ", sumArray[indexPath.section],levelModel.name] ;
                    }
                    else headerView.sumScoreLabel.text = sumArray[indexPath.section];
                }
            }
            
    
            
            reusableview = headerView;
            
            [sumHeaderViewDic setObject:headerView forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section] ];
            
        }
        return reusableview;
    }
    else
    {
        ExamModel *model = _exampleArray[indexPath.section];
        
        
        UploadImageHeaderView *headerViewImage  = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UploadImageHeaderView" forIndexPath:indexPath];
        headerViewImage.titleLabel.text = [NSString stringWithFormat:@"案例 : %@",model.name];
        if (model.imageArray.count == 1|| [self isBlankString:model.name]) {
            headerViewImage.titleLabel.text = [NSString stringWithFormat:@"案例%ld",(long)indexPath.section + 1];
        }

        return headerViewImage;
    }
        
        return [UICollectionReusableView new];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if ([collectionView isEqual:_upCollectionView]) {
        return _newsArray.count;
    }
    else
    {
        
        return _exampleArray.count;
    }
}


/**
 * 超出分值上下限提示
 */

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    
    for (int j = 0; j < _newsArray.count; j++) {
        UpScoreModel *modelup = _newsArray[j];
        for (int i = 0; i < modelup.scoreStandardsModelArray.count; i ++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:j];
            UpScoreModel *upModel = _newsArray[indexPath.section];
            OnceEnterModel * model = upModel.scoreStandardsModelArray[indexPath.row];
            
            model.levelModelArray = [NSMutableArray arrayWithArray:[SubLifeModel mj_objectArrayWithKeyValuesArray:model.levels]];
            
            OnceEnterModel *sumScoreModel  = [OnceEnterModel new];
            if (upModel.totalScoreStandardsModelArray.count ) {
                sumScoreModel = upModel.totalScoreStandardsModelArray[0];
            }
            sumScoreModel.levelModelArray = [NSMutableArray arrayWithArray:[SubLifeModel mj_objectArrayWithKeyValuesArray:sumScoreModel.levels]];
            
            
            
            NSInteger tag = indexPath.row + 1000 * (j+1);
            if (tag == textField.tag) {

                UpScoreCell *cell = (UpScoreCell *)[_upCollectionView cellForItemAtIndexPath:indexPath];
                
                NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
                
                NSCharacterSet*cs;
                cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
                NSString*filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
                BOOL basicTest = [string isEqualToString:filtered];
                if( !basicTest || [toBeString hasSuffix:@".."] || [toBeString hasPrefix:@"."]) {
                    [self.view makeToast:@"请输入数字评分" duration:1 position:CSToastPositionTop];
                    return NO;
                }
                if ([toBeString integerValue] < [model.minscore integerValue] || [toBeString floatValue] > [model.maxscore integerValue]) {
                    [self.view makeToast:@"输入的评分超出限定,请重新输入" duration:1.5 position:CSToastPositionTop];
                    textField.text = @"";
                    sum = 0;
                    for (OnceEnterModel *model in upModel.scoreStandardsModelArray) {
                        sum += [model.textFieldString integerValue];
                    }
                    self.totalScore.text = [NSString stringWithFormat:@"%d",sum];
                    return NO;
                }
                else
                {
                    model.textFieldString = toBeString;
                    [upModel.scoreStandardsModelArray replaceObjectAtIndex:indexPath.row withObject:model];
                    
                    NSDictionary * dict1 = @{@"evaluateStandard":@{
                                                     @"id": model.id
                                                     },
                                             @"score": [NSString stringWithFormat:@"%ld",(long)[model.textFieldString integerValue]]
                                             //                                                       @"level": @"A"
                                             };
                    self.dict1  = dict1;
                    
                    [_jsonArray enumerateObjectsUsingBlock:^(NSDictionary *tempDic, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([[[tempDic objectForKey:@"evaluateStandard"] objectForKey:@"id"] isEqualToString:model.id]) {
                            [_jsonArray removeObject:tempDic];
                            *stop = YES;
                        }
                    }];
                    [self.jsonArray addObject:self.dict1];
                    
                    
                    sum = 0;
                    for (OnceEnterModel *modelSum in upModel.scoreStandardsModelArray) {
                        sum += [modelSum.textFieldString integerValue];
                    }
                    [ sumArray replaceObjectAtIndex:j withObject:[NSString stringWithFormat:@"%d",sum]];
                    
                    UploadScoreHeaderView *tmpView = [sumHeaderViewDic objectForKey:[NSString stringWithFormat:@"%d",j]];
                    
                    for (SubLifeModel *levelModel in model.levelModelArray) {
                        if ([toBeString integerValue] <= [levelModel.maxscore integerValue] && [toBeString integerValue] >= [levelModel.minscore integerValue]) {
                            if (![self isBlankString:toBeString]) {
                                cell.levelLabel.text = levelModel.name;
                            }
                            else cell.levelLabel.text = @"";
                        }
                    }
                    
                    for (SubLifeModel *levelModel in sumScoreModel.levelModelArray) {
                        if (sum <= [levelModel.maxscore integerValue] && sum >= [levelModel.minscore integerValue]) {
                            if (![self isBlankString:[NSString stringWithFormat:@"%d",sum]]) {
                                tmpView.sumScoreLabel.text = [NSString stringWithFormat:@"%@\n%@  ", sumArray[indexPath.section],levelModel.name] ;
                            }
                            else tmpView.sumScoreLabel.text = sumArray[indexPath.section];
                        }
                    }
//                    tmpView.sumScoreLabel.text = sumArray[indexPath.section];
                    self.totalScore.text = [NSString stringWithFormat:@"%d",sum];
                    return YES;
                }
            }
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    for (int j = 0; j < _newsArray.count; j++) {
        UpScoreModel *modelup = _newsArray[j];
        for (int i = 0; i < modelup.scoreStandardsModelArray.count; i ++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:j];
            
            NSInteger tag = indexPath.row + 1000 * (j+1);
            if (tag == textField.tag) {
                NSIndexPath *path = [NSIndexPath indexPathForRow:i+1 inSection:j];
                UpScoreCell *cell = (UpScoreCell *)[_upCollectionView cellForItemAtIndexPath:path];
                [cell.textFieldCount becomeFirstResponder];
            }
        }
    }
    return YES;
}

- (IBAction)upLoadImage:(id)sender {
    
    if (_exampleArray.count ==6) {
        [self.view makeToast:@"最多可上传6个案例" duration:1.5 position:nil];
        return;
    }
    
    ExamModel * examModel = [ExamModel new];
    examModel.imageArray = [NSMutableArray array];
    UIImage *image = [UIImage imageNamed:@"icon_add_normal"];
    [examModel.imageArray addObject:image];
    
    [_exampleArray addObject:examModel];
    [_upImageCollectionView reloadData];
    
}


-(void)addImageToExam
{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"上传案例" message:@"请先选择案例图片,然后输入案例描述" preferredStyle:UIAlertControllerStyleAlert];
    
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
        
        __block ExamModel *model = _exampleArray[tempSection];
        
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount: 7 - model.imageArray.count columnNumber:8 delegate:self pushPhotoPickerVc:YES];
        
        imagePickerVc.preferredLanguage = @"zh-Hans";
        imagePickerVc.isSelectOriginalPhoto = YES;
        imagePickerVc.allowPickingOriginalPhoto = YES;
        imagePickerVc.allowPickingGif = NO;
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.allowCrop = NO;
        imagePickerVc.needCircleCrop = NO;
        imagePickerVc.allowTakePicture = NO;
        
        
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            
//            ExamModel *model = _exampleArray[tempSection];
            NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:model.imageArray];
            
            for (UIImage *image in photos) {
                //压缩
                NSData *data = [self zipNSDataWithImage:image];
                UIImage *addImage = [UIImage imageWithData:data];
                [tmpArray insertObject:addImage atIndex:model.imageArray.count - 1];
            }
            
            model.imageArray = [NSMutableArray arrayWithArray:tmpArray];
            [_upImageCollectionView reloadData];
            
            if (model.imageArray.count == 2 || [self isBlankString:model.note] || [self isBlankString:model.name]) {
                [self showCustomAlert];
            }
            
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
        
        
//        UIImagePickerController *ipc=[[UIImagePickerController alloc] init];
//        ipc.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
//        ipc.delegate=self;
//        ipc.allowsEditing=NO;
//        [self presentViewController:ipc animated:YES completion:nil];
    }]];
    
    [alert addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController: alert animated: YES completion: nil];
}




-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *) info{
    
    UIImage *image=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
//    
//    //压缩
//    UIImage *imageNew = image;
//    //设置image的尺寸
//    CGSize imagesize = imageNew.size;
//    imageNew = [self imageCompressForWidth:imageNew targetWidth:imagesize.width];
    
    
    NSData *data = [self zipNSDataWithImage:image];
    UIImage *addImage = [UIImage imageWithData:data];
    
    
    ExamModel *model = _exampleArray[tempSection];
    
    NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:model.imageArray];
    
    [tmpArray insertObject:addImage atIndex:model.imageArray.count - 1];
    
    model.imageArray = [NSMutableArray arrayWithArray:tmpArray];
    
    [_upImageCollectionView reloadData];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        if (model.imageArray.count == 2) {
            [self showCustomAlert];
        }
        
    }];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
#pragma mark - showAlert
-(void)showCustomAlert
{
    
    ExamModel *model  = _exampleArray[tempSection];
    
    CGFloat width = [JCAlertStyle shareStyle].alertView.width;
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 380)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 20, width, 30)];
    titleLabel.text = @"请输入案例名称";
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [bgView addSubview:titleLabel];
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(16, 55, width - 32, 100)];
    textView.layer.masksToBounds = YES;
    textView.layer.cornerRadius = 3.0f;
    textView.layer.borderWidth = 1.f;
    textView.font = [UIFont systemFontOfSize:15];
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [bgView addSubview:textView];
    
    if (model.imageArray.count && [(NSString *)model.name length]) {
        textView.text = model.name;
    }
    
    
    UILabel *titleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(16, 20 + 155, width, 30)];
    titleLabel2.text = @"请输入案例说明";
    titleLabel2.font = [UIFont boldSystemFontOfSize:15];
    [bgView addSubview:titleLabel2];
    
    UITextView *textView2 = [[UITextView alloc]initWithFrame:CGRectMake(16, 55 + 155, width - 32, 150)];
    textView2.layer.masksToBounds = YES;
    textView2.layer.cornerRadius = 3.0f;
    textView2.layer.borderWidth = 1.f;
    textView2.font = [UIFont systemFontOfSize:15];
    textView2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [bgView addSubview:textView2];
    if (model.imageArray.count && [(NSString *)model.note length]) {
        textView2.text = model.note;
    }
    
    JCAlertController *alert = [JCAlertController alertWithTitle:nil contentView:bgView];
    [alert addButtonWithTitle:@"确定" type:JCButtonTypeNormal clicked:nil];
    
    [self jc_presentViewController:alert presentCompletion:^{
        [textView resignFirstResponder];
        [textView2 resignFirstResponder];
        
    } dismissCompletion:^{
        model.name = textView.text.length?textView.text:@"";
        model.note = textView2.text.length?textView2.text:@"";
    }];
    
    
    __weak typeof(JCAlertController *) weakalert = alert;
    
    // callback after keyboard shows
    [alert monitorKeyboardShowed:^(CGFloat alertHeight, CGFloat keyboardHeight) {
        [weakalert moveAlertViewToCenterY:alertHeight / 2  animated:YES];
    }];
    // callback after keyboard hides
    [alert monitorKeyboardHided:^{
        [weakalert moveAlertViewToScreenCenterAnimated:YES];
    }];
    
    [_upImageCollectionView reloadData];
}



#pragma mark - initImageView

-(void)initUploadArray
{

    _upImageCollectionView.delegate = self;
    _upImageCollectionView.dataSource = self;
    
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(90, 90);
    flowLayout.minimumInteritemSpacing=10; //cell之间左右的
    flowLayout.minimumLineSpacing=10;      //cell上下间隔
    flowLayout.sectionInset = UIEdgeInsetsMake(14, 0, 0, 0);
    self.upImageCollectionView.collectionViewLayout = flowLayout;
    //注册cell和ReusableView（相当于头部）
    [self.upImageCollectionView registerClass:[ZXCollectionCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self.upImageCollectionView registerClass:[UploadScoreHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    
    [self.upImageCollectionView registerClass:[UploadImageHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UploadImageHeaderView"];
    
}

-(void)moveImageBtnClick:(ZXCollectionCell *)aCell{
    NSIndexPath * indexPath = [self.upImageCollectionView indexPathForCell:aCell];
    NSLog(@"_____%ld",indexPath.row);
    
    ExamModel *model = _exampleArray[indexPath.section];
    
    if (model.imageArray.count > 1) {
        [model.imageArray removeObjectAtIndex:indexPath.row ];
        if (model.imageArray.count == 1) {
            [_exampleArray removeObjectAtIndex:indexPath.section];
        }
    }
//    [uploadImageArray removeObjectAtIndex:indexPath.row];
//    [uploadImageNoteArray removeObjectAtIndex:indexPath.row];
//    [uploadImageNameArray removeObjectAtIndex:indexPath.row];
    
    [self.upImageCollectionView reloadData];
}



//压缩图片方法
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}


-(void)showAlertController:(ZXCollectionCell *)aCell
{
    
    NSIndexPath * indexPath = [self.upImageCollectionView indexPathForCell:aCell];
    
    ExamModel *model = _exampleArray[indexPath.section];
    
    tempRow = indexPath.row;
    tempSection = indexPath.section;
    
    if (indexPath.row == 0 || indexPath.row == nil) {
        tempRow = 0;
    }
    if (indexPath.section == 0 || indexPath.section == nil) {
        tempSection = 0;
    }
    
//    if (model.imageArray.count >6) {
//        [self.view makeToast:@"超出图片数量限制" duration:1 position:CSToastPositionCenter];
//        return;
//    }
    
    if (indexPath.row == model.imageArray.count - 1) {
        [self addImageToExam];
        
    }
    else
    {
        CGFloat width = [JCAlertStyle shareStyle].alertView.width;
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 380)];
        bgView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 20, width, 30)];
        titleLabel.text = @"请输入案例图片名称";
        titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [bgView addSubview:titleLabel];
        
        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(16, 55, width - 32, 100)];
        textView.layer.masksToBounds = YES;
        textView.layer.cornerRadius = 3.0f;
        textView.layer.borderWidth = 1.f;
        textView.font = [UIFont systemFontOfSize:15];
        textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [bgView addSubview:textView];
        if (model.imageArray.count && [(NSString *)model.name length]) {
            textView.text = model.name;
        }
        
        UILabel *titleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(16, 20 + 155, width, 30)];
        titleLabel2.text = @"请输入案例图片说明";
        titleLabel2.font = [UIFont boldSystemFontOfSize:15];
        [bgView addSubview:titleLabel2];
        
        UITextView *textView2 = [[UITextView alloc]initWithFrame:CGRectMake(16, 55 + 155, width - 32, 150)];
        textView2.layer.masksToBounds = YES;
        textView2.layer.cornerRadius = 3.0f;
        textView2.layer.borderWidth = 1.f;
        textView2.font = [UIFont systemFontOfSize:15];
        textView2.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [bgView addSubview:textView2];
        if (model.imageArray.count && [(NSString *)model.note length]) {
            textView2.text = model.note;
        }
        
        
        JCAlertController *alert = [JCAlertController alertWithTitle:nil contentView:bgView];
        [alert addButtonWithTitle:@"确定" type:JCButtonTypeNormal clicked:nil];
        
        [self jc_presentViewController:alert presentCompletion:^{
            [textView resignFirstResponder];
            [textView2 resignFirstResponder];
            
        } dismissCompletion:^{
            model.name = textView.text.length > 0 ?textView.text:@"";
            model.note = textView2.text.length > 0 ?textView2.text:@"";
        }];
        
        __weak typeof(JCAlertController *) weakalert = alert;
        
        // callback after keyboard shows
        [alert monitorKeyboardShowed:^(CGFloat alertHeight, CGFloat keyboardHeight) {
            [weakalert moveAlertViewToCenterY:alertHeight / 2  animated:YES];
        }];
        // callback after keyboard hides
        [alert monitorKeyboardHided:^{
            [weakalert moveAlertViewToScreenCenterAnimated:YES];
        }];
    }
    
    [_upImageCollectionView reloadData];
}


#pragma mark - TempAdded



- (void) textViewDidChange:(UITextView*)textview
{
    if (textview.text.length > 0) {
        // 禁止系统表情的输入
        NSString *text = [self disable_emoji:[textview text]];
        if (![text isEqualToString:textview.text]) {
            NSRange textRange = [textview selectedRange];
            textview.text = text;
            [textview setSelectedRange:textRange];
        }
    }
    
    if (textview.text.length >= 1000)
    {
        textview.text = [textview.text substringToIndex:1000];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入内容不可超过1000字" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
    [[NSUserDefaults standardUserDefaults]setValue:textview.text forKey:@"saveTextViewPerTimeComment"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
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


-(void)viewWillAppear:(BOOL)animated
{
    
    
    [super viewWillAppear:animated];
    
    
    NSString *textViewString = [[NSUserDefaults standardUserDefaults]valueForKey:@"saveTextViewPerTimeComment"];
    if (![self isBlankString:textViewString]) {
        _comment.text = textViewString;
    }
    
    tempTextFieldStringArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"saveEvaluateIDArray"]];
    
    //
    //    if (![self isBlankString:self.taskID]) {
    //        NSMutableArray *tempTempTextFieldStringArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:self.taskID]];
    //        if (tempTempTextFieldStringArray.count) {
    //            tempTextFieldStringArray = [NSMutableArray arrayWithArray:tempTempTextFieldStringArray];
    //
    //        }
    //    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        NSMutableArray *array = [NSMutableArray array];
        for (UpScoreModel *model in _newsArray) {
            NSMutableArray *innerArray = [NSMutableArray array];
            for (OnceEnterModel *onceModel in model.scoreStandardsModelArray) {
                [innerArray addObject:onceModel.textFieldString.length?onceModel.textFieldString:@""];
            }
            NSDictionary *dic = @{model.id:innerArray};
            [array addObject:dic];
        }
        [[NSUserDefaults standardUserDefaults]setObject:array forKey:@"saveEvaluateIDArray"];
        
        //        if (![self isBlankString:self.taskID]) {
        //            NSMutableArray *array = [NSMutableArray array];
        //            for (UpScoreModel *model in _newsArray) {
        //                NSMutableArray *innerArray = [NSMutableArray array];
        //                for (OnceEnterModel *onceModel in model.scoreStandardsModelArray) {
        //                    [innerArray addObject:onceModel.textFieldString.length?onceModel.textFieldString:@""];
        //                }
        //                [array addObject:innerArray];
        //            }
        //            [[NSUserDefaults standardUserDefaults]setObject:array forKey:_taskID];
        //        }
        
        [[NSUserDefaults standardUserDefaults]setObject:uploadImageNoteArray forKey:@"saveImageNoteArray"];
        [[NSUserDefaults standardUserDefaults]setObject:uploadImageNameArray forKey:@"saveImageNameArray"];
        
        
// 临时使用YYcache缓存model
//        YYCache *cache = [YYCache cacheWithName:@"saveExamDataCACHE"];
//        //这里不可以使用yycache的异步存储方式
//        [cache setObject:_exampleArray forKey:@"saveExamDataArray"];
        
        
        __block NSMutableArray *examModelArray = [NSMutableArray array];
        [_exampleArray enumerateObjectsUsingBlock:^(ExamModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
            [examModelArray addObject:data];
        }];
        [[NSUserDefaults standardUserDefaults]setObject:examModelArray forKey:@"saveExamDataArray"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    });
    UICollectionViewFlowLayout *layout = _upCollectionView.collectionViewLayout;
    layout.estimatedItemSize = CGSizeZero;
    layout.sectionInset = UIEdgeInsetsZero;
    layout.headerReferenceSize = CGSizeZero;
    
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
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"saveTextViewPerTime"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"saveTextViewPerTimeRight"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"saveTextViewPerTimeComment"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:_evaluateItemId];
        if (![self isBlankString:self.taskID]) {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:_taskID];
            [[NSUserDefaults standardUserDefaults]setObject:[NSMutableArray array] forKey:_taskID];
        }
        [[NSUserDefaults standardUserDefaults]setObject:[NSMutableArray array] forKey:_evaluateItemId];
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"TOPICNAME"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"subjectInput"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"teacherFeature"];
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SelectedClassID"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SelectedClassName"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SelectedPersonID"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"SelectedPersonName"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"saveCourseNumString"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"saveCourseTypeString"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"saveTimeString"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"saveEvaluateIDArray"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"dataTempSave"];
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"saveExamDataArray"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    });
}


-(NSString *)getLessonTime
{
    if (self.lesson.length) {
        if ([self.lesson isEqualToString:@"08:00 ~ 08:40"]) {
            self.lesson = @"1";
        }else if([self.lesson isEqualToString:@"08:50 ~ 09:30"])
        {
            self.lesson = @"2";
        }else if([self.lesson isEqualToString:@"09:40 ~ 10:20"])
        {
            self.lesson = @"3";
        }else if([self.lesson isEqualToString:@"10:35 ~ 11:15"])
        {
            self.lesson = @"4";
        }else if([self.lesson isEqualToString:@"11:25 ~ 12:05"])
        {
            self.lesson = @"5";
        }else if([self.lesson isEqualToString:@"13:40 ~ 14:20"])
        {
            self.lesson = @"6";
        }else if([self.lesson isEqualToString:@"14:35 ~ 15:15"])
        {
            self.lesson = @"7";
        }else if([self.lesson isEqualToString:@"15:25 ~ 16:05"])
        {
            self.lesson = @"8";
        }
        else if([self.lesson isEqualToString:@"16:15 ~ 16:55"])
        {
            self.lesson = @"9";
        }
        else self.lesson = @"";
    }
    else self.lesson = @"";
    return self.lesson;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (NSString *)emojiEncode:(NSAttributedString *)string
{
    NSString *htmlString = [self htmlStringByHtmlAttributeString:_contentAttributedString];
    NSString *uniStr = [NSString stringWithUTF8String:[htmlString UTF8String]];
    NSData *uniData = [uniStr dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *emojiText = [[NSString alloc] initWithData:uniData encoding:NSUTF8StringEncoding];
    return emojiText;
}

-(NSString *)htmlStringByHtmlAttributeString:(NSAttributedString *)htmlAttributeString{
    NSString *htmlString;
    NSDictionary *exportParams = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]
                                   };
    NSData *htmlData = [htmlAttributeString dataFromRange:NSMakeRange(0, htmlAttributeString.length) documentAttributes:exportParams error:nil];
    htmlString = [[NSString alloc] initWithData:htmlData encoding: NSUTF8StringEncoding];
    return htmlString;
}

- (NSString *)emojiEncodeNSString:(NSString *)string
{
    NSString *uniStr = [NSString stringWithUTF8String:[string UTF8String]];
    NSData *uniData = [uniStr dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *emojiText = [[NSString alloc] initWithData:uniData encoding:NSUTF8StringEncoding];
    return emojiText;
}

-(void)textViewDidTap
{
    _comment.editable = YES;
    [_comment becomeFirstResponder];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    textView.editable = NO;
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

