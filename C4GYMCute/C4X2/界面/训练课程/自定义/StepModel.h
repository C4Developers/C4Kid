//
//  StepModel.h
//  C4gym
//
//  Created by Hinwa on 2018/10/24.
//  Copyright © 2018 Zhongshan Marvel Electronic Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StepModel : NSObject
@property(nonatomic,copy)NSString *color;
@property(nonatomic,assign)int time;
@property(nonatomic,assign)int type;
@property(nonatomic,strong)NSMutableArray *floorID;
+(instancetype)dataModelWithDict:(NSDictionary *)dict;
+(StepModel *)addStepWithColor:(int)color Type:(NSString *)type Time:(NSString *)time FloorID:(NSMutableArray *)floorID;
@end
