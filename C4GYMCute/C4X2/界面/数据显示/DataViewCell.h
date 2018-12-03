//
//  DataViewCell.h
//  C4gym
//
//  Created by Hinwa on 2018/10/26.
//  Copyright © 2018 Zhongshan Marvel Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataViewCell : UICollectionViewCell
@property(nonatomic,strong)UIButton *controlButton;
@property(nonatomic,strong)UISwitch *soundSwitch;
@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,strong)UILabel *judgeLabel;
@property(nonatomic,strong)UILabel *extraLabel;
-(void)setCellWithIndex:(int)index Module:(ModuleModel *)module;
-(void)resetCell;
-(void)reloadCellWithModule:(ModuleModel *)module Data:(NSDictionary *)data;
@end
