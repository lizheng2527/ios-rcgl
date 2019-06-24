//
//  NewEvaluateModel.h
//  PadEvaluate
//
//  Created by hzth-mac3 on 15/12/18.
//  Copyright © 2015年 hzth-mac3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewEvaluateModel : NSObject
//id = 20150525171926385664320632168156;
//kind = 2;
//name = 11;
//parentId

@property (nonatomic, copy) NSString * kind;
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * parentId;

@property (nonatomic,assign) NSUInteger IndentationLevel;

@property (strong, nonatomic) NSString *contactId;
@property (strong, nonatomic) NSMutableArray *userList;
@property(nonatomic,strong) NSMutableArray *childs;
@property(nonatomic,retain)NSMutableArray *evaluateArray;


@property(nonatomic,retain)NSString *level;

@end


@interface NewEvaluateDetailModel : NSObject

@property (strong, nonatomic) NSString *contactId;
@property (strong, nonatomic) NSString *name;
@property (nonatomic, copy) NSString * id;
@property (strong, nonatomic) NSString *parentId;
@property (strong, nonatomic) NSMutableArray *userList;
@property (nonatomic,assign) NSUInteger IndentationLevel;
@property(nonatomic,strong) NSMutableArray *childs;

@property(nonatomic,retain)NSMutableArray *evaluateArray;
@end

