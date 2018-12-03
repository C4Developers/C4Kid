//
//  StepModel.m
//  C4gym
//
//  Created by Hinwa on 2018/10/24.
//  Copyright © 2018 Zhongshan Marvel Electronic Technology Co., Ltd. All rights reserved.
//

#import "StepModel.h"

@implementation StepModel
-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        if (dict[@"color"]) {
            self.color = dict[@"color"];
        }
        else {
            self.color = @"white";
        }
        if (dict[@"time"]) {
            self.time = [dict[@"time"] intValue];
        }
        else {
            self.time = 0;
        }
        if (dict[@"type"]) {
            self.type = [dict[@"type"] intValue];
        }
        else {
            self.type = 0;
        }
        NSArray *floorID = dict[@"floorID"];
        if (floorID.count>0) {
            self.floorID = [NSMutableArray arrayWithArray:floorID];
        }
        else {
            self.floorID = [NSMutableArray array];
        }
    }
    return self;
}
+(instancetype)dataModelWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

+(StepModel *)addStepWithColor:(int)color Type:(NSString *)type Time:(NSString *)time FloorID:(NSMutableArray *)floorID{
    StepModel *step = [[StepModel alloc] init];
    switch (color) {
        case 1:
            step.color = @"red";
            break;
        case 2:
            step.color = @"orange";
            break;
        case 3:
            step.color = @"yellow";
            break;
        case 4:
            step.color = @"green";
            break;
        case 5:
            step.color = @"blue";
            break;
        case 6:
            step.color = @"purple";
            break;
        default:
            step.color = @"white";
            break;
    }
    
    if ([type isEqualToString:@"正常"]) {
        step.type = 0;
    }
    else if ([type isEqualToString:@"呼吸灯"]) {
        step.type = 1;
    }
    else {
        step.type = 2;
    }
    
    step.time = [[time substringToIndex:time.length-1] intValue];
    step.floorID = [NSMutableArray arrayWithArray:floorID];
    return step;
}

@end
