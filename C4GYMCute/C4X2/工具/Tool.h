//
//  Tool.h
//  C4system
//
//  Created by Hinwa on 2017/6/21.
//  Copyright © 2017年 Zhongshan marvel electronic technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tool : NSObject
+(NSString *)createJson:(id)object;
+(NSArray *)creatArrWithJSONString:(NSString *)jsonString;
+(NSDictionary *)creatDicWithJSONString:(NSString *)jsonString;
@end
