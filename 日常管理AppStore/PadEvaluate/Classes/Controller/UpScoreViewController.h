//
//  UpScoreViewController.h
//  PadEvaluate
//
//  Created by hzth-mac3 on 15/12/15.
//  Copyright © 2015年 hzth-mac3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpScoreCell.h"
#import "UploadModel.h"
#import "SubUploadModel.h"
#import "SecondSubModel.h"
#import "WorkListModal.h"
#import "UnitCell.h"


@interface UpScoreViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *unitCollection;

@property (nonatomic, strong) NSMutableArray * workListArray;
@property (nonatomic, strong) WorkListModal * model;
@property (weak, nonatomic) IBOutlet UICollectionView *upCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *upImageCollectionView;

@property (weak, nonatomic) IBOutlet UILabel *totalScore;
//@property (weak, nonatomic) IBOutlet UIImageView *uploadImage;
//@property (weak, nonatomic) IBOutlet UIImageView *uploadImage2;
//@property (weak, nonatomic) IBOutlet UIImageView *uploadImage3;
@property (weak, nonatomic) IBOutlet UIButton *uploadImageBtn;

@property (weak, nonatomic) IBOutlet UITextView *comment;

@property (nonatomic, strong) NSString * loginName;
@property (nonatomic, strong) NSString * passWord;
//

@property (nonatomic, copy) NSString * comments;
@property (nonatomic, copy) NSString * content;
@property(nonatomic,copy)NSString *simpleEvaluate;
@property(nonatomic,copy) NSAttributedString *contentAttributedString;
@property (nonatomic, copy) NSString * item;
@property (nonatomic, copy) NSString * personId;
@property (nonatomic, copy) NSString * classId;
@property (nonatomic, copy) NSString * evaluateItemId;
@property(nonatomic,retain)NSMutableArray *textviewImageArray;

@property(nonatomic,copy)NSString *taskID;
@property(nonatomic,copy)NSString *subject;
@property(nonatomic,copy)NSString *teacherFeature;

@property(nonatomic,copy)NSString *courseType;
@property(nonatomic,copy)NSString *researchDate;
@property(nonatomic,copy)NSString *lesson;
@property(nonatomic,retain)NSMutableArray *courseInfoArray;

@property(nonatomic,retain)NSMutableArray *evaluateLevelArray;


@property(nonatomic,retain)NSMutableArray *evaluateIDArray;


@end
