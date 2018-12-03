//
//  GameModel.h
//  C4X1
//
//  Created by 冯宇 on 2018/10/2.
//Copyright © 2018年 冯宇. All rights reserved.
//

#import <Realm/Realm.h>

@interface GameModel : RLMObject
//地板个数
@property NSString *floorCount;
//游戏名称
@property NSString *gameName;
//定次0/定时0
@property NSString *countOrTime;
//组/秒
@property NSString *number;
//游戏包
@property NSString *playerData;
-(instancetype)initWithFloorCount:(NSString *)floorCount;
-(void)createGameWithName:(NSString *)name Number:(NSString *)number Process:(NSMutableArray *)process;
@end

