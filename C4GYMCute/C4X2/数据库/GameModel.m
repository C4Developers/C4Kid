//
//  GameModel.m
//  C4X1
//
//  Created by 冯宇 on 2018/10/2.
//Copyright © 2018年 冯宇. All rights reserved.
//

#import "GameModel.h"

@implementation GameModel

-(instancetype)initWithFloorCount:(NSString *)floorCount{
    if (self = [super init]) {
        self.floorCount = floorCount;
        self.countOrTime = @"0";
        self.number = @"";
        self.gameName = @"";
        self.playerData = @"";
    }
    return self;
}

-(void)createGameWithName:(NSString *)name Number:(NSString *)number Process:(NSMutableArray *)process{
    [[RLMRealm defaultRealm] beginWriteTransaction];
    self.number = number;
    
    NSMutableArray *processArr = [NSMutableArray array];
    for (StepModel *step in process) {
        [processArr addObject:@{@"color":step.color,
                                @"time":[NSNumber numberWithInt:step.time],
                                @"type":[NSNumber numberWithInt:step.type],
                                @"floorID":step.floorID}];
    }
    self.playerData = [Tool createJson:@[processArr]];
    if (self.gameName.length>0) {
        self.gameName = name;
    }
    else {
        self.gameName = name;
        [[RLMRealm defaultRealm] addObject:self];
    }
    [[RLMRealm defaultRealm] commitWriteTransaction];
}

@end
