//
//  WriteModel.h
//  PadEvaluate
//
//  Created by hzth-mac3 on 15/12/17.
//  Copyright © 2015年 hzth-mac3. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ClassModel;

@interface WriteModel : NSObject

@property (nonatomic, copy) NSString * organization;
@property (nonatomic, copy) NSString * score;
@property (nonatomic, copy) NSString * level;
@property (nonatomic, copy) NSString * remark;

@property (nonatomic, copy) ClassModel * classModel;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * items;
@property (nonatomic, copy) NSString * record;


@end
