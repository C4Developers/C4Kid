//
//  DataViewCell.m
//  C4gym
//
//  Created by Hinwa on 2018/10/26.
//  Copyright © 2018 Zhongshan Marvel Electronic Technology Co., Ltd. All rights reserved.
//

#import "DataViewCell.h"

@interface DataViewCell()
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *soundLabel;
@end

@implementation DataViewCell
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
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:W_ADAPTER(30)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:_titleLabel];
        _titleLabel.sd_layout
        .topSpaceToView(bgView, H_ADAPTER(10))
        .leftSpaceToView(bgView, 0)
        .rightSpaceToView(bgView, 0)
        .heightIs(H_ADAPTER(40));
        
        _controlButton = [[UIButton alloc] init];
        _controlButton.titleLabel.font = [UIFont boldSystemFontOfSize:W_ADAPTER(25)];
        _controlButton.layer.borderWidth = 1;
        _controlButton.layer.cornerRadius = 10;
        _controlButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _controlButton.backgroundColor = [UIColor whiteColor];
        [_controlButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_controlButton setTitle:@"开始" forState:UIControlStateNormal];
        [bgView addSubview:_controlButton];
        _controlButton.sd_layout
        .bottomSpaceToView(bgView, H_ADAPTER(20))
        .rightSpaceToView(bgView, W_ADAPTER(50))
        .widthIs(W_ADAPTER(120))
        .heightIs(H_ADAPTER(60));
        
        _soundLabel = [[UILabel alloc] init];
        _soundLabel.text = @"音效开关:";
        _soundLabel.textAlignment = NSTextAlignmentCenter;
        _soundLabel.font = [UIFont boldSystemFontOfSize:W_ADAPTER(25)];
        _soundLabel.textColor = [UIColor whiteColor];
        [bgView addSubview:_soundLabel];
        _soundLabel.sd_layout
        .topEqualToView(_controlButton)
        .leftSpaceToView(bgView, W_ADAPTER(50))
        .bottomEqualToView(_controlButton)
        .widthIs(W_ADAPTER(120));
        
        _soundSwitch = [[UISwitch alloc] init];
        _soundSwitch.on = YES;
        [bgView addSubview:_soundSwitch];
        _soundSwitch.sd_layout
        .bottomSpaceToView(bgView, H_ADAPTER(35))
        .leftSpaceToView(_soundLabel, W_ADAPTER(10));
        
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        [bgView addSubview:_imgView];
        _imgView.sd_layout
        .topSpaceToView(_titleLabel, H_ADAPTER(10))
        .bottomSpaceToView(_controlButton, H_ADAPTER(10))
        .leftSpaceToView(bgView, W_ADAPTER(120))
        .rightSpaceToView(bgView, W_ADAPTER(120));
        
        _extraLabel = [[UILabel alloc] init];
        _extraLabel.numberOfLines = 0;
        _extraLabel.textAlignment = NSTextAlignmentCenter;
        _extraLabel.font = [UIFont boldSystemFontOfSize:W_ADAPTER(25)];
        _extraLabel.textColor = [UIColor whiteColor];
        [bgView addSubview:_extraLabel];
        _extraLabel.sd_layout
        .topEqualToView(_imgView)
        .bottomEqualToView(_imgView)
        .leftSpaceToView(bgView, 0)
        .rightSpaceToView(_imgView, 0);
        
        _judgeLabel = [[UILabel alloc] init];
        _judgeLabel.textAlignment = NSTextAlignmentCenter;
        _judgeLabel.font = [UIFont boldSystemFontOfSize:W_ADAPTER(25)];
        [bgView addSubview:_judgeLabel];
        _judgeLabel.sd_layout
        .topEqualToView(_imgView)
        .bottomEqualToView(_imgView)
        .rightSpaceToView(bgView, 0)
        .leftSpaceToView(_imgView, 0);
    }
    return self;
}

-(void)setCellWithIndex:(int)index Module:(ModuleModel *)module{
    self.controlButton.tag = index+1;
    if (module.game.playerData.length>0&&module.surface.surfaceData.length>0) {
        self.titleLabel.text = [NSString stringWithFormat:@"模组%@   :   %@组",module.cha,module.game.number];
        self.controlButton.hidden = NO;
        self.soundSwitch.hidden = NO;
        self.soundLabel.hidden = NO;
        self.imgView.hidden = NO;
        self.extraLabel.hidden = NO;
        self.judgeLabel.hidden = NO;
    }
    else {
        self.titleLabel.text = [NSString stringWithFormat:@"模组%@",module.cha];
        self.controlButton.hidden = YES;
        self.soundSwitch.hidden = YES;
        self.soundLabel.hidden = YES;
        self.imgView.hidden = YES;
        self.extraLabel.hidden = YES;
        self.judgeLabel.hidden = YES;
    }
}

-(void)resetCell{
    self.imgView.image = nil;
    self.extraLabel.text = @"0组\n0s";
    self.judgeLabel.text = @"";
}

-(void)reloadCellWithModule:(ModuleModel *)module Data:(NSDictionary *)data{
    NSDictionary *surface = [Tool creatDicWithJSONString:module.surface.surfaceData];
    NSString *surfaceName = surface[[NSString stringWithFormat:@"%@",data[@"floorID"]]];
    //图案
    if (surfaceName.length>0) {
        self.imgView.image = [UIImage imageNamed:surfaceName];
    }
    else {
        self.imgView.image = nil;
    }
    
    NSArray *timeArr = data[@"times"];
    if (timeArr.count>0) {
        //组数据
        NSArray *times = data[@"times"];
        self.judgeLabel.text = @"";
        NSRange startRange = [self.extraLabel.text rangeOfString:@"\n"];
        NSRange endRange = [self.extraLabel.text rangeOfString:@"s"];
        NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
        NSString *result = [self.extraLabel.text substringWithRange:range];
        self.extraLabel.text= [NSString stringWithFormat:@"%@组\n%.1fs",data[@"group"],[[times valueForKeyPath:@"@sum.floatValue"] floatValue]+[result floatValue]];
    }
    else {
        //步数据
        if ([data[@"judge"] intValue] == 1) {
            self.judgeLabel.text = @"正确";
            self.judgeLabel.textColor = [UIColor greenColor];
            //正确音效
            if (self.soundSwitch.on&&surfaceName.length>0) {
                NSString *filePath = [[NSBundle mainBundle] pathForResource:[surfaceName capitalizedString] ofType:@"wav"];
                if (filePath) {
                    SystemSoundID soundID;
                    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:filePath], &soundID);
                    AudioServicesPlaySystemSound(soundID);
                    
                    AudioServicesPlaySystemSoundWithCompletion(soundID, ^{
                        // 释放音效内存
                        AudioServicesDisposeSystemSoundID(soundID);
                    });
                }
            }
        }
        else {
            self.judgeLabel.text = @"错误";
            self.judgeLabel.textColor = [UIColor redColor];
            if (self.soundSwitch.on&&module.surface.soundName.length>0) {
                NSString *filePath = [[NSBundle mainBundle] pathForResource:module.surface.soundName ofType:@"wav"];
                if (filePath) {
                    SystemSoundID soundID;
                    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:filePath], &soundID);
                    AudioServicesPlaySystemSound(soundID);
                    
                    AudioServicesPlaySystemSoundWithCompletion(soundID, ^{
                        // 释放音效内存
                        AudioServicesDisposeSystemSoundID(soundID);
                    });
                }
            }
        }
    }
}

@end
