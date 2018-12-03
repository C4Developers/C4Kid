//
//  ModuleViewCell.h
//  C4gym
//
//  Created by Hinwa on 2017/12/25.
//  Copyright © 2017年 Zhongshan Marvel Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModuleViewCell : UICollectionViewCell
@property(nonatomic,strong)UIButton *moduleButton;
@property(nonatomic,strong)UIButton *surfaceButton;
@property(nonatomic,strong)UIButton *gameButton;
-(void)setCellWithIndex:(int)index;
@end
