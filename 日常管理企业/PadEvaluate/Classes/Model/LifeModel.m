//
//  LifeModel.m
//  PadEvaluate
//
//  Created by hzth-mac3 on 15/12/18.
//  Copyright © 2015年 hzth-mac3. All rights reserved.
//

#import "LifeModel.h"
#import "MJExtension.h"
#import "SubLifeModel.h"

@implementation LifeModel
- (NSDictionary *)objectClassInArray
{
    
    return @{@"levels":[SubLifeModel class]};
}
#pragma mark - NSCoding
//- (void)encodeWithCoder:(NSCoder *)aCoder {
//    [aCoder encodeObject:self.id forKey:@"id"];
////    [aCoder encodeInteger:self.levels forKey:@"levels"];
//    [aCoder encodeObject:self.name forKey:@"name"];
//    [aCoder encodeObject:self.note forKey:@"note"];
//    
//    [aCoder encodeObject:self.maxscore forKey:@"maxscore"];
//    
//    [aCoder encodeObject:self.minscore forKey:@"minscore"];
//}
//
//- (id)initWithCoder:(NSCoder *)aDecoder {
//    if (self = [super init]) {
//        self.id = [aDecoder decodeObjectForKey:@"id"];
//        self.note = [aDecoder decodeObjectForKey:@"note"];
//        self.name = [aDecoder decodeObjectForKey:@"name"];
//        self.maxscore = [aDecoder decodeObjectForKey:@"maxscore"];
//        
//        self.minscore = [aDecoder decodeObjectForKey:@"minscore"];
//    }
//    return self;
//}



@end
