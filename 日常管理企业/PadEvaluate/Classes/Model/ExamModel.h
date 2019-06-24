//
//  ExamModel.h
//  PadEvaluate
//
//  Created by 中电和讯 on 2018/3/13.
//  Copyright © 2018年 hzth-mac3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExamModel : NSObject

//@property (nonatomic, copy) NSString * name;

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * note;

@property(nonatomic,assign)NSInteger index;

@property (nonatomic, retain) NSMutableArray * imageArray;
@end
