//
//  ModuleModel.h
//  C4gym
//
//  Created by Hinwa on 2017/9/6.
//  Copyright © 2017年 Zhongshan Marvel Electronic Technology Co., Ltd. All rights reserved.
//

#import <Realm/Realm.h>
#import "GameModel.h"
#import "SurfaceModel.h"

@interface ModuleModel : RLMObject
//编号ID
@property NSString *cha;
//地板个数
@property NSString *floorCount;
//游戏数据
@property GameModel *game;
//面层数据
@property SurfaceModel *surface;
-(instancetype)initWithCha:(NSString *)cha;
@end
