//
//  AppDelegate.m
//  C4X2
//
//  Created by Hinwa on 2018/10/30.
//  Copyright © 2018 Hinwa. All rights reserved.
//

#import "AppDelegate.h"
#import "NavigationController.h"
#import "ConnectionViewController.h"
#import "AvoidCrash.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //屏幕常亮处理
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];

    //数据库迁移
    [self updateDataBase];
    
    //启动防止崩溃功能
    [AvoidCrash becomeEffective];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithCrashMessage:) name:AvoidCrashNotification object:nil];
    
    ConnectionViewController *connectionVC = [[ConnectionViewController alloc] init];
    NavigationController *nc = [[NavigationController alloc] initWithRootViewController:connectionVC];
    self.window.rootViewController = nc;
    
    NSLog(@"%@",[RLMRealmConfiguration defaultConfiguration].fileURL);
    return YES;
}

-(void)updateDataBase{
    // 在 [AppDelegate didFinishLaunchingWithOptions:] 中进行配置
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    // 设置新的架构版本。这个版本号必须高于之前所用的版本号（如果您之前从未设置过架构版本，那么这个版本号设置为 0）
    config.schemaVersion = 0;
    // 设置闭包，这个闭包将会在打开低于上面所设置版本号的 Realm 数据库的时候被自动调用
    config.migrationBlock = ^(RLMMigration * migration, uint64_t oldSchemaVersion) {
        
    };
    // 告诉 Realm 为默认的 Realm 数据库使用这个新的配置对象
    [RLMRealmConfiguration setDefaultConfiguration:config];
    // 现在我们已经告诉了 Realm 如何处理架构的变化，打开文件之后将会自动执行迁移
}

#pragma mark - 防崩溃
- (void)dealwithCrashMessage:(NSNotification *)note {
    //不论在哪个线程中导致的crash，这里都是在主线程
    //注意:所有的信息都在userInfo中
    //你可以在这里收集相应的崩溃信息进行相应的处理(比如传到自己服务器)
    NSLog(@"崩溃信息:\n\n在AppDelegate中 方法:dealwithCrashMessage打印\n\n\n\n\n%@\n\n\n\n",note.userInfo);
}

@end
