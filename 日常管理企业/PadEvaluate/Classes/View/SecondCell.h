//
//  SecondCell.h
//  PadEvaluate
//
//  Created by hzth-mac3 on 15/12/15.
//  Copyright © 2015年 hzth-mac3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *evaluateName;

@property (weak, nonatomic) IBOutlet UILabel *unEvaluate;

@property (nonatomic, weak) NSString * ID;

@property (weak, nonatomic) IBOutlet UILabel *stepName;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
