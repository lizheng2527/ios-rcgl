//
//  OnceEnterModel.h
//  PadEvaluate
//
//  Created by hzth-mac3 on 15/12/21.
//  Copyright © 2015年 hzth-mac3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OnceEnterModel : NSObject
/*
 id = 20150526173901798100614476840008;
 levels =             (
 );
 maxscore = 55;
 minscore = 11;
 name = test;
 note = dsaf;
 */
@property (nonatomic, strong) NSString * id;

@property (nonatomic, strong) NSMutableArray * levels;

@property(nonatomic,strong) NSMutableArray *levelModelArray;

@property (nonatomic, copy) NSString * name;

@property (nonatomic, copy) NSString * note;

@property (nonatomic, copy) NSString * maxscore;

@property (nonatomic, copy) NSString * minscore;

@property(nonatomic,copy)NSString *textFieldString;
@end

@interface UpScoreModel : NSObject

@property (nonatomic, strong) NSString * id;
@property (nonatomic, copy) NSString * name;
@property(nonatomic,retain)NSMutableArray *scoreStandards;
@property(nonatomic,retain)NSMutableArray *scoreStandardsModelArray;

@property(nonatomic,retain)NSMutableArray *totalScoreStandards;
@property(nonatomic,retain)NSMutableArray *totalScoreStandardsModelArray;

@end

