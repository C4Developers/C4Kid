//
//  ColorViewCell.h
//  C4gym
//
//  Created by Hinwa on 2018/10/25.
//  Copyright © 2018 Zhongshan Marvel Electronic Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorViewCell : UICollectionViewCell
@property(nonatomic,strong)UIButton *colorButton;
-(void)setCellWithIndex:(int)index;
@end

