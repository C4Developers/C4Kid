//
//  SurfaceModel.m
//  C4gym
//
//  Created by Hinwa on 2018/9/15.
//  Copyright © 2018年 Zhongshan Marvel Electronic Technology Co., Ltd. All rights reserved.
//

#import "SurfaceModel.h"

@implementation SurfaceModel
-(instancetype)initWithFloorCount:(NSString *)floorCount SurfaceName:(NSString *)surfaceName{
    if (self = [super init]) {
        self.floorCount = floorCount;
        self.surfaceName = surfaceName;
        self.surfaceData = @"";
        self.soundName = @"";
    }
    return self;
}
@end
