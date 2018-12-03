//
//  SendData.h
//  C4X1
//
//  Created by 冯宇 on 2018/10/1.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameModel.h"

typedef void(^ReceiveBlock)(NSDictionary * data);

@protocol SendDataDelegate <NSObject>
@optional
-(void)receiveData:(NSDictionary *)data;
@end

@interface SendData : NSObject
+(instancetype)shareData;
@property(nonatomic,weak)id<SendDataDelegate>sendDataDelegate;
@property(nonatomic,copy)NSArray *soundArr;
-(void)addReceiveDelegate:(id)sendDataDelegate;
-(void)connectSocket:(ReceiveBlock)receiveBlock;
-(void)sendGamePackageInCha:(NSString *)cha Game:(GameModel *)game mode:(int)mode;
-(void)sendSetIDInCha:(NSString *)cha Receive:(ReceiveBlock)receiveBlock;
-(void)sendStartGameInCha:(NSString *)cha;
-(void)sendPauseGameInCha:(NSString *)cha;
-(void)sendStopGameInCha:(NSString *)cha;
@end
