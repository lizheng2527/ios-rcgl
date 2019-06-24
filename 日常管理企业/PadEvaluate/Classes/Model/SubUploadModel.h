//
//  SubUploadModel.h
//  PadEvaluate
//
//  Created by hzth-mac3 on 15/12/21.
//  Copyright © 2015年 hzth-mac3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SecondSubModel.h"

@interface SubUploadModel : NSObject
/*
 "title": "主题",
 "content": "调研记录",
 "comment": "评语",
 "evaluateItem": {
 "id": "指标项id(evaluateItemId)"
 },
 "investigationUser": {
 "id": "调研任务id(taskId)"
 },
 "teacher": {
 "id": "被调研人id"
 },
 "eclass": {
 "id": "被调研班级id"
 }
 */
@property (nonatomic, strong) SecondSubModel * secondModel;
@property (nonatomic, copy) NSString * comment;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * personId;
@property (nonatomic, copy) NSString * classId;
@property (nonatomic, copy) NSString * evaluateItem;
@property (nonatomic, copy) NSString * teacherEvaluateRecord;

@end
