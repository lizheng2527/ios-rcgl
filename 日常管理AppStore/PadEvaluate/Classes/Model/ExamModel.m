//
//  ExamModel.m
//  PadEvaluate
//
//  Created by 中电和讯 on 2018/3/13.
//  Copyright © 2018年 hzth-mac3. All rights reserved.
//

#import "ExamModel.h"

@implementation ExamModel


- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.note forKey:@"note"];
    [aCoder encodeObject:self.imageArray forKey:@"imageArray"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.note = [aDecoder decodeObjectForKey:@"note"];
        self.imageArray = [NSMutableArray arrayWithArray:[aDecoder decodeObjectForKey:@"imageArray"]] ;
    }
    return self;
}



@end
