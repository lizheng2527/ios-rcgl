//
//  Public.h
//  PadEvaluate
//
//  Created by hzth-mac3 on 15/12/15.
//  Copyright © 2015年 hzth-mac3. All rights reserved.
//



#ifndef Public_h
#define Public_h
/*
 获取日常评价指标项
 /tp/mobile/teacherPlatform!getEvaluateItemTree.action
 
 获取当前用户的调研任务
 /tp/mobile/teacherPlatform!getUserTask.action
 
 获取评价指标
 /tp/mobile/teacherPlatform!getEvaluateStandard.action
 参数：
 evaluateItemId 指标项id
 
 获取评分指标(打分用)
 /tp/mobile/teacherPlatform!getScoreStandards.action
 evaluateItemId 指标项id
 eclassId 班级id
 
 保存评分
 /tp/mobile/teacherPlatform!saveTeacherEvaluateRecord.action
 参数见 "保存评分json数据格式.txt"
 
 
 上传案例
 /tp/mobile/teacherPlatform!saveEvaluateExample.action
 name 案例名称
 note 案例说明
 uploadFiles 文件
 uploadFileNames 文件名
 
 获取班级
 /tp/mobile/teacherPlatform!getEclasses.action
 
 获取被评价教师
 /tp/mobile/teacherPlatform!getTeachers.action
 参数:
 eclassId 班级id
 */

/*
 {
 "teacherEvaluateRecord": {
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
 },
 "teacherScores": [
 {
 "evaluateStandard": {
 "id": "指标id"
 },
 "score": "得分",
 "level": "得分等级"
 },
 {
 "evaluateStandard": {
 "id": "指标id"
 },
 "score": "得分",
 "level": "得分等级"
 }
 ],
 "universalityScores": [
 {
 "evaluateStandard": {
 "id": "普适性学习指标id"
 },
 "score": "得分",
 "level": "得分等级"
 },
 {
 "evaluateStandard": {
 "id": "普适性学习指标id"
 },
 "score": "得分",
 "level": "得分等级"
 }
 ],
 "exampleIds": "案例id(逗号分隔)"
 }
 */
#define TabBarColorGreen colorWithRed:24 / 255.0 green:171 / 255.0 blue:142/ 255.0 alpha:1.0
//#define TabBarColorGreen colorWithRed:21 / 255.0 green:153 / 255.0 blue:63 / 255.0 alpha:0.8


#define ScreenWidth self.view.frame.size.width
#define ScreenHeight self.view.frame.size.height


#define kArchivingDataKey    @"kArchivingDataKey"
#define USER_DEFAULT_LOGINNAME @"USER_DEFAULT_LOGINNAME"
#define USER_DEFAULT_PASSWORD @"USER_DEFAULT_PASSWORD"

//#define k_V3ServerURL @"http://58.132.43.217/dc"
#define ImageBaseURL [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_IMAGE_BASEURL]


#define BaseUrl [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_BASEURL]

//#define BaseUrl @"http://192.168.1.121:8888/dc-teachingplatform"


#define USER_DEFAULT_BASEURL @"USER_DEFAULT_BASEURL"
#define USER_DEFAULT_IMAGE_BASEURL @"USER_DEFAULT_IMAGE_BASEURL"


#endif /* Public_h */
