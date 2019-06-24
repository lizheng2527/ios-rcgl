//
//  WorkListModal.h
//  PadEvaluate
//
//  Created by hzth-mac3 on 15/12/17.
//  Copyright © 2015年 hzth-mac3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkListModal : NSObject

/*
evaluateItemId = 20150519135606255300020137671677;
name = tt111111111111111;
submitFlag = 0;
taskId = 20150612093028764013679161290182
*/

@property (nonatomic, copy) NSString * evaluateItemId;
@property (nonatomic, copy) NSString * submitFlag;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * taskId;

@property(nonatomic,copy)NSString *taskFlag;  //0代表没有任务 1代表有任务
@property(nonatomic,copy)NSString *stepName;

@property(nonatomic,copy)NSString *submitNum;

@property(nonatomic,copy)NSString *endDate;
@property(nonatomic,copy)NSString *startDate;
@end
