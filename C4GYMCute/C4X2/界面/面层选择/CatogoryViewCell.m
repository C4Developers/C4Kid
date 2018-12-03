//
//  CatogoryViewCell.m
//  C4gym
//
//  Created by Hinwa on 2018/10/1.
//  Copyright © 2018年 Zhongshan Marvel Electronic Technology Co., Ltd. All rights reserved.
//

#import "CatogoryViewCell.h"

@interface CatogoryViewCell()
@property(nonatomic,strong)UIImageView *catogoryImage;
@property(nonatomic,strong)UILabel *catogoryTitle;
@end

@implementation CatogoryViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _catogoryImage = [[UIImageView alloc] init];
        _catogoryImage.contentMode = UIViewContentModeScaleAspectFit;
        _catogoryImage.layer.borderWidth = 1;
        _catogoryImage.layer.borderColor = [UIColor blackColor].CGColor;
        _catogoryImage.layer.cornerRadius = 5;
        [self.contentView addSubview:_catogoryImage];
        _catogoryImage.sd_layout.topSpaceToView(self.contentView, 0).leftSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, H_ADAPTER(30));
        
        _catogoryTitle = [[UILabel alloc] init];
        _catogoryTitle.font = [UIFont boldSystemFontOfSize:W_ADAPTER(15)];
        _catogoryTitle.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_catogoryTitle];
        _catogoryTitle.sd_layout.topSpaceToView(_catogoryImage, 0).leftEqualToView(_catogoryImage).rightEqualToView(_catogoryImage).bottomSpaceToView(self.contentView, 0);
    }
    return self;
}

-(void)setCellWithIndex:(int)index andCatogory:(NSString *)catogory{
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SurfaceList" ofType:@"plist"]];
    self.catogoryTitle.text = dict[catogory][index];
    self.catogoryImage.image = [UIImage imageNamed:dict[catogory][index]];
}

@end
