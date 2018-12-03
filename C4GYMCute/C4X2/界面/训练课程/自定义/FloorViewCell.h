//
//  FloorViewCell.h
//  C4gym
//
//  Created by Hinwa on 2018/10/24.
//  Copyright © 2018 Zhongshan Marvel Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FloorViewCell : UITableViewCell
-(void)setCellWithIndex:(int)index Model:(ModuleModel *)model Arr:(NSMutableArray *)floorArr;
@end
