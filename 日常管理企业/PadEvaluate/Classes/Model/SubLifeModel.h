//
//  SubLifeModel.h
//  PadEvaluate
//
//  Created by hzth-mac3 on 15/12/18.
//  Copyright © 2015年 hzth-mac3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubLifeModel : NSObject
/*
 maxscore = 2;
 minscore = 1;
 name = A;
 */
@property (nonatomic, copy) NSString * maxscore;

@property (nonatomic, copy) NSString * minscore;

@property (nonatomic, copy) NSString * name;
@end
