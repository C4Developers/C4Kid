//
//  ModuleModel.m
//  C4gym
//
//  Created by Hinwa on 2017/9/6.
//  Copyright © 2017年 Zhongshan Marvel Electronic Technology Co., Ltd. All rights reserved.
//

#import "ModuleModel.h"

@implementation ModuleModel

+ (NSString *)primaryKey
{
    return @"cha";
}

-(instancetype)initWithCha:(NSString *)cha{
    if (self = [super init]) {
        self.cha = cha;
        self.floorCount = @"";
        self.game = nil;
        self.surface = nil;
    }
    return self;
}

@end
