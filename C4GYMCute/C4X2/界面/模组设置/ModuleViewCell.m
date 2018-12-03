//
//  ModuleViewCell.m
//  C4gym
//
//  Created by Hinwa on 2017/12/25.
//  Copyright © 2017年 Zhongshan Marvel Electronic Technology Co., Ltd. All rights reserved.
//

#import "ModuleViewCell.h"

@implementation ModuleViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *bgView = [[UIView alloc] init];
        bgView.layer.borderWidth = 1;
        bgView.layer.borderColor = [UIColor whiteColor].CGColor;
        bgView.layer.cornerRadius = 10;
        bgView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:bgView];
        bgView.sd_layout
        .topSpaceToView(self.contentView, H_ADAPTER(20))
        .bottomSpaceToView(self.contentView, H_ADAPTER(20))
        .leftSpaceToView(self.contentView, W_ADAPTER(20))
        .rightSpaceToView(self.contentView, W_ADAPTER(20));
        
        _moduleButton = [[UIButton alloc] init];
        _moduleButton.layer.borderWidth = 1;
        _moduleButton.layer.cornerRadius = 10;
        _moduleButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _moduleButton.backgroundColor = [UIColor clearColor];
        [_moduleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _moduleButton.titleLabel.font = [UIFont boldSystemFontOfSize:W_ADAPTER(25)];
        [bgView addSubview:_moduleButton];
        _moduleButton.sd_layout
        .topSpaceToView(bgView, H_ADAPTER(25))
        .leftSpaceToView(bgView, W_ADAPTER(80))
        .rightSpaceToView(bgView, W_ADAPTER(80))
        .heightIs(H_ADAPTER(60));
        
        _surfaceButton = [[UIButton alloc] init];
        _surfaceButton.layer.borderWidth = 1;
        _surfaceButton.layer.cornerRadius = 10;
        _surfaceButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _surfaceButton.backgroundColor = [UIColor clearColor];
        [_surfaceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _surfaceButton.titleLabel.font = [UIFont boldSystemFontOfSize:W_ADAPTER(20)];
        [bgView addSubview:_surfaceButton];
        _surfaceButton.sd_layout
        .topSpaceToView(_moduleButton, H_ADAPTER(35))
        .leftEqualToView(_moduleButton)
        .rightEqualToView(_moduleButton)
        .heightRatioToView(_moduleButton, 1);
        
        _gameButton = [[UIButton alloc] init];
        _gameButton.layer.borderWidth = 1;
        _gameButton.layer.cornerRadius = 10;
        _gameButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _gameButton.backgroundColor = [UIColor clearColor];
        [_gameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _gameButton.titleLabel.font = [UIFont boldSystemFontOfSize:W_ADAPTER(20)];
        [bgView addSubview:_gameButton];
        _gameButton.sd_layout
        .topSpaceToView(_surfaceButton, H_ADAPTER(35))
        .leftEqualToView(_surfaceButton)
        .rightEqualToView(_surfaceButton)
        .heightRatioToView(_surfaceButton, 1);
    }
    return self;
}

-(void)setCellWithIndex:(int)index{
    self.moduleButton.tag = self.gameButton.tag = self.surfaceButton.tag = index;
    ModuleModel *model = [ModuleModel objectsWhere:@"cha = %@",[NSString stringWithFormat:@"%d",index+1]].firstObject;
    if (model.floorCount.length>0) {
        [self.moduleButton setTitle:[NSString stringWithFormat:@"模组%@: %@",model.cha,model.floorCount] forState:UIControlStateNormal];
    }
    else {
        [self.moduleButton setTitle:[NSString stringWithFormat:@"模组%@",model.cha] forState:UIControlStateNormal];
    }
    
    if (model.surface.surfaceName.length>0&&model.surface.surfaceData.length>0) {
        [self.surfaceButton setTitle:[NSString stringWithFormat:@"面层:%@",model.surface.surfaceName] forState:UIControlStateNormal];
    }
    else {
        [self.surfaceButton setTitle:@"面层/音效" forState:UIControlStateNormal];
    }
    
    
    if (model.game.gameName.length>0&&model.game.playerData.length>0) {
        [self.gameButton setTitle:[NSString stringWithFormat:@"课程:%@",model.game.gameName] forState:UIControlStateNormal];
    }
    else {
        [self.gameButton setTitle:@"训练课程" forState:UIControlStateNormal];
    }
}
@end
