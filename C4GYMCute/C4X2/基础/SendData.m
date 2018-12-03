//
//  SendData.m
//  C4X1
//
//  Created by 冯宇 on 2018/10/1.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import "SendData.h"

#define HEAD @"<start>"
#define TAIL @"<over>"

@interface SendData()<GCDAsyncSocketDelegate,NSCopying,NSMutableCopying>{
    NSTimer *heartBeat;
}
@property(nonatomic,strong)GCDAsyncSocket *socket;
@property(nonatomic,copy)NSString *jsonStr;
@property(nonatomic,copy)ReceiveBlock receiveBlock;
@property(nonatomic,assign)BOOL isFirstconnect;
@end

@implementation SendData


static SendData * single;

+(instancetype)shareData
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        single = [[SendData alloc] init];
    });
    return single;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        single = [super allocWithZone:zone];
    });
    return single;
}

-(id)copyWithZone:(NSZone *)zone{
    return single;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    return single;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        _soundArr = @[@"再接再厉",@"加油",@"太棒了",@"good",@"啊哦",@"你答对了",@"你答错了",@"很遗憾下次加油哦",@"爆炸声音",@"闯关失败",@"噔",@"嘟嘟错误音效",@"峰鸣警报",@"错误提示",@"模式切换按钮的音效",@"哦喔",@"正确提示",@"biu警报声",@"OH~NO!"];
        _isFirstconnect = YES;
    }
    return self;
}

-(void)connectSocket:(ReceiveBlock)receiveBlock{
    self.receiveBlock = receiveBlock;
    NSError *error = nil;
    if (![self.socket connectToHost:@"192.168.4.1" onPort:10000 error:&error]) {
        self.receiveBlock(@{@"connect":@"false"});
    }
}

#pragma mark - 连接成功
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    @weakify(self);
    heartBeat = [NSTimer scheduledTimerWithTimeInterval:5 repeats:YES block:^(NSTimer * _Nonnull timer) {
        @strongify(self)
        [self sendJsonStr:@"heartbeat"];
    }];
    [[NSRunLoop currentRunLoop] addTimer:heartBeat forMode:NSRunLoopCommonModes];
    if (self.isFirstconnect) {
        self.receiveBlock(@{@"connect":@"true"});
    }
    [self sendCheckMainSta];
    [self.socket readDataWithTimeout:-1 tag:0];
}

#pragma mark 连接断开
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"断开重连");
    [heartBeat invalidate];
    heartBeat = nil;
    self.isFirstconnect = NO;
    NSError *error = nil;
    if (![self.socket connectToHost:@"192.168.4.1" onPort:10000 error:&error]) {
        self.receiveBlock(@{@"connect":@"false"});
    }
}

#pragma mark 接收数据
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSString * jsonStr = [[NSString alloc] initWithData:data encoding:kCFStringEncodingUTF8];
    if (self.jsonStr) {
        jsonStr = [NSString stringWithFormat:@"%@%@",self.jsonStr,jsonStr];
    }
    
    //查找数据位置大小
    NSRange headRange = [jsonStr rangeOfString:HEAD];
    NSRange tailRange = [jsonStr rangeOfString:TAIL];
    
    //无头无尾 不处理
    if (headRange.location == NSNotFound ||
        tailRange.location == NSNotFound ){
        return;
    }
    
    int headIndex = (int)headRange.location;
    int tailIndex = (int)tailRange.location + (int)tailRange.length;
    int dataLength = tailIndex - headIndex;
    NSRange strRange = NSMakeRange(headIndex, dataLength);
    
    //长度过短 不处理
    if (jsonStr.length < tailIndex) {
        return;
    }
    
    NSString * currentStr = [jsonStr substringWithRange:strRange];
    
    if (jsonStr.length > tailIndex) {
        self.jsonStr = [jsonStr substringFromIndex:tailIndex];
    }
    else{
        self.jsonStr = @"";
    }
    
    if ([currentStr hasPrefix:HEAD]&&[jsonStr hasSuffix:TAIL]) {
        //完整数据
        NSString * dataStr = [jsonStr componentsSeparatedByString:HEAD].lastObject;
        dataStr = [dataStr componentsSeparatedByString:TAIL].firstObject;
        NSData * data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"接收数据:%@",dict);
        if ([dict[@"api"] isEqualToString:@"setId"]) {
            self.receiveBlock(dict);
        }
        else if ([dict[@"api"] isEqualToString:@"getMainSta"]) {
            //查询版本
            if (![dict[@"flag"] isEqualToString:@"true"]||[dict[@"mode"] intValue] != 0) {
                [SVProgressHUD showInfoWithStatus:@"该Wifi不正确,请重新选择"];
            }
        }
        else {
            [self.sendDataDelegate receiveData:dict];
        }
    }
    [self.socket readDataWithTimeout:-1 tag:0];
}

#pragma mark - 发送数据
-(void)sendJsonStr:(NSString *)jsonStr{
    NSString *dataJson = [NSString stringWithFormat:@"<start>%@<over>",jsonStr];
    NSLog(@"发送数据:%@",dataJson);
    if (dataJson.length>=3500) {
        [SVProgressHUD showInfoWithStatus:@"数据包过大,请重新设置"];
    }
    else {
        [self.socket writeData:[dataJson dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    }
}

#pragma mark 发送游戏包
-(void)sendGamePackageInCha:(NSString *)cha Game:(GameModel *)game mode:(int)mode{
    [self sendJsonStr:[Tool createJson:@{@"api":@"setGamePag",
                                         @"cha":[NSNumber numberWithInt:[cha intValue]],
                                         @"countOrTime":[NSNumber numberWithInt:[game.countOrTime intValue]],
                                         @"number":[NSNumber numberWithInt:[game.number intValue]],
                                         @"mode":[NSNumber numberWithInt:mode],
                                         @"playerData":[Tool creatArrWithJSONString:game.playerData]}]];
}

#pragma mark 重置ID
-(void)sendSetIDInCha:(NSString *)cha Receive:(ReceiveBlock)receiveBlock{
    [self sendJsonStr:[Tool createJson:@{@"api":@"setId",
                                         @"cha":[NSNumber numberWithInt:[cha intValue]]}]];
    self.receiveBlock = receiveBlock;
}

#pragma mark 开始游戏
-(void)sendStartGameInCha:(NSString *)cha{
    [self sendJsonStr:[Tool createJson:@{@"api":@"startGame",
                                         @"cha":[NSNumber numberWithInt:[cha intValue]]}]];
}

#pragma mark 暂停游戏
-(void)sendPauseGameInCha:(NSString *)cha{
    [self sendJsonStr:[Tool createJson:@{@"api":@"pauseGame",
                                         @"cha":[NSNumber numberWithInt:[cha intValue]]}]];
}

#pragma mark 结束游戏
-(void)sendStopGameInCha:(NSString *)cha{
    [self sendJsonStr:[Tool createJson:@{@"api":@"stopGame",
                                         @"cha":[NSNumber numberWithInt:[cha intValue]]}]];
}

#pragma mark 查询主机版本
-(void)sendCheckMainSta{
    [self sendJsonStr:[Tool createJson:@{@"api":@"getMainSta"}]];
}

#pragma mark 接收数据
-(void)addReceiveDelegate:(id)sendDataDelegate{
    self.sendDataDelegate = sendDataDelegate;
}
@end
