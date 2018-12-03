//
//  ColorViewCell.m
//  C4gym
//
//  Created by Hinwa on 2018/10/25.
//  Copyright © 2018 Zhongshan Marvel Electronic Technology Co., Ltd. All rights reserved.
//

#import "ColorViewCell.h"

@implementation ColorViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.colorButton = [[UIButton alloc] init];
        self.colorButton.layer.cornerRadius = 10;
        [self.colorButton setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateSelected];
        self.colorButton.layer.shadowColor = [UIColor blackColor].CGColor;
        self.colorButton.layer.borderWidth = 1;
        [self.contentView addSubview:self.colorButton];
        self.colorButton.sd_layout
        .topSpaceToView(self.contentView, H_ADAPTER(10))
        .bottomSpaceToView(self.contentView, H_ADAPTER(10))
        .leftSpaceToView(self.contentView, W_ADAPTER(10))
        .rightSpaceToView(self.contentView, W_ADAPTER(10));
    }
    return self;
}

-(void)setCellWithIndex:(int)index{
    self.colorButton.tag = index+1;
    switch (index+1) {
        case 1:
            self.colorButton.backgroundColor = [UIColor redColor];
            break;
        case 2:
            self.colorButton.backgroundColor = [UIColor orangeColor];
            break;
        case 3:
            self.colorButton.backgroundColor = [UIColor yellowColor];
            break;
        case 4:
            self.colorButton.backgroundColor = [UIColor greenColor];
            break;
        case 5:
            self.colorButton.backgroundColor = [UIColor blueColor];
            break;
        case 6:
            self.colorButton.backgroundColor = [UIColor purpleColor];
            break;
        default:
            self.colorButton.backgroundColor = [UIColor whiteColor];
            break;
    }
}

@end
