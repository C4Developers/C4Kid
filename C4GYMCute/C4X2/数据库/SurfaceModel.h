//
//  SurfaceModel.h
//  C4gym
//
//  Created by Hinwa on 2018/9/15.
//  Copyright © 2018年 Zhongshan Marvel Electronic Technology Co., Ltd. All rights reserved.
//

#import <Realm/Realm.h>

@interface SurfaceModel : RLMObject
//地板个数
@property NSString *floorCount;
//面层名称
@property NSString *surfaceName;
//面层数据
@property NSString *surfaceData;
//音效
@property NSString *soundName;
-(instancetype)initWithFloorCount:(NSString *)floorCount SurfaceName:(NSString *)surfaceName;
@end
