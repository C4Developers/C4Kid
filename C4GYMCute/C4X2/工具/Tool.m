//
//  Tool.m
//  C4system
//
//  Created by Hinwa on 2017/6/21.
//  Copyright © 2017年 Zhongshan marvel electronic technology co., LTD. All rights reserved.
//

#import "Tool.h"

@implementation Tool

#pragma mark - 创建json字符串
+(NSString *)createJson:(id)object{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingSortedKeys error:&error];
    if (jsonData) {
        jsonString=[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    else {
        NSLog(@"Got an error: %@", error);
    }
    return jsonString;
}

#pragma mark json转数组
+(NSArray *)creatArrWithJSONString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return arr;
}

#pragma mark json转字典
+(NSDictionary *)creatDicWithJSONString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization
                         JSONObjectWithData:jsonData
                         options:NSJSONReadingMutableContainers
                         error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
